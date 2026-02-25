import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:lost_n_found/core/error/failures.dart';
import 'package:lost_n_found/features/category/domain/entities/category_entity.dart';
import 'package:lost_n_found/features/category/domain/usecases/get_all_categories_usecase.dart';
import 'package:lost_n_found/features/category/domain/usecases/get_category_by_id_usecase.dart';
import 'package:lost_n_found/features/category/domain/usecases/create_category_usecase.dart';
import 'package:lost_n_found/features/category/domain/usecases/update_category_usecase.dart';
import 'package:lost_n_found/features/category/domain/usecases/delete_category_usecase.dart';

import '../../../../mocks/test_mocks.dart';

void main() {
  late MockCategoryRepository mockCategoryRepository;

  setUpAll(() {
    registerFallbackValue(const CategoryEntity(name: ''));
  });

  setUp(() {
    mockCategoryRepository = MockCategoryRepository();
  });

  // ──────────────────────────────────────────────
  // GetAllCategoriesUsecase
  // ──────────────────────────────────────────────
  group('GetAllCategoriesUsecase', () {
    late GetAllCategoriesUsecase usecase;

    setUp(() {
      usecase = GetAllCategoriesUsecase(
          categoryRepository: mockCategoryRepository);
    });

    final tCategoryList = [
      const CategoryEntity(
        categoryId: '1',
        name: 'Electronics',
        description: 'Electronic devices',
      ),
      const CategoryEntity(
        categoryId: '2',
        name: 'Documents',
        description: 'Important documents',
      ),
    ];

    test('should return list of categories on success', () async {
      // Arrange
      when(() => mockCategoryRepository.getAllCategories())
          .thenAnswer((_) async => Right(tCategoryList));

      // Act
      final result = await usecase();

      // Assert
      expect(result, Right(tCategoryList));
      verify(() => mockCategoryRepository.getAllCategories()).called(1);
      verifyNoMoreInteractions(mockCategoryRepository);
    });

    test('should return Failure when repository fails', () async {
      // Arrange
      const tFailure = ApiFailure(message: 'Failed to fetch categories');
      when(() => mockCategoryRepository.getAllCategories())
          .thenAnswer((_) async => const Left(tFailure));

      // Act
      final result = await usecase();

      // Assert
      expect(result, const Left(tFailure));
      verify(() => mockCategoryRepository.getAllCategories()).called(1);
      verifyNoMoreInteractions(mockCategoryRepository);
    });
  });

  // ──────────────────────────────────────────────
  // GetCategoryByIdUsecase
  // ──────────────────────────────────────────────
  group('GetCategoryByIdUsecase', () {
    late GetCategoryByIdUsecase usecase;

    setUp(() {
      usecase = GetCategoryByIdUsecase(
          categoryRepository: mockCategoryRepository);
    });

    const tCategoryId = 'cat-1';
    const tParams = GetCategoryByIdParams(categoryId: tCategoryId);
    const tCategoryEntity = CategoryEntity(
      categoryId: tCategoryId,
      name: 'Electronics',
      description: 'Electronic devices',
    );

    test('should return CategoryEntity on success', () async {
      // Arrange
      when(() => mockCategoryRepository.getCategoryById(tCategoryId))
          .thenAnswer((_) async => const Right(tCategoryEntity));

      // Act
      final result = await usecase(tParams);

      // Assert
      expect(result, const Right(tCategoryEntity));
      verify(() => mockCategoryRepository.getCategoryById(tCategoryId))
          .called(1);
      verifyNoMoreInteractions(mockCategoryRepository);
    });

    test('should return Failure when repository fails', () async {
      // Arrange
      const tFailure = ApiFailure(message: 'Category not found');
      when(() => mockCategoryRepository.getCategoryById(tCategoryId))
          .thenAnswer((_) async => const Left(tFailure));

      // Act
      final result = await usecase(tParams);

      // Assert
      expect(result, const Left(tFailure));
      verify(() => mockCategoryRepository.getCategoryById(tCategoryId))
          .called(1);
      verifyNoMoreInteractions(mockCategoryRepository);
    });
  });

  // ──────────────────────────────────────────────
  // CreateCategoryUsecase
  // ──────────────────────────────────────────────
  group('CreateCategoryUsecase', () {
    late CreateCategoryUsecase usecase;

    setUp(() {
      usecase = CreateCategoryUsecase(
          categoryRepository: mockCategoryRepository);
    });

    const tParams = CreateCategoryParams(
      name: 'Electronics',
      description: 'Electronic devices',
    );

    test('should return true on successful category creation', () async {
      // Arrange
      when(() => mockCategoryRepository.createCategory(any()))
          .thenAnswer((_) async => const Right(true));

      // Act
      final result = await usecase(tParams);

      // Assert
      expect(result, const Right(true));
      verify(() => mockCategoryRepository.createCategory(any())).called(1);
      verifyNoMoreInteractions(mockCategoryRepository);
    });

    test('should return Failure on unsuccessful category creation', () async {
      // Arrange
      const tFailure = ApiFailure(message: 'Failed to create category');
      when(() => mockCategoryRepository.createCategory(any()))
          .thenAnswer((_) async => const Left(tFailure));

      // Act
      final result = await usecase(tParams);

      // Assert
      expect(result, const Left(tFailure));
      verify(() => mockCategoryRepository.createCategory(any())).called(1);
      verifyNoMoreInteractions(mockCategoryRepository);
    });
  });

  // ──────────────────────────────────────────────
  // UpdateCategoryUsecase
  // ──────────────────────────────────────────────
  group('UpdateCategoryUsecase', () {
    late UpdateCategoryUsecase usecase;

    setUp(() {
      usecase = UpdateCategoryUsecase(
          categoryRepository: mockCategoryRepository);
    });

    const tParams = UpdateCategoryParams(
      categoryId: 'cat-1',
      name: 'Updated Electronics',
      description: 'Updated description',
      status: 'active',
    );

    test('should return true on successful category update', () async {
      // Arrange
      when(() => mockCategoryRepository.updateCategory(any()))
          .thenAnswer((_) async => const Right(true));

      // Act
      final result = await usecase(tParams);

      // Assert
      expect(result, const Right(true));
      verify(() => mockCategoryRepository.updateCategory(any())).called(1);
      verifyNoMoreInteractions(mockCategoryRepository);
    });

    test('should return Failure on unsuccessful category update', () async {
      // Arrange
      const tFailure = ApiFailure(message: 'Failed to update category');
      when(() => mockCategoryRepository.updateCategory(any()))
          .thenAnswer((_) async => const Left(tFailure));

      // Act
      final result = await usecase(tParams);

      // Assert
      expect(result, const Left(tFailure));
      verify(() => mockCategoryRepository.updateCategory(any())).called(1);
      verifyNoMoreInteractions(mockCategoryRepository);
    });
  });

  // ──────────────────────────────────────────────
  // DeleteCategoryUsecase
  // ──────────────────────────────────────────────
  group('DeleteCategoryUsecase', () {
    late DeleteCategoryUsecase usecase;

    setUp(() {
      usecase = DeleteCategoryUsecase(
          categoryRepository: mockCategoryRepository);
    });

    const tCategoryId = 'cat-1';
    const tParams = DeleteCategoryParams(categoryId: tCategoryId);

    test('should return true on successful category deletion', () async {
      // Arrange
      when(() => mockCategoryRepository.deleteCategory(tCategoryId))
          .thenAnswer((_) async => const Right(true));

      // Act
      final result = await usecase(tParams);

      // Assert
      expect(result, const Right(true));
      verify(() => mockCategoryRepository.deleteCategory(tCategoryId))
          .called(1);
      verifyNoMoreInteractions(mockCategoryRepository);
    });

    test('should return Failure on unsuccessful category deletion', () async {
      // Arrange
      const tFailure = ApiFailure(message: 'Failed to delete category');
      when(() => mockCategoryRepository.deleteCategory(tCategoryId))
          .thenAnswer((_) async => const Left(tFailure));

      // Act
      final result = await usecase(tParams);

      // Assert
      expect(result, const Left(tFailure));
      verify(() => mockCategoryRepository.deleteCategory(tCategoryId))
          .called(1);
      verifyNoMoreInteractions(mockCategoryRepository);
    });
  });
}
