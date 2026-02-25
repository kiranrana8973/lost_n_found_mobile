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

  group('GetAllCategoriesUsecase', () {
    late GetAllCategoriesUsecase usecase;

    setUp(() {
      usecase = GetAllCategoriesUsecase(
        categoryRepository: mockCategoryRepository,
      );
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
      when(
        () => mockCategoryRepository.getAllCategories(),
      ).thenAnswer((_) async => Right(tCategoryList));

      final result = await usecase();

      expect(result, Right(tCategoryList));
      verify(() => mockCategoryRepository.getAllCategories()).called(1);
      verifyNoMoreInteractions(mockCategoryRepository);
    });

    test('should return Failure when repository fails', () async {
      const tFailure = ApiFailure(message: 'Failed to fetch categories');
      when(
        () => mockCategoryRepository.getAllCategories(),
      ).thenAnswer((_) async => const Left(tFailure));

      final result = await usecase();

      expect(result, const Left(tFailure));
      verify(() => mockCategoryRepository.getAllCategories()).called(1);
      verifyNoMoreInteractions(mockCategoryRepository);
    });
  });

  group('GetCategoryByIdUsecase', () {
    late GetCategoryByIdUsecase usecase;

    setUp(() {
      usecase = GetCategoryByIdUsecase(
        categoryRepository: mockCategoryRepository,
      );
    });

    const tCategoryId = 'cat-1';
    const tParams = GetCategoryByIdParams(categoryId: tCategoryId);
    const tCategoryEntity = CategoryEntity(
      categoryId: tCategoryId,
      name: 'Electronics',
      description: 'Electronic devices',
    );

    test('should return CategoryEntity on success', () async {
      when(
        () => mockCategoryRepository.getCategoryById(tCategoryId),
      ).thenAnswer((_) async => const Right(tCategoryEntity));

      final result = await usecase(tParams);

      expect(result, const Right(tCategoryEntity));
      verify(
        () => mockCategoryRepository.getCategoryById(tCategoryId),
      ).called(1);
      verifyNoMoreInteractions(mockCategoryRepository);
    });

    test('should return Failure when repository fails', () async {
      const tFailure = ApiFailure(message: 'Category not found');
      when(
        () => mockCategoryRepository.getCategoryById(tCategoryId),
      ).thenAnswer((_) async => const Left(tFailure));

      final result = await usecase(tParams);

      expect(result, const Left(tFailure));
      verify(
        () => mockCategoryRepository.getCategoryById(tCategoryId),
      ).called(1);
      verifyNoMoreInteractions(mockCategoryRepository);
    });
  });

  group('CreateCategoryUsecase', () {
    late CreateCategoryUsecase usecase;

    setUp(() {
      usecase = CreateCategoryUsecase(
        categoryRepository: mockCategoryRepository,
      );
    });

    const tParams = CreateCategoryParams(
      name: 'Electronics',
      description: 'Electronic devices',
    );

    test('should return true on successful category creation', () async {
      when(
        () => mockCategoryRepository.createCategory(any()),
      ).thenAnswer((_) async => const Right(true));

      final result = await usecase(tParams);

      expect(result, const Right(true));
      verify(() => mockCategoryRepository.createCategory(any())).called(1);
      verifyNoMoreInteractions(mockCategoryRepository);
    });

    test('should return Failure on unsuccessful category creation', () async {
      const tFailure = ApiFailure(message: 'Failed to create category');
      when(
        () => mockCategoryRepository.createCategory(any()),
      ).thenAnswer((_) async => const Left(tFailure));

      final result = await usecase(tParams);

      expect(result, const Left(tFailure));
      verify(() => mockCategoryRepository.createCategory(any())).called(1);
      verifyNoMoreInteractions(mockCategoryRepository);
    });
  });

  group('UpdateCategoryUsecase', () {
    late UpdateCategoryUsecase usecase;

    setUp(() {
      usecase = UpdateCategoryUsecase(
        categoryRepository: mockCategoryRepository,
      );
    });

    const tParams = UpdateCategoryParams(
      categoryId: 'cat-1',
      name: 'Updated Electronics',
      description: 'Updated description',
      status: 'active',
    );

    test('should return true on successful category update', () async {
      when(
        () => mockCategoryRepository.updateCategory(any()),
      ).thenAnswer((_) async => const Right(true));

      final result = await usecase(tParams);

      expect(result, const Right(true));
      verify(() => mockCategoryRepository.updateCategory(any())).called(1);
      verifyNoMoreInteractions(mockCategoryRepository);
    });

    test('should return Failure on unsuccessful category update', () async {
      const tFailure = ApiFailure(message: 'Failed to update category');
      when(
        () => mockCategoryRepository.updateCategory(any()),
      ).thenAnswer((_) async => const Left(tFailure));

      final result = await usecase(tParams);

      expect(result, const Left(tFailure));
      verify(() => mockCategoryRepository.updateCategory(any())).called(1);
      verifyNoMoreInteractions(mockCategoryRepository);
    });
  });

  group('DeleteCategoryUsecase', () {
    late DeleteCategoryUsecase usecase;

    setUp(() {
      usecase = DeleteCategoryUsecase(
        categoryRepository: mockCategoryRepository,
      );
    });

    const tCategoryId = 'cat-1';
    const tParams = DeleteCategoryParams(categoryId: tCategoryId);

    test('should return true on successful category deletion', () async {
      when(
        () => mockCategoryRepository.deleteCategory(tCategoryId),
      ).thenAnswer((_) async => const Right(true));

      final result = await usecase(tParams);

      expect(result, const Right(true));
      verify(
        () => mockCategoryRepository.deleteCategory(tCategoryId),
      ).called(1);
      verifyNoMoreInteractions(mockCategoryRepository);
    });

    test('should return Failure on unsuccessful category deletion', () async {
      const tFailure = ApiFailure(message: 'Failed to delete category');
      when(
        () => mockCategoryRepository.deleteCategory(tCategoryId),
      ).thenAnswer((_) async => const Left(tFailure));

      final result = await usecase(tParams);

      expect(result, const Left(tFailure));
      verify(
        () => mockCategoryRepository.deleteCategory(tCategoryId),
      ).called(1);
      verifyNoMoreInteractions(mockCategoryRepository);
    });
  });
}
