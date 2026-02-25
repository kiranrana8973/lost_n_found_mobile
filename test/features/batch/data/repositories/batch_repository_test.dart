import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lost_n_found/core/error/failures.dart';
import 'package:lost_n_found/features/batch/data/datasources/local/batch_local_datasource.dart';
import 'package:lost_n_found/features/batch/data/models/batch_api_model.dart';
import 'package:lost_n_found/features/batch/data/models/batch_hive_model.dart';
import 'package:lost_n_found/features/batch/data/repositories/batch_repository.dart';
import 'package:lost_n_found/features/batch/domain/entities/batch_entity.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/test_mocks.dart';

class MockBatchLocalDatasource extends Mock implements BatchLocalDatasource {}

class FakeBatchHiveModel extends Fake implements BatchHiveModel {}

void main() {
  late BatchRepository repository;
  late MockBatchLocalDatasource mockLocalDataSource;
  late MockBatchRemoteDataSource mockRemoteDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUpAll(() {
    registerFallbackValue(FakeBatchHiveModel());
  });

  setUp(() {
    mockLocalDataSource = MockBatchLocalDatasource();
    mockRemoteDataSource = MockBatchRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = BatchRepository(
      batchDatasource: mockLocalDataSource,
      batchRemoteDataSource: mockRemoteDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  const tBatchEntity = BatchEntity(
    batchId: '1',
    batchName: 'Batch 2024',
    status: 'active',
  );

  final tBatchApiModel = BatchApiModel(
    id: '1',
    batchName: 'Batch 2024',
    status: 'active',
  );

  final tBatchApiModels = [tBatchApiModel];

  final tBatchHiveModel = BatchHiveModel(
    batchId: '1',
    batchName: 'Batch 2024',
    status: 'active',
  );

  final tBatchHiveModels = [tBatchHiveModel];

  group('getAllBatches', () {
    test(
      'should return Right(List<BatchEntity>) and cache when online',
      () async {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(
          () => mockRemoteDataSource.getAllBatches(),
        ).thenAnswer((_) async => tBatchApiModels);
        when(
          () => mockLocalDataSource.cacheAllBatches(any()),
        ).thenAnswer((_) async {});

        final result = await repository.getAllBatches();

        expect(result.isRight(), true);
        result.fold((_) => fail('Should be Right'), (batches) {
          expect(batches, isA<List<BatchEntity>>());
          expect(batches.length, 1);
          expect(batches[0].batchName, 'Batch 2024');
        });
        verify(() => mockLocalDataSource.cacheAllBatches(any())).called(1);
      },
    );

    test('should return cached batches when offline', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(
        () => mockLocalDataSource.getAllBatches(),
      ).thenAnswer((_) async => tBatchHiveModels);

      final result = await repository.getAllBatches();

      expect(result.isRight(), true);
      result.fold((_) => fail('Should be Right'), (batches) {
        expect(batches, isA<List<BatchEntity>>());
        expect(batches.length, 1);
      });
      verify(() => mockLocalDataSource.getAllBatches()).called(1);
      verifyNever(() => mockRemoteDataSource.getAllBatches());
    });
  });

  group('createBatch', () {
    test('should return Right(true) when local creation succeeds', () async {
      when(
        () => mockLocalDataSource.createBatch(any()),
      ).thenAnswer((_) async => true);

      final result = await repository.createBatch(tBatchEntity);

      expect(result, const Right(true));
      verify(() => mockLocalDataSource.createBatch(any())).called(1);
    });

    test(
      'should return Left(LocalDatabaseFailure) when local creation fails',
      () async {
        when(
          () => mockLocalDataSource.createBatch(any()),
        ).thenAnswer((_) async => false);

        final result = await repository.createBatch(tBatchEntity);

        expect(result.isLeft(), true);
        result.fold((failure) {
          expect(failure, isA<LocalDatabaseFailure>());
          expect(failure.message, 'Failed to create a batch');
        }, (_) => fail('Should be Left'));
      },
    );
  });

  group('deleteBatch', () {
    const tBatchId = '1';

    test('should return Right(true) when local deletion succeeds', () async {
      when(
        () => mockLocalDataSource.deleteBatch(any()),
      ).thenAnswer((_) async => true);

      final result = await repository.deleteBatch(tBatchId);

      expect(result, const Right(true));
      verify(() => mockLocalDataSource.deleteBatch(tBatchId)).called(1);
    });

    test(
      'should return Left(LocalDatabaseFailure) when local deletion fails',
      () async {
        when(
          () => mockLocalDataSource.deleteBatch(any()),
        ).thenAnswer((_) async => false);

        final result = await repository.deleteBatch(tBatchId);

        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure, isA<LocalDatabaseFailure>()),
          (_) => fail('Should be Left'),
        );
      },
    );
  });
}
