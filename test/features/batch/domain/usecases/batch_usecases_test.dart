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
  late MockBatchRepository mockRepo;

  const tBatch = BatchEntity(batchId: 'batch-1', batchName: '35A');

  final tBatches = [
    tBatch,
    const BatchEntity(batchId: 'batch-2', batchName: '35B'),
  ];

  setUp(() {
    mockRepo = MockBatchRepository();
  });

  setUpAll(() {
    registerFallbackValue(tBatch);
  });

  group('GetAllBatchUsecase', () {
    late GetAllBatchUsecase usecase;

    setUp(() {
      usecase = GetAllBatchUsecase(batchRepository: mockRepo);
    });

    test('should return list of batches from repository', () async {
      when(() => mockRepo.getAllBatches())
          .thenAnswer((_) async => Right(tBatches));

      final result = await usecase();

      expect(result, Right(tBatches));
      verify(() => mockRepo.getAllBatches()).called(1);
    });

    test('should return failure when repository fails', () async {
      when(() => mockRepo.getAllBatches())
          .thenAnswer((_) async => const Left(NetworkFailure()));

      final result = await usecase();

      expect(result, const Left(NetworkFailure()));
    });
  });

  group('GetBatchByIdUsecase', () {
    late GetBatchByIdUsecase usecase;

    setUp(() {
      usecase = GetBatchByIdUsecase(batchRepository: mockRepo);
    });

    test('should call repository with correct batchId', () async {
      when(() => mockRepo.getBatchById(any()))
          .thenAnswer((_) async => const Right(tBatch));

      final result = await usecase(
          const GetBatchByIdParams(batchId: 'batch-1'));

      expect(result, const Right(tBatch));
      verify(() => mockRepo.getBatchById('batch-1')).called(1);
    });

    test('should return failure when not found', () async {
      when(() => mockRepo.getBatchById(any()))
          .thenAnswer((_) async => const Left(ApiFailure(message: 'Not found')));

      final result = await usecase(
          const GetBatchByIdParams(batchId: 'invalid'));

      expect(result, const Left(ApiFailure(message: 'Not found')));
    });
  });

  group('CreateBatchUsecase', () {
    late CreateBatchUsecase usecase;

    setUp(() {
      usecase = CreateBatchUsecase(batchRepository: mockRepo);
    });

    test('should call repository.createBatch with BatchEntity', () async {
      when(() => mockRepo.createBatch(any()))
          .thenAnswer((_) async => const Right(true));

      final result = await usecase(
          const CreateBatchParams(batchName: '35A'));

      expect(result, const Right(true));
      verify(() => mockRepo.createBatch(any())).called(1);
    });

    test('should return failure on error', () async {
      when(() => mockRepo.createBatch(any()))
          .thenAnswer((_) async => const Left(ApiFailure(message: 'Create failed')));

      final result = await usecase(
          const CreateBatchParams(batchName: '35A'));

      expect(result, const Left(ApiFailure(message: 'Create failed')));
    });
  });

  group('UpdateBatchUsecase', () {
    late UpdateBatchUsecase usecase;

    setUp(() {
      usecase = UpdateBatchUsecase(batchRepository: mockRepo);
    });

    const tParams = UpdateBatchParams(
      batchId: 'batch-1',
      batchName: 'Updated 35A',
    );

    test('should call repository.updateBatch with BatchEntity', () async {
      when(() => mockRepo.updateBatch(any()))
          .thenAnswer((_) async => const Right(true));

      final result = await usecase(tParams);

      expect(result, const Right(true));
      verify(() => mockRepo.updateBatch(any())).called(1);
    });

    test('should return failure on error', () async {
      when(() => mockRepo.updateBatch(any()))
          .thenAnswer((_) async => const Left(ApiFailure(message: 'Update failed')));

      final result = await usecase(tParams);

      expect(result, const Left(ApiFailure(message: 'Update failed')));
    });
  });

  group('DeleteBatchUsecase', () {
    late DeleteBatchUsecase usecase;

    setUp(() {
      usecase = DeleteBatchUsecase(batchRepository: mockRepo);
    });

    test('should call repository.deleteBatch with correct id', () async {
      when(() => mockRepo.deleteBatch(any()))
          .thenAnswer((_) async => const Right(true));

      final result = await usecase(
          const DeleteBatchParams(batchId: 'batch-1'));

      expect(result, const Right(true));
      verify(() => mockRepo.deleteBatch('batch-1')).called(1);
    });

    test('should return failure on error', () async {
      when(() => mockRepo.deleteBatch(any()))
          .thenAnswer((_) async => const Left(ApiFailure(message: 'Delete failed')));

      final result = await usecase(
          const DeleteBatchParams(batchId: 'batch-1'));

      expect(result, const Left(ApiFailure(message: 'Delete failed')));
    });
  });
}
