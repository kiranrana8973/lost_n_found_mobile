import 'package:flutter_test/flutter_test.dart';
import 'package:lost_n_found/features/batch/data/models/batch_api_model.dart';
import 'package:lost_n_found/features/batch/domain/entities/batch_entity.dart';

void main() {
  final tBatchApiModel = BatchApiModel(
    id: '1',
    batchName: 'Batch 1',
    status: 'active',
  );

  const tBatchEntity = BatchEntity(
    batchId: '1',
    batchName: 'Batch 1',
    status: 'active',
  );

  group('fromJson', () {
    test('should return a valid BatchApiModel from JSON', () {
      final json = {'_id': '1', 'batchName': 'Batch 1', 'status': 'active'};

      final result = BatchApiModel.fromJson(json);

      expect(result.id, '1');
      expect(result.batchName, 'Batch 1');
      expect(result.status, 'active');
    });
  });

  group('toJson', () {
    test('should return a JSON map with only batchName', () {
      final result = tBatchApiModel.toJson();

      expect(result['batchName'], 'Batch 1');
      expect(result.containsKey('_id'), false);
      expect(result.containsKey('status'), false);
      expect(result.length, 1);
    });
  });

  group('toEntity', () {
    test('should convert BatchApiModel to BatchEntity correctly', () {
      final result = tBatchApiModel.toEntity();

      expect(result, isA<BatchEntity>());
      expect(result.batchId, '1');
      expect(result.batchName, 'Batch 1');
      expect(result.status, 'active');
    });
  });

  group('fromEntity', () {
    test('should convert BatchEntity to BatchApiModel correctly', () {
      final result = BatchApiModel.fromEntity(tBatchEntity);

      expect(result, isA<BatchApiModel>());
      expect(result.batchName, 'Batch 1');
    });
  });

  group('toEntityList', () {
    test('should convert list of BatchApiModel to list of BatchEntity', () {
      final models = [tBatchApiModel, tBatchApiModel];

      final result = BatchApiModel.toEntityList(models);

      expect(result, isA<List<BatchEntity>>());
      expect(result.length, 2);
      expect(result[0].batchName, 'Batch 1');
      expect(result[1].batchName, 'Batch 1');
    });
  });
}
