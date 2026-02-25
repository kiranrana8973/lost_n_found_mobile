import 'package:flutter_test/flutter_test.dart';
import 'package:lost_n_found/features/batch/domain/entities/batch_entity.dart';

void main() {
  const tBatchEntity = BatchEntity(
    batchId: 'batch-1',
    batchName: 'Batch 2024',
    status: 'active',
  );

  group('BatchEntity', () {
    test('should create a BatchEntity with required fields only', () {
      const entity = BatchEntity(batchName: 'Batch 2025');

      expect(entity.batchName, 'Batch 2025');
      expect(entity.batchId, isNull);
      expect(entity.status, isNull);
    });

    test('should create a BatchEntity with all fields', () {
      expect(tBatchEntity.batchId, 'batch-1');
      expect(tBatchEntity.batchName, 'Batch 2024');
      expect(tBatchEntity.status, 'active');
    });

    test('should be equal when all properties are the same', () {
      const anotherEntity = BatchEntity(
        batchId: 'batch-1',
        batchName: 'Batch 2024',
        status: 'active',
      );

      expect(tBatchEntity, equals(anotherEntity));
    });

    test('should not be equal when properties differ', () {
      const differentEntity = BatchEntity(
        batchId: 'batch-2',
        batchName: 'Batch 2023',
        status: 'inactive',
      );

      expect(tBatchEntity, isNot(equals(differentEntity)));
    });

    test('should have correct props list', () {
      expect(tBatchEntity.props, ['batch-1', 'Batch 2024', 'active']);
    });
  });
}
