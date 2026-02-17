import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lost_n_found/core/error/failures.dart';
import 'package:lost_n_found/features/batch/domain/entities/batch_entity.dart';
import 'package:lost_n_found/features/batch/domain/usecases/create_batch_usecase.dart';
import 'package:lost_n_found/features/batch/domain/usecases/delete_batch_usecase.dart';
import 'package:lost_n_found/features/batch/domain/usecases/get_all_batch_usecase.dart';
import 'package:lost_n_found/features/batch/domain/usecases/get_batch_byid_usecase.dart';
import 'package:lost_n_found/features/batch/domain/usecases/update_batch_usecase.dart';
import 'package:lost_n_found/features/batch/presentation/bloc/batch_bloc.dart';
import 'package:lost_n_found/features/batch/presentation/bloc/batch_event.dart';
import 'package:lost_n_found/features/batch/presentation/state/batch_state.dart';
import 'package:mocktail/mocktail.dart';

// Mocks
class MockGetAllBatchUsecase extends Mock implements GetAllBatchUsecase {}

class MockGetBatchByIdUsecase extends Mock implements GetBatchByIdUsecase {}

class MockCreateBatchUsecase extends Mock implements CreateBatchUsecase {}

class MockUpdateBatchUsecase extends Mock implements UpdateBatchUsecase {}

class MockDeleteBatchUsecase extends Mock implements DeleteBatchUsecase {}

