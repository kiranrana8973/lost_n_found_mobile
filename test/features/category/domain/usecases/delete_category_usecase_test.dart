import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lost_n_found/core/error/failures.dart';
import 'package:lost_n_found/features/category/domain/repositories/category_repository.dart';
import 'package:lost_n_found/features/category/domain/usecases/delete_category_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockCategoryRepository extends Mock implements ICategoryRepository {}

void main() {
  late DeleteCategoryUsecase usecase;
  late MockCategoryRepository mockRepository;

  setUp(() {
    mockRepository = MockCategoryRepository();
    usecase = DeleteCategoryUsecase(categoryRepository: mockRepository);
  });

  const tCategoryId = '123';
  const tParams = DeleteCategoryParams(categoryId: tCategoryId);

  group('DeleteCategoryUsecase', () {
    test('should return true when category is deleted successfully', () async {
      // Arrange
      when(
        () => mockRepository.deleteCategory(tCategoryId),
      ).thenAnswer((_) async => const Right(true));

      // Act
      final result = await usecase(tParams);

      // Assert
      expect(result, const Right(true));
      verify(() => mockRepository.deleteCategory(tCategoryId)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return failure when deletion fails', () async {
      // Arrange
      const failure = ApiFailure(message: 'Failed to delete category');
      when(
        () => mockRepository.deleteCategory(tCategoryId),
      ).thenAnswer((_) async => const Left(failure));

      // Act
      final result = await usecase(tParams);

      // Assert
      expect(result, const Left(failure));
      verify(() => mockRepository.deleteCategory(tCategoryId)).called(1);
    });

    test('should return failure when category not found', () async {
      // Arrange
      const failure = ApiFailure(message: 'Category not found');
      when(
        () => mockRepository.deleteCategory(tCategoryId),
      ).thenAnswer((_) async => const Left(failure));

      // Act
      final result = await usecase(tParams);

      // Assert
      expect(result, const Left(failure));
    });

    test('should succeed with valid id and fail with invalid id', () async {
      // Arrange
      const validId = '123';
      const invalidId = '';
      const failure = ApiFailure(message: 'Invalid category id');

      when(() => mockRepository.deleteCategory(any())).thenAnswer((
        invocation,
      ) async {
        final categoryId = invocation.positionalArguments[0] as String;

        if (categoryId.isNotEmpty) {
          return const Right(true);
        }
        return const Left(failure);
      });

      // Act & Assert - Valid id should succeed
      final successResult = await usecase(
        const DeleteCategoryParams(categoryId: validId),
      );
      expect(successResult, const Right(true));

      // Act & Assert - Invalid id should fail
      final failResult = await usecase(
        const DeleteCategoryParams(categoryId: invalidId),
      );
      expect(failResult, const Left(failure));
    });
  });

  group('DeleteCategoryParams', () {
    test('should have correct props', () {
      expect(tParams.props, [tCategoryId]);
    });

    test('two params with same values should be equal', () {
      const params1 = DeleteCategoryParams(categoryId: tCategoryId);
      const params2 = DeleteCategoryParams(categoryId: tCategoryId);
      expect(params1, params2);
    });

    test('two params with different values should not be equal', () {
      const params1 = DeleteCategoryParams(categoryId: tCategoryId);
      const params2 = DeleteCategoryParams(categoryId: '456');
      expect(params1, isNot(params2));
    });
  });
}
