import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lost_n_found/core/error/failures.dart';
import 'package:lost_n_found/features/batch/domain/entities/batch_entity.dart';
import 'package:lost_n_found/features/batch/domain/repositories/batch_repository.dart';
import 'package:lost_n_found/features/batch/domain/usecases/get_all_batch_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockBatchRepository extends Mock implements IBatchRepository {}

void main() {
  late GetAllBatchUsecase usecase;
  late MockBatchRepository mockRepository;

  setUp(() {
    mockRepository = MockBatchRepository();
    usecase = GetAllBatchUsecase(batchRepository: mockRepository);
  });

  final tBatches = [
    const BatchEntity(batchId: '1', batchName: 'Batch 1', status: 'active'),
    const BatchEntity(batchId: '2', batchName: 'Batch 2', status: 'active'),
  ];

  group('GetAllBatchUsecase', () {
    test('should return list of batches when repository call is successful',
        () async {
      // Arrange
      when(() => mockRepository.getAllBatches())
          .thenAnswer((_) async => Right(tBatches));

      // Act
      final result = await usecase();

      // Assert
      expect(result, Right(tBatches));
      verify(() => mockRepository.getAllBatches()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return failure when repository call fails', () async {
      // Arrange
      const failure = ApiFailure(message: 'Failed to fetch batches');
      when(() => mockRepository.getAllBatches())
          .thenAnswer((_) async => const Left(failure));

      // Act
      final result = await usecase();

      // Assert
      expect(result, const Left(failure));
      verify(() => mockRepository.getAllBatches()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return empty list when no batches exist', () async {
      // Arrange
      when(() => mockRepository.getAllBatches())
          .thenAnswer((_) async => const Right([]));

      // Act
      final result = await usecase();

      // Assert
      expect(result, const Right(<BatchEntity>[]));
      verify(() => mockRepository.getAllBatches()).called(1);
    });

    test('should return NetworkFailure when there is no internet', () async {
      // Arrange
      const failure = NetworkFailure();
      when(() => mockRepository.getAllBatches())
          .thenAnswer((_) async => const Left(failure));

      // Act
      final result = await usecase();

      // Assert
      expect(result, const Left(failure));
      verify(() => mockRepository.getAllBatches()).called(1);
    });
  });
}
