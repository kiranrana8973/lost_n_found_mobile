import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:lost_n_found/core/error/failures.dart';
import 'package:lost_n_found/features/batch/domain/entities/batch_entity.dart';
import 'package:lost_n_found/features/batch/domain/usecases/get_all_batch_usecase.dart';
import 'package:lost_n_found/features/batch/domain/usecases/get_batch_byid_usecase.dart';
import 'package:lost_n_found/features/batch/domain/usecases/create_batch_usecase.dart';
import 'package:lost_n_found/features/batch/domain/usecases/update_batch_usecase.dart';
import 'package:lost_n_found/features/batch/domain/usecases/delete_batch_usecase.dart';

import '../../../../mocks/test_mocks.dart';

void main() {
  late MockBatchRepository mockBatchRepository;

  setUpAll(() {
    registerFallbackValue(const BatchEntity(batchName: ''));
  });

  setUp(() {
    mockBatchRepository = MockBatchRepository();
  });

  group('GetAllBatchUsecase', () {
    late GetAllBatchUsecase usecase;

    setUp(() {
      usecase = GetAllBatchUsecase(batchRepository: mockBatchRepository);
    });

    final tBatchList = [
      const BatchEntity(batchId: '1', batchName: 'Batch 2024'),
      const BatchEntity(batchId: '2', batchName: 'Batch 2025'),
    ];

    test('should return list of batches on success', () async {
      when(
        () => mockBatchRepository.getAllBatches(),
      ).thenAnswer((_) async => Right(tBatchList));

      final result = await usecase();

      expect(result, Right(tBatchList));
      verify(() => mockBatchRepository.getAllBatches()).called(1);
      verifyNoMoreInteractions(mockBatchRepository);
    });

    test('should return Failure when repository fails', () async {
      const tFailure = ApiFailure(message: 'Failed to fetch batches');
      when(
        () => mockBatchRepository.getAllBatches(),
      ).thenAnswer((_) async => const Left(tFailure));

      final result = await usecase();

      expect(result, const Left(tFailure));
      verify(() => mockBatchRepository.getAllBatches()).called(1);
      verifyNoMoreInteractions(mockBatchRepository);
    });
  });

  group('GetBatchByIdUsecase', () {
    late GetBatchByIdUsecase usecase;

    setUp(() {
      usecase = GetBatchByIdUsecase(batchRepository: mockBatchRepository);
    });

    const tBatchId = 'batch-1';
    const tParams = GetBatchByIdParams(batchId: tBatchId);
    const tBatchEntity = BatchEntity(
      batchId: tBatchId,
      batchName: 'Batch 2024',
    );

    test('should return BatchEntity on success', () async {
      when(
        () => mockBatchRepository.getBatchById(tBatchId),
      ).thenAnswer((_) async => const Right(tBatchEntity));

      final result = await usecase(tParams);

      expect(result, const Right(tBatchEntity));
      verify(() => mockBatchRepository.getBatchById(tBatchId)).called(1);
      verifyNoMoreInteractions(mockBatchRepository);
    });

    test('should return Failure when repository fails', () async {
      const tFailure = ApiFailure(message: 'Batch not found');
      when(
        () => mockBatchRepository.getBatchById(tBatchId),
      ).thenAnswer((_) async => const Left(tFailure));

      final result = await usecase(tParams);

      expect(result, const Left(tFailure));
      verify(() => mockBatchRepository.getBatchById(tBatchId)).called(1);
      verifyNoMoreInteractions(mockBatchRepository);
    });
  });

  group('CreateBatchUsecase', () {
    late CreateBatchUsecase usecase;

    setUp(() {
      usecase = CreateBatchUsecase(batchRepository: mockBatchRepository);
    });

    const tParams = CreateBatchParams(batchName: 'Batch 2024');

    test('should return true on successful batch creation', () async {
      when(
        () => mockBatchRepository.createBatch(any()),
      ).thenAnswer((_) async => const Right(true));

      final result = await usecase(tParams);

      expect(result, const Right(true));
      verify(() => mockBatchRepository.createBatch(any())).called(1);
      verifyNoMoreInteractions(mockBatchRepository);
    });

    test('should return Failure on unsuccessful batch creation', () async {
      const tFailure = ApiFailure(message: 'Failed to create batch');
      when(
        () => mockBatchRepository.createBatch(any()),
      ).thenAnswer((_) async => const Left(tFailure));

      final result = await usecase(tParams);

      expect(result, const Left(tFailure));
      verify(() => mockBatchRepository.createBatch(any())).called(1);
      verifyNoMoreInteractions(mockBatchRepository);
    });
  });

  group('UpdateBatchUsecase', () {
    late UpdateBatchUsecase usecase;

    setUp(() {
      usecase = UpdateBatchUsecase(batchRepository: mockBatchRepository);
    });

    const tParams = UpdateBatchParams(
      batchId: 'batch-1',
      batchName: 'Updated Batch',
      status: 'active',
    );

    test('should return true on successful batch update', () async {
      when(
        () => mockBatchRepository.updateBatch(any()),
      ).thenAnswer((_) async => const Right(true));

      final result = await usecase(tParams);

      expect(result, const Right(true));
      verify(() => mockBatchRepository.updateBatch(any())).called(1);
      verifyNoMoreInteractions(mockBatchRepository);
    });

    test('should return Failure on unsuccessful batch update', () async {
      const tFailure = ApiFailure(message: 'Failed to update batch');
      when(
        () => mockBatchRepository.updateBatch(any()),
      ).thenAnswer((_) async => const Left(tFailure));

      final result = await usecase(tParams);

      expect(result, const Left(tFailure));
      verify(() => mockBatchRepository.updateBatch(any())).called(1);
      verifyNoMoreInteractions(mockBatchRepository);
    });
  });

  group('DeleteBatchUsecase', () {
    late DeleteBatchUsecase usecase;

    setUp(() {
      usecase = DeleteBatchUsecase(batchRepository: mockBatchRepository);
    });

    const tBatchId = 'batch-1';
    const tParams = DeleteBatchParams(batchId: tBatchId);

    test('should return true on successful batch deletion', () async {
      when(
        () => mockBatchRepository.deleteBatch(tBatchId),
      ).thenAnswer((_) async => const Right(true));

      final result = await usecase(tParams);

      expect(result, const Right(true));
      verify(() => mockBatchRepository.deleteBatch(tBatchId)).called(1);
      verifyNoMoreInteractions(mockBatchRepository);
    });

    test('should return Failure on unsuccessful batch deletion', () async {
      const tFailure = ApiFailure(message: 'Failed to delete batch');
      when(
        () => mockBatchRepository.deleteBatch(tBatchId),
      ).thenAnswer((_) async => const Left(tFailure));

      final result = await usecase(tParams);

      expect(result, const Left(tFailure));
      verify(() => mockBatchRepository.deleteBatch(tBatchId)).called(1);
      verifyNoMoreInteractions(mockBatchRepository);
    });
  });
}
