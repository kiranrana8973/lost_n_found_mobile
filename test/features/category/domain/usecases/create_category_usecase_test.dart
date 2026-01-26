import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lost_n_found/core/error/failures.dart';
import 'package:lost_n_found/features/category/domain/entities/category_entity.dart';
import 'package:lost_n_found/features/category/domain/repositories/category_repository.dart';
import 'package:lost_n_found/features/category/domain/usecases/create_category_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockCategoryRepository extends Mock implements ICategoryRepository {}

void main() {
  late CreateCategoryUsecase usecase;
  late MockCategoryRepository mockRepository;

  setUp(() {
    mockRepository = MockCategoryRepository();
    usecase = CreateCategoryUsecase(categoryRepository: mockRepository);
  });

  setUpAll(() {
    registerFallbackValue(
      const CategoryEntity(name: 'fallback'),
    );
  });

  const tName = 'Electronics';
  const tDescription = 'Electronic devices';
  const tParams = CreateCategoryParams(
    name: tName,
    description: tDescription,
  );

  group('CreateCategoryUsecase', () {
    test('should return true when category is created successfully', () async {
      // Arrange
      when(
        () => mockRepository.createCategory(any()),
      ).thenAnswer((_) async => const Right(true));

      // Act
      final result = await usecase(tParams);

      // Assert
      expect(result, const Right(true));
      verify(() => mockRepository.createCategory(any())).called(1);
    });

    test('should return failure when creation fails', () async {
      // Arrange
      const failure = ApiFailure(message: 'Failed to create category');
      when(
        () => mockRepository.createCategory(any()),
      ).thenAnswer((_) async => const Left(failure));

      // Act
      final result = await usecase(tParams);

      // Assert
      expect(result, const Left(failure));
      verify(() => mockRepository.createCategory(any())).called(1);
    });

    test('should pass correct category entity to repository', () async {
      // Arrange
      when(
        () => mockRepository.createCategory(any()),
      ).thenAnswer((_) async => const Right(true));

      // Act
      await usecase(tParams);

      // Assert
      final captured = verify(
        () => mockRepository.createCategory(captureAny()),
      ).captured.first as CategoryEntity;

      expect(captured.name, tName);
      expect(captured.description, tDescription);
    });

    test(
      'should succeed with valid params and fail with invalid params',
      () async {
        // Arrange
        const validParams = CreateCategoryParams(
          name: tName,
          description: tDescription,
        );
        const invalidParams = CreateCategoryParams(name: '');
        const failure = ApiFailure(message: 'Invalid category name');

        when(() => mockRepository.createCategory(any())).thenAnswer((
          invocation,
        ) async {
          final category =
              invocation.positionalArguments[0] as CategoryEntity;

          if (category.name.isNotEmpty) {
            return const Right(true);
          }
          return const Left(failure);
        });

        // Act & Assert - Valid params should succeed
        final successResult = await usecase(validParams);
        expect(successResult, const Right(true));

        // Act & Assert - Invalid params should fail
        final failResult = await usecase(invalidParams);
        expect(failResult, const Left(failure));
      },
    );
  });

  group('CreateCategoryParams', () {
    test('should have correct props', () {
      expect(tParams.props, [tName, tDescription]);
    });

    test('two params with same values should be equal', () {
      const params1 = CreateCategoryParams(
        name: tName,
        description: tDescription,
      );
      const params2 = CreateCategoryParams(
        name: tName,
        description: tDescription,
      );
      expect(params1, params2);
    });

    test('two params with different values should not be equal', () {
      const params1 = CreateCategoryParams(name: tName);
      const params2 = CreateCategoryParams(name: 'Other');
      expect(params1, isNot(params2));
    });
  });
}
