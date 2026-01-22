import 'package:lost_n_found/features/batch/data/models/batch_hive_model.dart';

abstract interface class IBatchDataSource {
  Future<List<BatchHiveModel>> getAllBatches();
  Future<BatchHiveModel?> getBatchById(String batchId);
  Future<bool> createBatch(BatchHiveModel batch);
  Future<bool> updateBatch(BatchHiveModel batch);
  Future<bool> deleteBatch(String batchId);
}
