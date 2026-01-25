import 'package:flutter_test/flutter_test.dart';
import 'package:lost_n_found/features/batch/data/models/batch_api_model.dart';
import 'package:lost_n_found/features/batch/domain/entities/batch_entity.dart';

void main() {
  group('BatchApiModel', () {
    const tId = '123';
    const tBatchName = 'Batch 2024';
    const tStatus = 'active';

    final tBatchApiModel = BatchApiModel(
      id: tId,
      batchName: tBatchName,
      status: tStatus,
    );

    final tJson = {'_id': tId, 'batchName': tBatchName, 'status': tStatus};

    group('fromJson', () {
      test('should return a valid model from JSON', () {
        final result = BatchApiModel.fromJson(tJson);

        expect(result.id, tId);
        expect(result.batchName, tBatchName);
        expect(result.status, tStatus);
      });
    });

    group('toJson', () {
      test('should return a JSON map containing proper data', () {
        final result = tBatchApiModel.toJson();

        expect(result, {'batchName': tBatchName});
      });
    });

    group('toEntity', () {
      test('should return a BatchEntity from BatchApiModel', () {
        final result = tBatchApiModel.toEntity();

        expect(result, isA<BatchEntity>());
        expect(result.batchId, tId);
        expect(result.batchName, tBatchName);
        expect(result.status, tStatus);
      });
    });

    group('fromEntity', () {
      test('should return a BatchApiModel from BatchEntity', () {
        const entity = BatchEntity(
          batchId: tId,
          batchName: tBatchName,
          status: tStatus,
        );

        final result = BatchApiModel.fromEntity(entity);

        expect(result.batchName, tBatchName);
      });
    });

    group('toEntityList', () {
      test('should convert list of BatchApiModel to list of BatchEntity', () {
        final models = [
          BatchApiModel(id: '1', batchName: 'Batch 1', status: 'active'),
          BatchApiModel(id: '2', batchName: 'Batch 2', status: 'inactive'),
        ];

        final result = BatchApiModel.toEntityList(models);

        expect(result, isA<List<BatchEntity>>());
        expect(result.length, 2);
        expect(result[0].batchId, '1');
        expect(result[0].batchName, 'Batch 1');
        expect(result[1].batchId, '2');
        expect(result[1].batchName, 'Batch 2');
      });

      test('should return empty list when given empty list', () {
        final result = BatchApiModel.toEntityList([]);

        expect(result, isEmpty);
      });
    });
  });
}
