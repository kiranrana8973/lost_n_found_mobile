import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lost_n_found/core/constants/hive_table_constant.dart';
import 'package:lost_n_found/core/services/hive/hive_box.dart';
import 'package:lost_n_found/features/batch/data/datasources/batch_datasource.dart';
import 'package:lost_n_found/features/batch/data/models/batch_hive_model.dart';

final batchLocalDatasourceProvider = Provider<BatchLocalDatasource>((ref) {
  return BatchLocalDatasource();
});

class BatchLocalDatasource implements IBatchLocalDataSource {
  final HiveBox<BatchHiveModel> _box;

  BatchLocalDatasource()
    : _box = HiveBox<BatchHiveModel>(HiveTableConstant.batchTable);

  @override
  Future<bool> createBatch(BatchHiveModel batch) async {
    try {
      await _box.put(batch.batchId!, batch);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> deleteBatch(String batchId) async {
    try {
      await _box.delete(batchId);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<BatchHiveModel>> getAllBatches() async {
    try {
      return _box.getAll();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<BatchHiveModel?> getBatchById(String batchId) async {
    try {
      return _box.get(batchId);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> updateBatch(BatchHiveModel batch) async {
    try {
      return await _box.update(batch.batchId!, batch);
    } catch (e) {
      return false;
    }
  }

  Future<void> cacheAllBatches(List<BatchHiveModel> batches) async {
    await _box.replaceAll({for (final b in batches) b.batchId!: b});
  }
}
