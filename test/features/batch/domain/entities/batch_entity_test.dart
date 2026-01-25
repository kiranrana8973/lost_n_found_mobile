import 'package:flutter_test/flutter_test.dart';
import 'package:lost_n_found/features/batch/domain/entities/batch_entity.dart';

void main() {
  group('BatchEntity', () {
    test('should create BatchEntity with all properties', () {
      const batch = BatchEntity(
        batchId: '123',
        batchName: 'Batch 2024',
        status: 'active',
      );

      expect(batch.batchId, '123');
      expect(batch.batchName, 'Batch 2024');
      expect(batch.status, 'active');
    });

    test('should create BatchEntity with only required properties', () {
      const batch = BatchEntity(batchName: 'Batch 2024');

      expect(batch.batchId, isNull);
      expect(batch.batchName, 'Batch 2024');
      expect(batch.status, isNull);
    });

    test('should have correct props for Equatable', () {
      const batch = BatchEntity(
        batchId: '123',
        batchName: 'Batch 2024',
        status: 'active',
      );

      expect(batch.props, ['123', 'Batch 2024', 'active']);
    });

    test('two BatchEntity with same values should be equal', () {
      const batch1 = BatchEntity(
        batchId: '123',
        batchName: 'Batch 2024',
        status: 'active',
      );

      const batch2 = BatchEntity(
        batchId: '123',
        batchName: 'Batch 2024',
        status: 'active',
      );

      expect(batch1, equals(batch2));
    });

    test('two BatchEntity with different values should not be equal', () {
      const batch1 = BatchEntity(
        batchId: '123',
        batchName: 'Batch 2024',
        status: 'active',
      );

      const batch2 = BatchEntity(
        batchId: '456',
        batchName: 'Batch 2025',
        status: 'inactive',
      );

      expect(batch1, isNot(equals(batch2)));
    });
  });
}
