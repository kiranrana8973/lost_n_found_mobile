import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lost_n_found/core/error/failures.dart';
import 'package:lost_n_found/core/services/connectivity/network_info.dart';
import 'package:lost_n_found/features/batch/data/datasources/batch_datasource.dart';
import 'package:lost_n_found/features/batch/data/datasources/local/batch_local_datasource.dart';
import 'package:lost_n_found/features/batch/data/models/batch_api_model.dart';
import 'package:lost_n_found/features/batch/data/models/batch_hive_model.dart';
import 'package:lost_n_found/features/batch/data/repositories/batch_repository.dart';
import 'package:lost_n_found/features/batch/domain/entities/batch_entity.dart';
import 'package:mocktail/mocktail.dart';

class MockBatchLocalDatasource extends Mock implements BatchLocalDatasource {}

class MockBatchRemoteDataSource extends Mock
    implements IBatchRemoteDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

class FakeBatchHiveModel extends Fake implements BatchHiveModel {}

void main() {
  late BatchRepository repository;
  late MockBatchLocalDatasource mockLocalDatasource;
  late MockBatchRemoteDataSource mockRemoteDatasource;
  late MockNetworkInfo mockNetworkInfo;

  setUpAll(() {
    registerFallbackValue(FakeBatchHiveModel());
  });

  setUp(() {
    mockLocalDatasource = MockBatchLocalDatasource();
    mockRemoteDatasource = MockBatchRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();

    repository = BatchRepository(
      batchDatasource: mockLocalDatasource,
      batchRemoteDataSource: mockRemoteDatasource,
      networkInfo: mockNetworkInfo,
    );
  });

  group('getAllBatches', () {
    final tBatchApiModels = [
      BatchApiModel(id: '1', batchName: 'Batch 1', status: 'active'),
      BatchApiModel(id: '2', batchName: 'Batch 2', status: 'inactive'),
    ];

    final tBatchHiveModels = [
      BatchHiveModel(batchId: '1', batchName: 'Batch 1', status: 'active'),
      BatchHiveModel(batchId: '2', batchName: 'Batch 2', status: 'inactive'),
    ];

    test('should return remote data when device is online', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(
        () => mockRemoteDatasource.getAllBatches(),
      ).thenAnswer((_) async => tBatchApiModels);
      when(
        () => mockLocalDatasource.cacheAllBatches(any()),
      ).thenAnswer((_) async => {});

      final result = await repository.getAllBatches();

      verify(() => mockNetworkInfo.isConnected);
      verify(() => mockRemoteDatasource.getAllBatches());

      expect(result.isRight(), true);

      result.fold((failure) => fail('Should not return failure'), (batches) {
        expect(batches.length, 2);
        expect(batches[0].batchId, '1');
        expect(batches[0].batchName, 'Batch 1');
      });
    });

    test('should cache data locally when fetched from remote', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(
        () => mockRemoteDatasource.getAllBatches(),
      ).thenAnswer((_) async => tBatchApiModels);
      when(
        () => mockLocalDatasource.cacheAllBatches(any()),
      ).thenAnswer((_) async => {});

      await repository.getAllBatches();

      verify(() => mockLocalDatasource.cacheAllBatches(any()));
    });

    test('should return cached data when device is offline', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(
        () => mockLocalDatasource.getAllBatches(),
      ).thenAnswer((_) async => tBatchHiveModels);

      final result = await repository.getAllBatches();

      verify(() => mockNetworkInfo.isConnected);
      verify(() => mockLocalDatasource.getAllBatches());
      verifyNever(() => mockRemoteDatasource.getAllBatches());
      expect(result.isRight(), true);
    });

    test('should return cached data when remote call fails', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(
        () => mockRemoteDatasource.getAllBatches(),
      ).thenThrow(Exception('Error'));
      when(
        () => mockLocalDatasource.getAllBatches(),
      ).thenAnswer((_) async => tBatchHiveModels);

      final result = await repository.getAllBatches();

      expect(result.isRight(), true);
      verify(() => mockLocalDatasource.getAllBatches());
    });
  });

  group('createBatch', () {
    const tBatchEntity = BatchEntity(batchName: 'New Batch');

    test(
      'should return Right(true) when batch is created successfully',
      () async {
        when(
          () => mockLocalDatasource.createBatch(any()),
        ).thenAnswer((_) async => true);

        final result = await repository.createBatch(tBatchEntity);

        expect(result, const Right(true));
        verify(() => mockLocalDatasource.createBatch(any()));
      },
    );

    test(
      'should return Left(LocalDatabaseFailure) when creation fails',
      () async {
        when(
          () => mockLocalDatasource.createBatch(any()),
        ).thenAnswer((_) async => false);

        final result = await repository.createBatch(tBatchEntity);

        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure, isA<LocalDatabaseFailure>()),
          (success) => fail('Should not return success'),
        );
      },
    );

    test(
      'should return Left(LocalDatabaseFailure) when exception is thrown',
      () async {
        when(
          () => mockLocalDatasource.createBatch(any()),
        ).thenThrow(Exception('Database error'));

        final result = await repository.createBatch(tBatchEntity);

        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure, isA<LocalDatabaseFailure>()),
          (success) => fail('Should not return success'),
        );
      },
    );
  });

  group('deleteBatch', () {
    const tBatchId = '123';

    test(
      'should return Right(true) when batch is deleted successfully',
      () async {
        when(
          () => mockLocalDatasource.deleteBatch(tBatchId),
        ).thenAnswer((_) async => true);

        final result = await repository.deleteBatch(tBatchId);

        expect(result, const Right(true));
        verify(() => mockLocalDatasource.deleteBatch(tBatchId));
      },
    );

    test(
      'should return Left(LocalDatabaseFailure) when deletion fails',
      () async {
        when(
          () => mockLocalDatasource.deleteBatch(tBatchId),
        ).thenAnswer((_) async => false);

        final result = await repository.deleteBatch(tBatchId);

        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure, isA<LocalDatabaseFailure>()),
          (success) => fail('Should not return success'),
        );
      },
    );
  });

  group('getBatchById', () {
    const tBatchId = '123';
    final tBatchHiveModel = BatchHiveModel(
      batchId: tBatchId,
      batchName: 'Test Batch',
      status: 'active',
    );

    test('should return BatchEntity when batch is found', () async {
      when(
        () => mockLocalDatasource.getBatchById(tBatchId),
      ).thenAnswer((_) async => tBatchHiveModel);

      final result = await repository.getBatchById(tBatchId);

      expect(result.isRight(), true);
      result.fold((failure) => fail('Should not return failure'), (batch) {
        expect(batch.batchId, tBatchId);
        expect(batch.batchName, 'Test Batch');
      });
    });

    test(
      'should return Left(LocalDatabaseFailure) when batch is not found',
      () async {
        when(
          () => mockLocalDatasource.getBatchById(tBatchId),
        ).thenAnswer((_) async => null);

        final result = await repository.getBatchById(tBatchId);

        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure, isA<LocalDatabaseFailure>()),
          (batch) => fail('Should not return batch'),
        );
      },
    );
  });

  group('updateBatch', () {
    const tBatchEntity = BatchEntity(
      batchId: '123',
      batchName: 'Updated Batch',
      status: 'active',
    );

    test(
      'should return Right(true) when batch is updated successfully',
      () async {
        when(
          () => mockLocalDatasource.updateBatch(any()),
        ).thenAnswer((_) async => true);

        final result = await repository.updateBatch(tBatchEntity);

        expect(result, const Right(true));
        verify(() => mockLocalDatasource.updateBatch(any()));
      },
    );

    test(
      'should return Left(LocalDatabaseFailure) when update fails',
      () async {
        when(
          () => mockLocalDatasource.updateBatch(any()),
        ).thenAnswer((_) async => false);

        final result = await repository.updateBatch(tBatchEntity);

        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure, isA<LocalDatabaseFailure>()),
          (success) => fail('Should not return success'),
        );
      },
    );
  });
}