void main() {
  late BatchBloc batchBloc;
  late MockGetAllBatchUsecase mockGetAllBatchUsecase;
  late MockGetBatchByIdUsecase mockGetBatchByIdUsecase;
  late MockCreateBatchUsecase mockCreateBatchUsecase;
  late MockUpdateBatchUsecase mockUpdateBatchUsecase;
  late MockDeleteBatchUsecase mockDeleteBatchUsecase;

  const tBatch = BatchEntity(
    batchId: 'batch-1',
    batchName: '35A',
  );

  const tBatch2 = BatchEntity(
    batchId: 'batch-2',
    batchName: '35B',
  );

  final tBatches = [tBatch, tBatch2];

  setUpAll(() {
    registerFallbackValue(const GetBatchByIdParams(batchId: ''));
    registerFallbackValue(const CreateBatchParams(batchName: ''));
    registerFallbackValue(
        const UpdateBatchParams(batchId: '', batchName: ''));
    registerFallbackValue(const DeleteBatchParams(batchId: ''));
  });

  setUp(() {
    mockGetAllBatchUsecase = MockGetAllBatchUsecase();
    mockGetBatchByIdUsecase = MockGetBatchByIdUsecase();
    mockCreateBatchUsecase = MockCreateBatchUsecase();
    mockUpdateBatchUsecase = MockUpdateBatchUsecase();
    mockDeleteBatchUsecase = MockDeleteBatchUsecase();

    batchBloc = BatchBloc(
      getAllBatchUsecase: mockGetAllBatchUsecase,
      getBatchByIdUsecase: mockGetBatchByIdUsecase,
      createBatchUsecase: mockCreateBatchUsecase,
      updateBatchUsecase: mockUpdateBatchUsecase,
      deleteBatchUsecase: mockDeleteBatchUsecase,
    );
  });

  tearDown(() {
    batchBloc.close();
  });

  test('initial state is BatchState with initial status', () {
    expect(batchBloc.state, const BatchState());
    expect(batchBloc.state.status, BatchStatus.initial);
  });

  group('BatchGetAllEvent', () {
    blocTest<BatchBloc, BatchState>(
      'emits [loading, loaded] with batches when succeeds',
      build: () {
        when(() => mockGetAllBatchUsecase())
            .thenAnswer((_) async => Right(tBatches));
        return batchBloc;
      },
      act: (bloc) => bloc.add(const BatchGetAllEvent()),
      expect: () => [
        const BatchState(status: BatchStatus.loading),
        BatchState(
          status: BatchStatus.loaded,
          batches: tBatches,
        ),
      ],
    );

    blocTest<BatchBloc, BatchState>(
      'emits [loading, error] when fails',
      build: () {
        when(() => mockGetAllBatchUsecase()).thenAnswer(
            (_) async => const Left(ApiFailure(message: 'Server error')));
        return batchBloc;
      },
      act: (bloc) => bloc.add(const BatchGetAllEvent()),
      expect: () => [
        const BatchState(status: BatchStatus.loading),
        const BatchState(
          status: BatchStatus.error,
          errorMessage: 'Server error',
        ),
      ],
    );

    blocTest<BatchBloc, BatchState>(
      'emits [loading, error] when network failure',
      build: () {
        when(() => mockGetAllBatchUsecase())
            .thenAnswer((_) async => const Left(NetworkFailure()));
        return batchBloc;
      },
      act: (bloc) => bloc.add(const BatchGetAllEvent()),
      expect: () => [
        const BatchState(status: BatchStatus.loading),
        const BatchState(
          status: BatchStatus.error,
          errorMessage: 'No internet connection',
        ),
      ],
    );
  });

  group('BatchGetByIdEvent', () {
    blocTest<BatchBloc, BatchState>(
      'emits [loading, loaded] with selected batch when succeeds',
      build: () {
        when(() => mockGetBatchByIdUsecase(any()))
            .thenAnswer((_) async => const Right(tBatch));
        return batchBloc;
      },
      act: (bloc) =>
          bloc.add(const BatchGetByIdEvent(batchId: 'batch-1')),
      expect: () => [
        const BatchState(status: BatchStatus.loading),
        const BatchState(
          status: BatchStatus.loaded,
          selectedBatch: tBatch,
        ),
      ],
    );

    blocTest<BatchBloc, BatchState>(
      'emits [loading, error] when fails',
      build: () {
        when(() => mockGetBatchByIdUsecase(any())).thenAnswer(
            (_) async => const Left(ApiFailure(message: 'Batch not found')));
        return batchBloc;
      },
      act: (bloc) =>
          bloc.add(const BatchGetByIdEvent(batchId: 'batch-1')),
      expect: () => [
        const BatchState(status: BatchStatus.loading),
        const BatchState(
          status: BatchStatus.error,
          errorMessage: 'Batch not found',
        ),
      ],
    );
  });

  group('BatchCreateEvent', () {
    blocTest<BatchBloc, BatchState>(
      'emits [loading, created] and triggers GetAll when succeeds',
      build: () {
        when(() => mockCreateBatchUsecase(any()))
            .thenAnswer((_) async => const Right(true));
        when(() => mockGetAllBatchUsecase())
            .thenAnswer((_) async => Right(tBatches));
        return batchBloc;
      },
      act: (bloc) =>
          bloc.add(const BatchCreateEvent(batchName: '35A')),
      expect: () => [
        const BatchState(status: BatchStatus.loading),
        const BatchState(status: BatchStatus.created),
        const BatchState(status: BatchStatus.loading),
        BatchState(
          status: BatchStatus.loaded,
          batches: tBatches,
        ),
      ],
      verify: (_) {
        verify(() => mockCreateBatchUsecase(any())).called(1);
        verify(() => mockGetAllBatchUsecase()).called(1);
      },
    );

    blocTest<BatchBloc, BatchState>(
      'emits [loading, error] when create fails',
      build: () {
        when(() => mockCreateBatchUsecase(any())).thenAnswer(
            (_) async => const Left(ApiFailure(message: 'Create failed')));
        return batchBloc;
      },
      act: (bloc) =>
          bloc.add(const BatchCreateEvent(batchName: '35A')),
      expect: () => [
        const BatchState(status: BatchStatus.loading),
        const BatchState(
          status: BatchStatus.error,
          errorMessage: 'Create failed',
        ),
      ],
    );
  });

  group('BatchUpdateEvent', () {
    blocTest<BatchBloc, BatchState>(
      'emits [loading, updated] and triggers GetAll when succeeds',
      build: () {
        when(() => mockUpdateBatchUsecase(any()))
            .thenAnswer((_) async => const Right(true));
        when(() => mockGetAllBatchUsecase())
            .thenAnswer((_) async => Right(tBatches));
        return batchBloc;
      },
      act: (bloc) => bloc.add(const BatchUpdateEvent(
        batchId: 'batch-1',
        batchName: 'Updated 35A',
      )),
      expect: () => [
        const BatchState(status: BatchStatus.loading),
        const BatchState(status: BatchStatus.updated),
        const BatchState(status: BatchStatus.loading),
        BatchState(
          status: BatchStatus.loaded,
          batches: tBatches,
        ),
      ],
    );
  });

  group('BatchDeleteEvent', () {
    blocTest<BatchBloc, BatchState>(
      'emits [loading, deleted] and triggers GetAll when succeeds',
      build: () {
        when(() => mockDeleteBatchUsecase(any()))
            .thenAnswer((_) async => const Right(true));
        when(() => mockGetAllBatchUsecase())
            .thenAnswer((_) async => const Right([]));
        return batchBloc;
      },
      act: (bloc) =>
          bloc.add(const BatchDeleteEvent(batchId: 'batch-1')),
      expect: () => [
        const BatchState(status: BatchStatus.loading),
        const BatchState(status: BatchStatus.deleted),
        const BatchState(status: BatchStatus.loading),
        const BatchState(status: BatchStatus.loaded),
      ],
      verify: (_) {
        verify(() => mockDeleteBatchUsecase(any())).called(1);
        verify(() => mockGetAllBatchUsecase()).called(1);
      },
    );
  });

  group('BatchClearErrorEvent', () {
    blocTest<BatchBloc, BatchState>(
      'clears error message from state',
      build: () => batchBloc,
      seed: () => const BatchState(
        status: BatchStatus.error,
        errorMessage: 'Some error',
      ),
      act: (bloc) => bloc.add(const BatchClearErrorEvent()),
      expect: () => [
        const BatchState(status: BatchStatus.error),
      ],
    );
  });

  group('BatchClearSelectedEvent', () {
    blocTest<BatchBloc, BatchState>(
      'clears selected batch from state',
      build: () => batchBloc,
      seed: () => const BatchState(
        status: BatchStatus.loaded,
        selectedBatch: tBatch,
      ),
      act: (bloc) => bloc.add(const BatchClearSelectedEvent()),
      expect: () => [
        const BatchState(status: BatchStatus.loaded),
      ],
    );
  });
}
