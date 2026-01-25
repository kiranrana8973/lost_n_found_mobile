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
    registerFallbackValue(const DeleteBatchParams(batchId: 'fallback'));
    registerFallbackValue(const GetBatchByIdParams(batchId: 'fallback'));
    registerFallbackValue(
      const UpdateBatchParams(batchId: 'fallback', batchName: 'fallback'),
    );
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

  group('BatchViewModel', () {
    group('initial state', () {
      test('should have initial status and empty batches', () {
        final state = container.read(batchViewModelProvider);

        expect(state.status, BatchStatus.initial);
        expect(state.batches, isEmpty);
        expect(state.selectedBatch, isNull);
        expect(state.errorMessage, isNull);
      });
    });

    group('getAllBatches', () {
      final tBatches = [
        const BatchEntity(batchId: '1', batchName: 'Batch 1', status: 'active'),
        const BatchEntity(
          batchId: '2',
          batchName: 'Batch 2',
          status: 'inactive',
        ),
      ];

      test('should update state to loaded with batches on success', () async {
        when(
          () => mockGetAllBatchUsecase(),
        ).thenAnswer((_) async => Right(tBatches));

        await container.read(batchViewModelProvider.notifier).getAllBatches();
        final state = container.read(batchViewModelProvider);

        expect(state.status, BatchStatus.loaded);
        expect(state.batches, tBatches);
        verify(() => mockGetAllBatchUsecase()).called(1);
      });

      test('should update state to error on failure', () async {
        when(() => mockGetAllBatchUsecase()).thenAnswer(
          (_) async => const Left(LocalDatabaseFailure(message: 'Error')),
        );

        await container.read(batchViewModelProvider.notifier).getAllBatches();
        final state = container.read(batchViewModelProvider);

        expect(state.status, BatchStatus.error);
        expect(state.errorMessage, 'Error');
      });
    });

    group('getBatchById', () {
      const tBatchId = '123';
      const tBatch = BatchEntity(
        batchId: tBatchId,
        batchName: 'Test Batch',
        status: 'active',
      );

      test('should update state with selected batch on success', () async {
        when(
          () => mockGetBatchByIdUsecase(any()),
        ).thenAnswer((_) async => const Right(tBatch));

        await container
            .read(batchViewModelProvider.notifier)
            .getBatchById(tBatchId);
        final state = container.read(batchViewModelProvider);

        expect(state.status, BatchStatus.loaded);
        expect(state.selectedBatch, tBatch);
        verify(
          () => mockGetBatchByIdUsecase(
            const GetBatchByIdParams(batchId: tBatchId),
          ),
        ).called(1);
      });

      test('should update state to error when batch not found', () async {
        when(() => mockGetBatchByIdUsecase(any())).thenAnswer(
          (_) async => const Left(LocalDatabaseFailure(message: 'Not found')),
        );

        await container
            .read(batchViewModelProvider.notifier)
            .getBatchById(tBatchId);
        final state = container.read(batchViewModelProvider);

        expect(state.status, BatchStatus.error);
        expect(state.errorMessage, 'Not found');
      });
    });

    group('createBatch', () {
      const tBatchName = 'New Batch';
      final tBatches = [
        const BatchEntity(
          batchId: '1',
          batchName: tBatchName,
          status: 'active',
        ),
      ];

      test(
        'should update state to created and refresh batches on success',
        () async {
          when(
            () => mockCreateBatchUsecase(any()),
          ).thenAnswer((_) async => const Right(true));
          when(
            () => mockGetAllBatchUsecase(),
          ).thenAnswer((_) async => Right(tBatches));

          await container
              .read(batchViewModelProvider.notifier)
              .createBatch(tBatchName);

          verify(
            () => mockCreateBatchUsecase(
              const CreateBatchParams(batchName: tBatchName),
            ),
          ).called(1);
          verify(() => mockGetAllBatchUsecase()).called(1);
        },
      );

      test('should update state to error on failure', () async {
        when(() => mockCreateBatchUsecase(any())).thenAnswer(
          (_) async =>
              const Left(LocalDatabaseFailure(message: 'Creation failed')),
        );

        await container
            .read(batchViewModelProvider.notifier)
            .createBatch(tBatchName);
        final state = container.read(batchViewModelProvider);

        expect(state.status, BatchStatus.error);
        expect(state.errorMessage, 'Creation failed');
      });
    });

    group('updateBatch', () {
      const tBatchId = '123';
      const tBatchName = 'Updated Batch';
      const tStatus = 'active';
      final tBatches = [
        const BatchEntity(
          batchId: tBatchId,
          batchName: tBatchName,
          status: tStatus,
        ),
      ];

      test(
        'should update state to updated and refresh batches on success',
        () async {
          when(
            () => mockUpdateBatchUsecase(any()),
          ).thenAnswer((_) async => const Right(true));
          when(
            () => mockGetAllBatchUsecase(),
          ).thenAnswer((_) async => Right(tBatches));

          await container
              .read(batchViewModelProvider.notifier)
              .updateBatch(
                batchId: tBatchId,
                batchName: tBatchName,
                status: tStatus,
              );

          verify(
            () => mockUpdateBatchUsecase(
              const UpdateBatchParams(
                batchId: tBatchId,
                batchName: tBatchName,
                status: tStatus,
              ),
            ),
          ).called(1);
          verify(() => mockGetAllBatchUsecase()).called(1);
        },
      );

      test('should update state to error on failure', () async {
        when(() => mockUpdateBatchUsecase(any())).thenAnswer(
          (_) async =>
              const Left(LocalDatabaseFailure(message: 'Update failed')),
        );

        await container
            .read(batchViewModelProvider.notifier)
            .updateBatch(batchId: tBatchId, batchName: tBatchName);
        final state = container.read(batchViewModelProvider);

        expect(state.status, BatchStatus.error);
        expect(state.errorMessage, 'Update failed');
      });
    });

    group('deleteBatch', () {
      const tBatchId = '123';

      test(
        'should update state to deleted and refresh batches on success',
        () async {
          when(
            () => mockDeleteBatchUsecase(any()),
          ).thenAnswer((_) async => const Right(true));
          when(
            () => mockGetAllBatchUsecase(),
          ).thenAnswer((_) async => const Right([]));

          await container
              .read(batchViewModelProvider.notifier)
              .deleteBatch(tBatchId);

          verify(
            () => mockDeleteBatchUsecase(
              const DeleteBatchParams(batchId: tBatchId),
            ),
          ).called(1);
          verify(() => mockGetAllBatchUsecase()).called(1);
        },
      );

      test('should update state to error on failure', () async {
        when(() => mockDeleteBatchUsecase(any())).thenAnswer(
          (_) async =>
              const Left(LocalDatabaseFailure(message: 'Delete failed')),
        );

        await container
            .read(batchViewModelProvider.notifier)
            .deleteBatch(tBatchId);
        final state = container.read(batchViewModelProvider);

        expect(state.status, BatchStatus.error);
        expect(state.errorMessage, 'Delete failed');
      });
    });

    group('clearError', () {
      test('should clear error message from state', () async {
        when(() => mockGetAllBatchUsecase()).thenAnswer(
          (_) async => const Left(LocalDatabaseFailure(message: 'Error')),
        );

        await container.read(batchViewModelProvider.notifier).getAllBatches();
        expect(container.read(batchViewModelProvider).errorMessage, 'Error');

        container.read(batchViewModelProvider.notifier).clearError();
        final state = container.read(batchViewModelProvider);

        expect(state.errorMessage, isNull);
      });
    });

    group('clearSelectedBatch', () {
      test('should clear selected batch from state', () async {
        const tBatch = BatchEntity(
          batchId: '123',
          batchName: 'Test Batch',
          status: 'active',
        );
        when(
          () => mockGetBatchByIdUsecase(any()),
        ).thenAnswer((_) async => const Right(tBatch));

        await container
            .read(batchViewModelProvider.notifier)
            .getBatchById('123');
        expect(container.read(batchViewModelProvider).selectedBatch, tBatch);

        container.read(batchViewModelProvider.notifier).clearSelectedBatch();
        final state = container.read(batchViewModelProvider);

        expect(state.selectedBatch, isNull);
      });
    });
  });
}
