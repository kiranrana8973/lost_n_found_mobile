import 'package:flutter_test/flutter_test.dart';
import 'package:lost_n_found/features/batch/domain/entities/batch_entity.dart';
import 'package:lost_n_found/features/batch/presentation/state/batch_state.dart';

void main() {
  const tBatch1 = BatchEntity(
    batchId: 'batch-1',
    batchName: 'Batch 2024',
    status: 'active',
  );

  const tBatch2 = BatchEntity(
    batchId: 'batch-2',
    batchName: 'Batch 2025',
    status: 'active',
  );

  group('BatchState', () {
    test('should have correct default values', () {
      const state = BatchState();

      expect(state.status, BatchStatus.initial);
      expect(state.batches, const <BatchEntity>[]);
      expect(state.selectedBatch, isNull);
      expect(state.errorMessage, isNull);
    });

    test('should create with provided values', () {
      const state = BatchState(
        status: BatchStatus.loaded,
        batches: [tBatch1, tBatch2],
        selectedBatch: tBatch1,
        errorMessage: 'Some error',
      );

      expect(state.status, BatchStatus.loaded);
      expect(state.batches, [tBatch1, tBatch2]);
      expect(state.selectedBatch, tBatch1);
      expect(state.errorMessage, 'Some error');
    });

    group('copyWith', () {
      test('should preserve unchanged fields when no arguments are passed',
          () {
        const original = BatchState(
          status: BatchStatus.loaded,
          batches: [tBatch1],
          selectedBatch: tBatch1,
          errorMessage: 'error',
        );

        final copied = original.copyWith();

        expect(copied.status, BatchStatus.loaded);
        expect(copied.batches, [tBatch1]);
        expect(copied.selectedBatch, tBatch1);
        expect(copied.errorMessage, 'error');
      });

      test('should update only status', () {
        const original = BatchState();

        final copied = original.copyWith(status: BatchStatus.loading);

        expect(copied.status, BatchStatus.loading);
        expect(copied.batches, const <BatchEntity>[]);
        expect(copied.selectedBatch, isNull);
        expect(copied.errorMessage, isNull);
      });

      test('should update only batches', () {
        const original = BatchState();

        final copied = original.copyWith(batches: [tBatch1, tBatch2]);

        expect(copied.status, BatchStatus.initial);
        expect(copied.batches, [tBatch1, tBatch2]);
      });

      test('should update only selectedBatch', () {
        const original = BatchState();

        final copied = original.copyWith(selectedBatch: tBatch1);

        expect(copied.selectedBatch, tBatch1);
        expect(copied.status, BatchStatus.initial);
      });

      test('should update only errorMessage', () {
        const original = BatchState();

        final copied = original.copyWith(errorMessage: 'Failed to load');

        expect(copied.errorMessage, 'Failed to load');
        expect(copied.status, BatchStatus.initial);
      });

      test('should update all fields', () {
        const original = BatchState();

        final copied = original.copyWith(
          status: BatchStatus.error,
          batches: [tBatch1],
          selectedBatch: tBatch1,
          errorMessage: 'Error occurred',
        );

        expect(copied.status, BatchStatus.error);
        expect(copied.batches, [tBatch1]);
        expect(copied.selectedBatch, tBatch1);
        expect(copied.errorMessage, 'Error occurred');
      });
    });

    group('equality', () {
      test('should be equal when all properties are the same', () {
        const state1 = BatchState(
          status: BatchStatus.loaded,
          batches: [tBatch1],
          selectedBatch: tBatch1,
        );
        const state2 = BatchState(
          status: BatchStatus.loaded,
          batches: [tBatch1],
          selectedBatch: tBatch1,
        );

        expect(state1, equals(state2));
      });

      test('should not be equal when status differs', () {
        const state1 = BatchState(status: BatchStatus.initial);
        const state2 = BatchState(status: BatchStatus.loading);

        expect(state1, isNot(equals(state2)));
      });

      test('should not be equal when batches differ', () {
        const state1 = BatchState(batches: [tBatch1]);
        const state2 = BatchState(batches: [tBatch2]);

        expect(state1, isNot(equals(state2)));
      });

      test('should not be equal when selectedBatch differs', () {
        const state1 = BatchState(selectedBatch: tBatch1);
        const state2 = BatchState(selectedBatch: tBatch2);

        expect(state1, isNot(equals(state2)));
      });

      test('should not be equal when errorMessage differs', () {
        const state1 = BatchState(errorMessage: 'error1');
        const state2 = BatchState(errorMessage: 'error2');

        expect(state1, isNot(equals(state2)));
      });

      test('should have correct props list', () {
        const state = BatchState(
          status: BatchStatus.loaded,
          batches: [tBatch1],
          selectedBatch: tBatch1,
          errorMessage: 'test',
        );

        expect(state.props, [
          BatchStatus.loaded,
          [tBatch1],
          tBatch1,
          'test',
        ]);
      });
    });
  });
}
