import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lost_n_found/core/error/failures.dart';
import 'package:lost_n_found/features/category/domain/entities/category_entity.dart';
import 'package:lost_n_found/features/category/domain/repositories/category_repository.dart';
import 'package:lost_n_found/features/category/domain/usecases/get_all_categories_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockCategoryRepository extends Mock implements ICategoryRepository {}

void main() {
  late GetAllCategoriesUsecase usecase;
  late MockCategoryRepository mockRepository;

  setUp(() {
    mockRepository = MockCategoryRepository();
    usecase = GetAllCategoriesUsecase(categoryRepository: mockRepository);
  });

  const tCategories = [
    CategoryEntity(
      categoryId: '1',
      name: 'Electronics',
      description: 'Electronic devices',
      status: 'active',
    ),
    CategoryEntity(
      categoryId: '2',
      name: 'Clothing',
      description: 'Clothes and accessories',
      status: 'active',
    ),
  ];

  group('GetAllCategoriesUsecase', () {
    test('should return list of categories when successful', () async {
      // Arrange
      when(
        () => mockRepository.getAllCategories(),
      ).thenAnswer((_) async => const Right(tCategories));

      // Act
      final result = await usecase();

      // Assert
      expect(result, const Right(tCategories));
      verify(() => mockRepository.getAllCategories()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return failure when repository fails', () async {
      // Arrange
      const failure = ApiFailure(message: 'Failed to fetch categories');
      when(
        () => mockRepository.getAllCategories(),
      ).thenAnswer((_) async => const Left(failure));

      // Act
      final result = await usecase();

      // Assert
      expect(result, const Left(failure));
      verify(() => mockRepository.getAllCategories()).called(1);
    });

    test('should return NetworkFailure when there is no internet', () async {
      // Arrange
      const failure = NetworkFailure();
      when(
        () => mockRepository.getAllCategories(),
      ).thenAnswer((_) async => const Left(failure));

      // Act
      final result = await usecase();

      // Assert
      expect(result, const Left(failure));
      verify(() => mockRepository.getAllCategories()).called(1);
    });

    test('should return empty list when no categories exist', () async {
      // Arrange
      when(
        () => mockRepository.getAllCategories(),
      ).thenAnswer((_) async => const Right(<CategoryEntity>[]));

      // Act
      final result = await usecase();

      // Assert
      expect(result, const Right(<CategoryEntity>[]));
      verify(() => mockRepository.getAllCategories()).called(1);
    });
  });
}
