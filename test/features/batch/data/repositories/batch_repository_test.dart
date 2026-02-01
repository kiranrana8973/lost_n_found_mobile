import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
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

class MockBatchRemoteDatasource extends Mock implements IBatchRemoteDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late BatchRepository repository;
  late MockBatchLocalDatasource mockLocalDatasource;
  late MockBatchRemoteDatasource mockRemoteDatasource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockLocalDatasource = MockBatchLocalDatasource();
    mockRemoteDatasource = MockBatchRemoteDatasource();
    mockNetworkInfo = MockNetworkInfo();
    repository = BatchRepository(
      batchDatasource: mockLocalDatasource,
      batchRemoteDataSource: mockRemoteDatasource,
      networkInfo: mockNetworkInfo,
    );
  });

  setUpAll(() {
    registerFallbackValue(
      BatchHiveModel(batchName: 'Test Batch'),
    );
    registerFallbackValue(<BatchHiveModel>[]);
  });

  const tBatchEntity = BatchEntity(
    batchId: '1',
    batchName: 'Test Batch',
    status: 'active',
  );

  final tBatchHiveModel = BatchHiveModel(
    batchId: '1',
    batchName: 'Test Batch',
    status: 'active',
  );

  final tBatchApiModelList = [
    BatchApiModel(id: '1', batchName: 'Batch 1', status: 'active'),
    BatchApiModel(id: '2', batchName: 'Batch 2', status: 'active'),
  ];

  final tBatchHiveModelList = [
    BatchHiveModel(batchId: '1', batchName: 'Batch 1', status: 'active'),
    BatchHiveModel(batchId: '2', batchName: 'Batch 2', status: 'active'),
  ];

  group('createBatch', () {
    test('should return Right(true) when local create succeeds', () async {
      // Arrange
      when(() => mockLocalDatasource.createBatch(any()))
          .thenAnswer((_) async => true);

      // Act
      final result = await repository.createBatch(tBatchEntity);

      // Assert
      expect(result, const Right(true));
      verify(() => mockLocalDatasource.createBatch(any())).called(1);
    });

    test('should return Left(LocalDatabaseFailure) when local create fails',
        () async {
      // Arrange
      when(() => mockLocalDatasource.createBatch(any()))
          .thenAnswer((_) async => false);

      // Act
      final result = await repository.createBatch(tBatchEntity);

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<LocalDatabaseFailure>());
          expect((failure as LocalDatabaseFailure).message,
              'Failed to create a batch');
        },
        (_) => fail('Should return failure'),
      );
    });

    test(
        'should return Left(LocalDatabaseFailure) when exception occurs',
        () async {
      // Arrange
      when(() => mockLocalDatasource.createBatch(any()))
          .thenThrow(Exception('Database error'));

      // Act
      final result = await repository.createBatch(tBatchEntity);

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<LocalDatabaseFailure>()),
        (_) => fail('Should return failure'),
      );
    });
  });

  group('deleteBatch', () {
    test('should return Right(true) when delete succeeds', () async {
      // Arrange
      when(() => mockLocalDatasource.deleteBatch('1'))
          .thenAnswer((_) async => true);

      // Act
      final result = await repository.deleteBatch('1');

      // Assert
      expect(result, const Right(true));
      verify(() => mockLocalDatasource.deleteBatch('1')).called(1);
    });

    test('should return Left(LocalDatabaseFailure) when delete fails',
        () async {
      // Arrange
      when(() => mockLocalDatasource.deleteBatch('1'))
          .thenAnswer((_) async => false);

      // Act
      final result = await repository.deleteBatch('1');

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<LocalDatabaseFailure>()),
        (_) => fail('Should return failure'),
      );
    });

    test('should return Left(LocalDatabaseFailure) when exception occurs',
        () async {
      // Arrange
      when(() => mockLocalDatasource.deleteBatch('1'))
          .thenThrow(Exception('Database error'));

      // Act
      final result = await repository.deleteBatch('1');

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<LocalDatabaseFailure>()),
        (_) => fail('Should return failure'),
      );
    });
  });

  group('getAllBatches', () {
    test(
        'should return remote data and cache it locally when online and remote call succeeds',
        () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDatasource.getAllBatches())
          .thenAnswer((_) async => tBatchApiModelList);
      when(() => mockLocalDatasource.cacheAllBatches(any()))
          .thenAnswer((_) async {});

      // Act
      final result = await repository.getAllBatches();

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Should return data'),
        (batches) {
          expect(batches.length, 2);
          expect(batches[0].batchName, 'Batch 1');
        },
      );
      verify(() => mockRemoteDatasource.getAllBatches()).called(1);
      verify(() => mockLocalDatasource.cacheAllBatches(any())).called(1);
    });

    test('should return cached data when online but DioException occurs',
        () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDatasource.getAllBatches()).thenThrow(
        DioException(requestOptions: RequestOptions(path: '/batches')),
      );
      when(() => mockLocalDatasource.getAllBatches())
          .thenAnswer((_) async => tBatchHiveModelList);

      // Act
      final result = await repository.getAllBatches();

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Should return cached data'),
        (batches) => expect(batches.length, 2),
      );
    });

    test('should return cached data when online but exception occurs',
        () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDatasource.getAllBatches())
          .thenThrow(Exception('API Error'));
      when(() => mockLocalDatasource.getAllBatches())
          .thenAnswer((_) async => tBatchHiveModelList);

      // Act
      final result = await repository.getAllBatches();

      // Assert
      expect(result.isRight(), true);
    });

    test('should return cached data when offline', () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(() => mockLocalDatasource.getAllBatches())
          .thenAnswer((_) async => tBatchHiveModelList);

      // Act
      final result = await repository.getAllBatches();

      // Assert
      expect(result.isRight(), true);
      verifyNever(() => mockRemoteDatasource.getAllBatches());
      verify(() => mockLocalDatasource.getAllBatches()).called(1);
    });

    test(
        'should return Left(LocalDatabaseFailure) when offline and local call fails',
        () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(() => mockLocalDatasource.getAllBatches())
          .thenThrow(Exception('Database Error'));

      // Act
      final result = await repository.getAllBatches();

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<LocalDatabaseFailure>()),
        (_) => fail('Should return failure'),
      );
    });
  });

  group('getBatchById', () {
    test('should return batch when it exists', () async {
      // Arrange
      when(() => mockLocalDatasource.getBatchById('1'))
          .thenAnswer((_) async => tBatchHiveModel);

      // Act
      final result = await repository.getBatchById('1');

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Should return batch'),
        (batch) => expect(batch.batchName, 'Test Batch'),
      );
    });

    test('should return Left(LocalDatabaseFailure) when batch not found',
        () async {
      // Arrange
      when(() => mockLocalDatasource.getBatchById('1'))
          .thenAnswer((_) async => null);

      // Act
      final result = await repository.getBatchById('1');

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<LocalDatabaseFailure>());
          expect((failure as LocalDatabaseFailure).message, 'Batch not found');
        },
        (_) => fail('Should return failure'),
      );
    });

    test('should return Left(LocalDatabaseFailure) when exception occurs',
        () async {
      // Arrange
      when(() => mockLocalDatasource.getBatchById('1'))
          .thenThrow(Exception('Database error'));

      // Act
      final result = await repository.getBatchById('1');

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<LocalDatabaseFailure>()),
        (_) => fail('Should return failure'),
      );
    });
  });

  group('updateBatch', () {
    test('should return Right(true) when update succeeds', () async {
      // Arrange
      when(() => mockLocalDatasource.updateBatch(any()))
          .thenAnswer((_) async => true);

      // Act
      final result = await repository.updateBatch(tBatchEntity);

      // Assert
      expect(result, const Right(true));
      verify(() => mockLocalDatasource.updateBatch(any())).called(1);
    });

    test('should return Left(LocalDatabaseFailure) when update fails',
        () async {
      // Arrange
      when(() => mockLocalDatasource.updateBatch(any()))
          .thenAnswer((_) async => false);

      // Act
      final result = await repository.updateBatch(tBatchEntity);

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<LocalDatabaseFailure>());
          expect(
              (failure as LocalDatabaseFailure).message, 'Failed to update batch');
        },
        (_) => fail('Should return failure'),
      );
    });

    test('should return Left(LocalDatabaseFailure) when exception occurs',
        () async {
      // Arrange
      when(() => mockLocalDatasource.updateBatch(any()))
          .thenThrow(Exception('Database error'));

      // Act
      final result = await repository.updateBatch(tBatchEntity);

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<LocalDatabaseFailure>()),
        (_) => fail('Should return failure'),
      );
    });
  });
}
