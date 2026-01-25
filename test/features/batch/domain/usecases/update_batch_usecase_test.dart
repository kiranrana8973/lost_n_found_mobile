import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lost_n_found/core/error/failures.dart';
import 'package:lost_n_found/features/batch/domain/entities/batch_entity.dart';
import 'package:lost_n_found/features/batch/domain/repositories/batch_repository.dart';
import 'package:lost_n_found/features/batch/domain/usecases/update_batch_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockBatchRepository extends Mock implements IBatchRepository {}

void main() {
  late UpdateBatchUsecase usecase;
  late MockBatchRepository mockRepository;

  setUp(() {
    mockRepository = MockBatchRepository();
    usecase = UpdateBatchUsecase(batchRepository: mockRepository);
  });

  setUpAll(() {
    registerFallbackValue(const BatchEntity(batchName: 'fallback'));
  });

  const tBatchId = '1';
  const tBatchName = 'Updated Batch';
  const tStatus = 'inactive';

  group('UpdateBatchUsecase', () {
    test('should return true when batch is updated successfully', () async {
      // Arrange
      when(
        () => mockRepository.updateBatch(any()),
      ).thenAnswer((_) async => const Right(true));

      // Act
      final result = await usecase(
        const UpdateBatchParams(batchId: tBatchId, batchName: tBatchName),
      );

      // Assert
      expect(result, const Right(true));
      verify(() => mockRepository.updateBatch(any())).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should pass BatchEntity with correct values to repository', () async {
      // Arrange
      BatchEntity? capturedEntity;
      when(() => mockRepository.updateBatch(any())).thenAnswer((invocation) {
        capturedEntity = invocation.positionalArguments[0] as BatchEntity;
        return Future.value(const Right(true));
      });

      // Act
      await usecase(
        const UpdateBatchParams(
          batchId: tBatchId,
          batchName: tBatchName,
          status: tStatus,
        ),
      );

      // Assert
      expect(capturedEntity?.batchId, tBatchId);
      expect(capturedEntity?.batchName, tBatchName);
      expect(capturedEntity?.status, tStatus);
    });

    test('should handle null status correctly', () async {
      // Arrange
      BatchEntity? capturedEntity;
      when(() => mockRepository.updateBatch(any())).thenAnswer((invocation) {
        capturedEntity = invocation.positionalArguments[0] as BatchEntity;
        return Future.value(const Right(true));
      });

      // Act
      await usecase(
        const UpdateBatchParams(batchId: tBatchId, batchName: tBatchName),
      );

      // Assert
      expect(capturedEntity?.status, isNull);
    });

    test('should return failure when repository call fails', () async {
      // Arrange
      const failure = ApiFailure(message: 'Failed to update batch');
      when(
        () => mockRepository.updateBatch(any()),
      ).thenAnswer((_) async => const Left(failure));

      // Act
      final result = await usecase(
        const UpdateBatchParams(batchId: tBatchId, batchName: tBatchName),
      );

      // Assert
      expect(result, const Left(failure));
      verify(() => mockRepository.updateBatch(any())).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return NetworkFailure when there is no internet', () async {
      // Arrange
      const failure = NetworkFailure();
      when(
        () => mockRepository.updateBatch(any()),
      ).thenAnswer((_) async => const Left(failure));

      // Act
      final result = await usecase(
        const UpdateBatchParams(batchId: tBatchId, batchName: tBatchName),
      );

      // Assert
      expect(result, const Left(failure));
      verify(() => mockRepository.updateBatch(any())).called(1);
    });
  });

  group('UpdateBatchParams', () {
    test('should have correct props with status', () {
      // Arrange
      const params = UpdateBatchParams(
        batchId: tBatchId,
        batchName: tBatchName,
        status: tStatus,
      );

      // Assert
      expect(params.props, [tBatchId, tBatchName, tStatus]);
    });

    test('should have correct props without status', () {
      // Arrange
      const params = UpdateBatchParams(
        batchId: tBatchId,
        batchName: tBatchName,
      );

      // Assert
      expect(params.props, [tBatchId, tBatchName, null]);
    });

    test('two params with same values should be equal', () {
      // Arrange
      const params1 = UpdateBatchParams(
        batchId: tBatchId,
        batchName: tBatchName,
        status: tStatus,
      );
      const params2 = UpdateBatchParams(
        batchId: tBatchId,
        batchName: tBatchName,
        status: tStatus,
      );

      // Assert
      expect(params1, params2);
    });
  });
}
