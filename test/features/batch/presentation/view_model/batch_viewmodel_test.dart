import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lost_n_found/core/error/failures.dart';
import 'package:lost_n_found/features/batch/domain/entities/batch_entity.dart';
import 'package:lost_n_found/features/batch/domain/usecases/create_batch_usecase.dart';
import 'package:lost_n_found/features/batch/domain/usecases/delete_batch_usecase.dart';
import 'package:lost_n_found/features/batch/domain/usecases/get_all_batch_usecase.dart';
import 'package:lost_n_found/features/batch/domain/usecases/get_batch_byid_usecase.dart';
import 'package:lost_n_found/features/batch/domain/usecases/update_batch_usecase.dart';
import 'package:lost_n_found/features/batch/presentation/state/batch_state.dart';
import 'package:lost_n_found/features/batch/presentation/view_model/batch_viewmodel.dart';
import 'package:mocktail/mocktail.dart';

class MockGetAllBatchUsecase extends Mock implements GetAllBatchUsecase {}

class MockGetBatchByIdUsecase extends Mock implements GetBatchByIdUsecase {}

class MockCreateBatchUsecase extends Mock implements CreateBatchUsecase {}

class MockUpdateBatchUsecase extends Mock implements UpdateBatchUsecase {}

class MockDeleteBatchUsecase extends Mock implements DeleteBatchUsecase {}

