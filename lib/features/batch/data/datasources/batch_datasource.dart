import 'package:lost_n_found/features/batch/data/models/batch_model.dart';

abstract interface class IBatchDataSource {
  Future<List<BatchModel>> getAllBatches();
  Future<BatchModel?> getBatchById(String batchId);
  Future<bool> createBatch(BatchModel batch);
  Future<bool> updateBatch(BatchModel batch);
  Future<bool> deleteBatch(String batchId);
}
