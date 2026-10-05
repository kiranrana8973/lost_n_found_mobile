import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lost_n_found/core/services/database/app_database.dart';
import 'package:lost_n_found/features/batch/data/datasources/batch_datasource.dart';

// create provider
final batchLocalDatasourceProvider = Provider<BatchLocalDatasource>((ref) {
  final appDatabase = ref.read(appDatabaseProvider);
  return BatchLocalDatasource(appDatabase: appDatabase);
});

class BatchLocalDatasource implements IBatchDataSource {
  // Dependency Injection
  final AppDatabase _db;

  BatchLocalDatasource({required AppDatabase appDatabase})
    : _db = appDatabase;

  @override
  Future<bool> createBatch(BatchModel batch) async {
    try {
      await _db.createBatch(batch);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> deleteBatch(String batchId) async {
    try {
      await _db.deleteBatch(batchId);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<BatchModel>> getAllBatches() async {
    try {
      return await _db.getAllBatches();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<BatchModel?> getBatchById(String batchId) async {
    try {
      return await _db.getBatchById(batchId);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> updateBatch(BatchModel batch) async {
    try {
      await _db.updateBatch(batch);
      return true;
    } catch (e) {
      return false;
    }
  }
}