void main() {
  late MockGetAllBatchUsecase mockGetAllBatchUsecase;
  late MockGetBatchByIdUsecase mockGetBatchByIdUsecase;
  late MockCreateBatchUsecase mockCreateBatchUsecase;
  late MockUpdateBatchUsecase mockUpdateBatchUsecase;
  late MockDeleteBatchUsecase mockDeleteBatchUsecase;
  late ProviderContainer container;

  setUpAll(() {
    registerFallbackValue(const CreateBatchParams(batchName: 'fallback'));
    registerFallbackValue(const GetBatchByIdParams(batchId: 'fallback'));
    registerFallbackValue(
      const UpdateBatchParams(batchId: 'fallback', batchName: 'fallback'),
    );
    registerFallbackValue(const DeleteBatchParams(batchId: 'fallback'));
  });

  setUp(() {
    mockGetAllBatchUsecase = MockGetAllBatchUsecase();
    mockGetBatchByIdUsecase = MockGetBatchByIdUsecase();
    mockCreateBatchUsecase = MockCreateBatchUsecase();
    mockUpdateBatchUsecase = MockUpdateBatchUsecase();
    mockDeleteBatchUsecase = MockDeleteBatchUsecase();

    container = ProviderContainer(
      overrides: [
        getAllBatchUsecaseProvider.overrideWithValue(mockGetAllBatchUsecase),
        getBatchByIdUsecaseProvider.overrideWithValue(mockGetBatchByIdUsecase),
        createBatchUsecaseProvider.overrideWithValue(mockCreateBatchUsecase),
        updateBatchUsecaseProvider.overrideWithValue(mockUpdateBatchUsecase),
        deleteBatchUsecaseProvider.overrideWithValue(mockDeleteBatchUsecase),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  final tBatches = [
    const BatchEntity(batchId: '1', batchName: 'Batch 1', status: 'active'),
    const BatchEntity(batchId: '2', batchName: 'Batch 2', status: 'active'),
  ];

  const tBatch = BatchEntity(
    batchId: '1',
    batchName: 'Test Batch',
    status: 'active',
  );

  group('BatchViewModel', () {
    group('initial state', () {
      test('should have initial state when created', () {
        // Act
        final state = container.read(batchViewModelProvider);

        // Assert
        expect(state.status, BatchStatus.initial);
        expect(state.batches, isEmpty);
        expect(state.selectedBatch, isNull);
        expect(state.errorMessage, isNull);
      });
    });

    group('getAllBatches', () {
      test('should emit loading then loaded state when successful', () async {
        // Arrange
        when(
          () => mockGetAllBatchUsecase(),
        ).thenAnswer((_) async => Right(tBatches));

        final viewModel = container.read(batchViewModelProvider.notifier);

        // Act
        await viewModel.getAllBatches();

        // Assert
        final state = container.read(batchViewModelProvider);
        expect(state.status, BatchStatus.loaded);
        expect(state.batches, tBatches);
        verify(() => mockGetAllBatchUsecase()).called(1);
      });

      test('should emit loading then error state when failed', () async {
        // Arrange
        const failure = ApiFailure(message: 'Failed to fetch batches');
        when(
          () => mockGetAllBatchUsecase(),
        ).thenAnswer((_) async => const Left(failure));

        final viewModel = container.read(batchViewModelProvider.notifier);

        // Act
        await viewModel.getAllBatches();

        // Assert
        final state = container.read(batchViewModelProvider);
        expect(state.status, BatchStatus.error);
        expect(state.errorMessage, 'Failed to fetch batches');
        verify(() => mockGetAllBatchUsecase()).called(1);
      });
    });

    group('getBatchById', () {
      test(
        'should emit loading then loaded state with selectedBatch when successful',
        () async {
          // Arrange
          when(
            () => mockGetBatchByIdUsecase(any()),
          ).thenAnswer((_) async => const Right(tBatch));

          final viewModel = container.read(batchViewModelProvider.notifier);

          // Act
          await viewModel.getBatchById('1');

          // Assert
          final state = container.read(batchViewModelProvider);
          expect(state.status, BatchStatus.loaded);
          expect(state.selectedBatch, tBatch);
          verify(() => mockGetBatchByIdUsecase(any())).called(1);
        },
      );

      test('should emit error state when failed', () async {
        // Arrange
        const failure = ApiFailure(message: 'Batch not found');
        when(
          () => mockGetBatchByIdUsecase(any()),
        ).thenAnswer((_) async => const Left(failure));

        final viewModel = container.read(batchViewModelProvider.notifier);

        // Act
        await viewModel.getBatchById('1');

        // Assert
        final state = container.read(batchViewModelProvider);
        expect(state.status, BatchStatus.error);
        expect(state.errorMessage, 'Batch not found');
      });
    });

    group('createBatch', () {
      test(
        'should emit created state and refresh batches when successful',
        () async {
          // Arrange
          when(
            () => mockCreateBatchUsecase(any()),
          ).thenAnswer((_) async => const Right(true));
          when(
            () => mockGetAllBatchUsecase(),
          ).thenAnswer((_) async => Right(tBatches));

          final viewModel = container.read(batchViewModelProvider.notifier);

          // Act
          await viewModel.createBatch('New Batch');

          // Assert
          verify(() => mockCreateBatchUsecase(any())).called(1);
          verify(() => mockGetAllBatchUsecase()).called(1);
        },
      );

      test('should emit error state when creation fails', () async {
        // Arrange
        const failure = ApiFailure(message: 'Failed to create batch');
        when(
          () => mockCreateBatchUsecase(any()),
        ).thenAnswer((_) async => const Left(failure));

        final viewModel = container.read(batchViewModelProvider.notifier);

        // Act
        await viewModel.createBatch('New Batch');

        // Assert
        final state = container.read(batchViewModelProvider);
        expect(state.status, BatchStatus.error);
        expect(state.errorMessage, 'Failed to create batch');
        verify(() => mockCreateBatchUsecase(any())).called(1);
        verifyNever(() => mockGetAllBatchUsecase());
      });
    });

    group('updateBatch', () {
      test(
        'should emit updated state and refresh batches when successful',
        () async {
          // Arrange
          when(
            () => mockUpdateBatchUsecase(any()),
          ).thenAnswer((_) async => const Right(true));
          when(
            () => mockGetAllBatchUsecase(),
          ).thenAnswer((_) async => Right(tBatches));

          final viewModel = container.read(batchViewModelProvider.notifier);

          // Act
          await viewModel.updateBatch(batchId: '1', batchName: 'Updated Batch');

          // Assert
          verify(() => mockUpdateBatchUsecase(any())).called(1);
          verify(() => mockGetAllBatchUsecase()).called(1);
        },
      );

      test('should pass status when provided', () async {
        // Arrange
        UpdateBatchParams? capturedParams;
        when(() => mockUpdateBatchUsecase(any())).thenAnswer((invocation) {
          capturedParams =
              invocation.positionalArguments[0] as UpdateBatchParams;
          return Future.value(const Right(true));
        });
        when(
          () => mockGetAllBatchUsecase(),
        ).thenAnswer((_) async => Right(tBatches));

        final viewModel = container.read(batchViewModelProvider.notifier);

        // Act
        await viewModel.updateBatch(
          batchId: '1',
          batchName: 'Updated Batch',
          status: 'inactive',
        );

        // Assert
        expect(capturedParams?.status, 'inactive');
      });

      test('should emit error state when update fails', () async {
        // Arrange
        const failure = ApiFailure(message: 'Failed to update batch');
        when(
          () => mockUpdateBatchUsecase(any()),
        ).thenAnswer((_) async => const Left(failure));

        final viewModel = container.read(batchViewModelProvider.notifier);

        // Act
        await viewModel.updateBatch(batchId: '1', batchName: 'Updated Batch');

        // Assert
        final state = container.read(batchViewModelProvider);
        expect(state.status, BatchStatus.error);
        expect(state.errorMessage, 'Failed to update batch');
        verify(() => mockUpdateBatchUsecase(any())).called(1);
        verifyNever(() => mockGetAllBatchUsecase());
      });
    });

    group('deleteBatch', () {
      test(
        'should emit deleted state and refresh batches when successful',
        () async {
          // Arrange
          when(
            () => mockDeleteBatchUsecase(any()),
          ).thenAnswer((_) async => const Right(true));
          when(
            () => mockGetAllBatchUsecase(),
          ).thenAnswer((_) async => Right(tBatches));

          final viewModel = container.read(batchViewModelProvider.notifier);

          // Act
          await viewModel.deleteBatch('1');

          // Assert
          verify(() => mockDeleteBatchUsecase(any())).called(1);
          verify(() => mockGetAllBatchUsecase()).called(1);
        },
      );

      test('should emit error state when deletion fails', () async {
        // Arrange
        const failure = ApiFailure(message: 'Failed to delete batch');
        when(
          () => mockDeleteBatchUsecase(any()),
        ).thenAnswer((_) async => const Left(failure));

        final viewModel = container.read(batchViewModelProvider.notifier);

        // Act
        await viewModel.deleteBatch('1');

        // Assert
        final state = container.read(batchViewModelProvider);
        expect(state.status, BatchStatus.error);
        expect(state.errorMessage, 'Failed to delete batch');
        verify(() => mockDeleteBatchUsecase(any())).called(1);
        verifyNever(() => mockGetAllBatchUsecase());
      });
    });

    group('clearError', () {
      test('should clear error message', () async {
        // Arrange
        const failure = ApiFailure(message: 'Some error');
        when(
          () => mockGetAllBatchUsecase(),
        ).thenAnswer((_) async => const Left(failure));

        final viewModel = container.read(batchViewModelProvider.notifier);
        await viewModel.getAllBatches();

        // Verify error is set
        var state = container.read(batchViewModelProvider);
        expect(state.errorMessage, 'Some error');

        // Act
        viewModel.clearError();

        // Assert
        state = container.read(batchViewModelProvider);
        expect(state.errorMessage, isNull);
      });
    });

    group('clearSelectedBatch', () {
      test('should clear selected batch', () async {
        // Arrange
        when(
          () => mockGetBatchByIdUsecase(any()),
        ).thenAnswer((_) async => const Right(tBatch));

        final viewModel = container.read(batchViewModelProvider.notifier);
        await viewModel.getBatchById('1');

        // Verify selectedBatch is set
        var state = container.read(batchViewModelProvider);
        expect(state.selectedBatch, tBatch);

        // Act
        viewModel.clearSelectedBatch();

        // Assert
        state = container.read(batchViewModelProvider);
        expect(state.selectedBatch, isNull);
      });
    });
  });

  group('BatchState', () {
    test('should have correct initial values', () {
      // Arrange
      const state = BatchState();

      // Assert
      expect(state.status, BatchStatus.initial);
      expect(state.batches, isEmpty);
      expect(state.selectedBatch, isNull);
      expect(state.errorMessage, isNull);
    });

    test('copyWith should update specified fields', () {
      // Arrange
      const state = BatchState();

      // Act
      final newState = state.copyWith(
        status: BatchStatus.loaded,
        batches: tBatches,
      );

      // Assert
      expect(newState.status, BatchStatus.loaded);
      expect(newState.batches, tBatches);
      expect(newState.selectedBatch, isNull);
      expect(newState.errorMessage, isNull);
    });

    test(
      'copyWith should clear selectedBatch when clearSelectedBatch is true',
      () {
        // Arrange
        const state = BatchState(selectedBatch: tBatch);

        // Act
        final newState = state.copyWith(clearSelectedBatch: true);

        // Assert
        expect(newState.selectedBatch, isNull);
      },
    );

    test(
      'copyWith should clear errorMessage when clearErrorMessage is true',
      () {
        // Arrange
        const state = BatchState(errorMessage: 'Some error');

        // Act
        final newState = state.copyWith(clearErrorMessage: true);

        // Assert
        expect(newState.errorMessage, isNull);
      },
    );

    test('props should contain all fields', () {
      // Arrange
      const state = BatchState(
        status: BatchStatus.loaded,
        batches: [],
        selectedBatch: tBatch,
        errorMessage: 'error',
      );

      // Assert
      expect(state.props, [BatchStatus.loaded, [], tBatch, 'error']);
    });
  });
}
