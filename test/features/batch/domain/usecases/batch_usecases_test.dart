import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lost_n_found/core/error/failures.dart';
import 'package:lost_n_found/features/batch/domain/entities/batch_entity.dart';
import 'package:lost_n_found/features/batch/domain/repositories/batch_repository.dart';
import 'package:lost_n_found/features/batch/domain/usecases/create_batch_usecase.dart';
import 'package:lost_n_found/features/batch/domain/usecases/delete_batch_usecase.dart';
import 'package:lost_n_found/features/batch/domain/usecases/get_all_batch_usecase.dart';
import 'package:lost_n_found/features/batch/domain/usecases/get_batch_byid_usecase.dart';
import 'package:lost_n_found/features/batch/domain/usecases/update_batch_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockBatchRepository extends Mock implements IBatchRepository {}

void main() {
  late MockBatchRepository mockRepository;

  setUp(() {
    mockRepository = MockBatchRepository();
  });

  group('GetAllBatchUsecase', () {
    late GetAllBatchUsecase usecase;

    setUp(() {
      usecase = GetAllBatchUsecase(batchRepository: mockRepository);
    });

    final tBatches = [
      const BatchEntity(batchId: '1', batchName: 'Batch 1', status: 'active'),
      const BatchEntity(batchId: '2', batchName: 'Batch 2', status: 'inactive'),
    ];

    test('should get all batches from the repository', () async {
      when(
        () => mockRepository.getAllBatches(),
      ).thenAnswer((_) async => Right(tBatches));

      final result = await usecase();

      expect(result, Right(tBatches));
      verify(() => mockRepository.getAllBatches());
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return failure when repository fails', () async {
      when(() => mockRepository.getAllBatches()).thenAnswer(
        (_) async => const Left(LocalDatabaseFailure(message: 'Error')),
      );

      final result = await usecase();

      expect(result.isLeft(), true);
      verify(() => mockRepository.getAllBatches());
    });
  });

  group('GetBatchByIdUsecase', () {
    late GetBatchByIdUsecase usecase;

    setUp(() {
      usecase = GetBatchByIdUsecase(batchRepository: mockRepository);
    });

    const tBatchId = '123';
    const tBatch = BatchEntity(
      batchId: tBatchId,
      batchName: 'Test Batch',
      status: 'active',
    );

    test('should get batch by id from the repository', () async {
      when(
        () => mockRepository.getBatchById(tBatchId),
      ).thenAnswer((_) async => const Right(tBatch));

      final result = await usecase(const GetBatchByIdParams(batchId: tBatchId));

      expect(result, const Right(tBatch));
      verify(() => mockRepository.getBatchById(tBatchId));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return failure when batch is not found', () async {
      when(() => mockRepository.getBatchById(tBatchId)).thenAnswer(
        (_) async => const Left(LocalDatabaseFailure(message: 'Not found')),
      );

      final result = await usecase(const GetBatchByIdParams(batchId: tBatchId));

      expect(result.isLeft(), true);
      verify(() => mockRepository.getBatchById(tBatchId));
    });
  });

  group('CreateBatchUsecase', () {
    late CreateBatchUsecase usecase;

    setUp(() {
      usecase = CreateBatchUsecase(batchRepository: mockRepository);
    });

    setUpAll(() {
      registerFallbackValue(const BatchEntity(batchName: 'Fallback'));
    });

    const tBatchName = 'New Batch';

    test('should create batch through the repository', () async {
      when(
        () => mockRepository.createBatch(any()),
      ).thenAnswer((_) async => const Right(true));

      final result = await usecase(
        const CreateBatchParams(batchName: tBatchName),
      );

      expect(result, const Right(true));
      verify(() => mockRepository.createBatch(any()));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return failure when creation fails', () async {
      when(() => mockRepository.createBatch(any())).thenAnswer(
        (_) async =>
            const Left(LocalDatabaseFailure(message: 'Creation failed')),
      );

      final result = await usecase(
        const CreateBatchParams(batchName: tBatchName),
      );

      expect(result.isLeft(), true);
      verify(() => mockRepository.createBatch(any()));
    });
  });

  group('UpdateBatchUsecase', () {
    late UpdateBatchUsecase usecase;

    setUp(() {
      usecase = UpdateBatchUsecase(batchRepository: mockRepository);
    });

    setUpAll(() {
      registerFallbackValue(const BatchEntity(batchName: 'Fallback'));
    });

    const tParams = UpdateBatchParams(
      batchId: '123',
      batchName: 'Updated Batch',
      status: 'active',
    );

    test('should update batch through the repository', () async {
      when(
        () => mockRepository.updateBatch(any()),
      ).thenAnswer((_) async => const Right(true));

      final result = await usecase(tParams);

      expect(result, const Right(true));
      verify(() => mockRepository.updateBatch(any()));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return failure when update fails', () async {
      when(() => mockRepository.updateBatch(any())).thenAnswer(
        (_) async => const Left(LocalDatabaseFailure(message: 'Update failed')),
      );

      final result = await usecase(tParams);

      expect(result.isLeft(), true);
      verify(() => mockRepository.updateBatch(any()));
    });
  });

  group('DeleteBatchUsecase', () {
    late DeleteBatchUsecase usecase;

    setUp(() {
      usecase = DeleteBatchUsecase(batchRepository: mockRepository);
    });

    const tBatchId = '123';

    test('should delete batch through the repository', () async {
      when(
        () => mockRepository.deleteBatch(tBatchId),
      ).thenAnswer((_) async => const Right(true));

      final result = await usecase(const DeleteBatchParams(batchId: tBatchId));

      expect(result, const Right(true));
      verify(() => mockRepository.deleteBatch(tBatchId));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return failure when deletion fails', () async {
      when(() => mockRepository.deleteBatch(tBatchId)).thenAnswer(
        (_) async => const Left(LocalDatabaseFailure(message: 'Delete failed')),
      );

      final result = await usecase(const DeleteBatchParams(batchId: tBatchId));

      expect(result.isLeft(), true);
      verify(() => mockRepository.deleteBatch(tBatchId));
    });
  });
}
