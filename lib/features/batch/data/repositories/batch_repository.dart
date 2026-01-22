import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lost_n_found/core/error/failures.dart';
import 'package:lost_n_found/features/batch/data/datasources/batch_datasource.dart';
import 'package:lost_n_found/features/batch/data/datasources/local/batch_local_datasource.dart';
import 'package:lost_n_found/features/batch/data/models/batch_hive_model.dart';
import 'package:lost_n_found/features/batch/domain/entities/batch_entity.dart';
import 'package:lost_n_found/features/batch/domain/repositories/batch_repository.dart';

// Create provider
final batchRepositoryProvider = Provider<IBatchRepository>((ref) {
  final batchDatasource = ref.read(batchLocalDatasourceProvider);
  return BatchRepository(batchDatasource: batchDatasource);
});

class BatchRepository implements IBatchRepository {
  final IBatchDataSource _batchDataSource;

  BatchRepository({required IBatchDataSource batchDatasource})
    : _batchDataSource = batchDatasource;

  @override
  Future<Either<Failure, bool>> createBatch(BatchEntity batch) async {
    try {
      // conversion
      // entity lai model ma convert gara
      final batchModel = BatchHiveModel.fromEntity(batch);
      final result = await _batchDataSource.createBatch(batchModel);
      if (result) {
        return const Right(true);
      }
      return const Left(
        LocalDatabaseFailure(message: "Failed to create a batch"),
      );
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteBatch(String batchId) async {
    try {
      final result = await _batchDataSource.deleteBatch(batchId);
      if (result) {
        return Right(true);
      }

      return Left(LocalDatabaseFailure(message: ' Failed to delete batch'));
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<BatchEntity>>> getAllBatches() async {
    try {
      final models = await _batchDataSource.getAllBatches();
      final entities = BatchHiveModel.toEntityList(models);
      return Right(entities);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, BatchEntity>> getBatchById(String batchId) async {
    try {
      final model = await _batchDataSource.getBatchById(batchId);
      if (model != null) {
        final entity = model.toEntity();
        return Right(entity);
      }
      return Left(LocalDatabaseFailure(message: 'Batch not found'));
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> updateBatch(BatchEntity batch) async {
    try {
      final batchModel = BatchHiveModel.fromEntity(batch);
      final result = await _batchDataSource.updateBatch(batchModel);
      if (result) {
        return const Right(true);
      }
      return const Left(
        LocalDatabaseFailure(message: "Failed to update batch"),
      );
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }
}
