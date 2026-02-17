import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lost_n_found/core/error/failures.dart';
import 'package:lost_n_found/features/category/domain/entities/category_entity.dart';
import 'package:lost_n_found/features/category/domain/repositories/category_repository.dart';
import 'package:lost_n_found/features/category/domain/usecases/create_category_usecase.dart';
import 'package:lost_n_found/features/category/domain/usecases/delete_category_usecase.dart';
import 'package:lost_n_found/features/category/domain/usecases/get_all_categories_usecase.dart';
import 'package:lost_n_found/features/category/domain/usecases/get_category_by_id_usecase.dart';
import 'package:lost_n_found/features/category/domain/usecases/update_category_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockCategoryRepository extends Mock implements ICategoryRepository {}

void main() {
  late MockCategoryRepository mockRepo;

  const tCategory = CategoryEntity(
    categoryId: 'cat-1',
    name: 'Electronics',
    description: 'Electronic devices',
  );

  final tCategories = [
    tCategory,
    const CategoryEntity(categoryId: 'cat-2', name: 'Personal'),
  ];

  setUp(() {
    mockRepo = MockCategoryRepository();
  });

  setUpAll(() {
    registerFallbackValue(tCategory);
  });

  group('GetAllCategoriesUsecase', () {
    late GetAllCategoriesUsecase usecase;

    setUp(() {
      usecase = GetAllCategoriesUsecase(categoryRepository: mockRepo);
    });

    test('should return list of categories from repository', () async {
      when(() => mockRepo.getAllCategories())
          .thenAnswer((_) async => Right(tCategories));

      final result = await usecase();

      expect(result, Right(tCategories));
      verify(() => mockRepo.getAllCategories()).called(1);
    });

    test('should return failure when repository fails', () async {
      when(() => mockRepo.getAllCategories())
          .thenAnswer((_) async => const Left(NetworkFailure()));

      final result = await usecase();

      expect(result, const Left(NetworkFailure()));
    });
  });

  group('GetCategoryByIdUsecase', () {
    late GetCategoryByIdUsecase usecase;

    setUp(() {
      usecase = GetCategoryByIdUsecase(categoryRepository: mockRepo);
    });

    test('should call repository with correct categoryId', () async {
      when(() => mockRepo.getCategoryById(any()))
          .thenAnswer((_) async => const Right(tCategory));

      final result = await usecase(
          const GetCategoryByIdParams(categoryId: 'cat-1'));

      expect(result, const Right(tCategory));
      verify(() => mockRepo.getCategoryById('cat-1')).called(1);
    });

    test('should return failure when not found', () async {
      when(() => mockRepo.getCategoryById(any()))
          .thenAnswer((_) async => const Left(ApiFailure(message: 'Not found')));

      final result = await usecase(
          const GetCategoryByIdParams(categoryId: 'invalid'));

      expect(result, const Left(ApiFailure(message: 'Not found')));
    });
  });

  group('CreateCategoryUsecase', () {
    late CreateCategoryUsecase usecase;

    setUp(() {
      usecase = CreateCategoryUsecase(categoryRepository: mockRepo);
    });

    const tParams = CreateCategoryParams(
      name: 'Electronics',
      description: 'Electronic devices',
    );

    test('should call repository.createCategory with CategoryEntity', () async {
      when(() => mockRepo.createCategory(any()))
          .thenAnswer((_) async => const Right(true));

      final result = await usecase(tParams);

      expect(result, const Right(true));
      verify(() => mockRepo.createCategory(any())).called(1);
    });

    test('should return failure on error', () async {
      when(() => mockRepo.createCategory(any()))
          .thenAnswer((_) async => const Left(ApiFailure(message: 'Create failed')));

      final result = await usecase(tParams);

      expect(result, const Left(ApiFailure(message: 'Create failed')));
    });
  });

  group('UpdateCategoryUsecase', () {
    late UpdateCategoryUsecase usecase;

    setUp(() {
      usecase = UpdateCategoryUsecase(categoryRepository: mockRepo);
    });

    const tParams = UpdateCategoryParams(
      categoryId: 'cat-1',
      name: 'Updated Electronics',
      description: 'Updated description',
    );

    test('should call repository.updateCategory with CategoryEntity', () async {
      when(() => mockRepo.updateCategory(any()))
          .thenAnswer((_) async => const Right(true));

      final result = await usecase(tParams);

      expect(result, const Right(true));
      verify(() => mockRepo.updateCategory(any())).called(1);
    });

    test('should return failure on error', () async {
      when(() => mockRepo.updateCategory(any()))
          .thenAnswer((_) async => const Left(ApiFailure(message: 'Update failed')));

      final result = await usecase(tParams);

      expect(result, const Left(ApiFailure(message: 'Update failed')));
    });
  });

  group('DeleteCategoryUsecase', () {
    late DeleteCategoryUsecase usecase;

    setUp(() {
      usecase = DeleteCategoryUsecase(categoryRepository: mockRepo);
    });

    test('should call repository.deleteCategory with correct id', () async {
      when(() => mockRepo.deleteCategory(any()))
          .thenAnswer((_) async => const Right(true));

      final result = await usecase(
          const DeleteCategoryParams(categoryId: 'cat-1'));

      expect(result, const Right(true));
      verify(() => mockRepo.deleteCategory('cat-1')).called(1);
    });

    test('should return failure on error', () async {
      when(() => mockRepo.deleteCategory(any()))
          .thenAnswer((_) async => const Left(ApiFailure(message: 'Delete failed')));

      final result = await usecase(
          const DeleteCategoryParams(categoryId: 'cat-1'));

      expect(result, const Left(ApiFailure(message: 'Delete failed')));
    });
  });
}
