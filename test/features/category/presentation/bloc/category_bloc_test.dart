import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lost_n_found/core/error/failures.dart';
import 'package:lost_n_found/features/category/domain/entities/category_entity.dart';
import 'package:lost_n_found/features/category/domain/usecases/create_category_usecase.dart';
import 'package:lost_n_found/features/category/domain/usecases/delete_category_usecase.dart';
import 'package:lost_n_found/features/category/domain/usecases/get_all_categories_usecase.dart';
import 'package:lost_n_found/features/category/domain/usecases/get_category_by_id_usecase.dart';
import 'package:lost_n_found/features/category/domain/usecases/update_category_usecase.dart';
import 'package:lost_n_found/features/category/presentation/bloc/category_bloc.dart';
import 'package:lost_n_found/features/category/presentation/bloc/category_event.dart';
import 'package:lost_n_found/features/category/presentation/state/category_state.dart';
import 'package:mocktail/mocktail.dart';

// Mocks
class MockGetAllCategoriesUsecase extends Mock
    implements GetAllCategoriesUsecase {}

class MockGetCategoryByIdUsecase extends Mock
    implements GetCategoryByIdUsecase {}

class MockCreateCategoryUsecase extends Mock
    implements CreateCategoryUsecase {}

class MockUpdateCategoryUsecase extends Mock
    implements UpdateCategoryUsecase {}

class MockDeleteCategoryUsecase extends Mock
    implements DeleteCategoryUsecase {}

void main() {
  late CategoryBloc categoryBloc;
  late MockGetAllCategoriesUsecase mockGetAllCategoriesUsecase;
  late MockGetCategoryByIdUsecase mockGetCategoryByIdUsecase;
  late MockCreateCategoryUsecase mockCreateCategoryUsecase;
  late MockUpdateCategoryUsecase mockUpdateCategoryUsecase;
  late MockDeleteCategoryUsecase mockDeleteCategoryUsecase;

  const tCategory = CategoryEntity(
    categoryId: 'cat-1',
    name: 'Electronics',
    description: 'Electronic devices',
  );

  const tCategory2 = CategoryEntity(
    categoryId: 'cat-2',
    name: 'Personal',
    description: 'Personal items',
  );

  final tCategories = [tCategory, tCategory2];

  setUpAll(() {
    registerFallbackValue(const GetCategoryByIdParams(categoryId: ''));
    registerFallbackValue(const CreateCategoryParams(name: ''));
    registerFallbackValue(
        const UpdateCategoryParams(categoryId: '', name: ''));
    registerFallbackValue(const DeleteCategoryParams(categoryId: ''));
  });

  setUp(() {
    mockGetAllCategoriesUsecase = MockGetAllCategoriesUsecase();
    mockGetCategoryByIdUsecase = MockGetCategoryByIdUsecase();
    mockCreateCategoryUsecase = MockCreateCategoryUsecase();
    mockUpdateCategoryUsecase = MockUpdateCategoryUsecase();
    mockDeleteCategoryUsecase = MockDeleteCategoryUsecase();

    categoryBloc = CategoryBloc(
      getAllCategoriesUsecase: mockGetAllCategoriesUsecase,
      getCategoryByIdUsecase: mockGetCategoryByIdUsecase,
      createCategoryUsecase: mockCreateCategoryUsecase,
      updateCategoryUsecase: mockUpdateCategoryUsecase,
      deleteCategoryUsecase: mockDeleteCategoryUsecase,
    );
  });

  tearDown(() {
    categoryBloc.close();
  });

  test('initial state is CategoryState with initial status', () {
    expect(categoryBloc.state, const CategoryState());
    expect(categoryBloc.state.status, CategoryStatus.initial);
  });

  group('CategoryGetAllEvent', () {
    blocTest<CategoryBloc, CategoryState>(
      'emits [loading, loaded] with categories when succeeds',
      build: () {
        when(() => mockGetAllCategoriesUsecase())
            .thenAnswer((_) async => Right(tCategories));
        return categoryBloc;
      },
      act: (bloc) => bloc.add(const CategoryGetAllEvent()),
      expect: () => [
        const CategoryState(status: CategoryStatus.loading),
        CategoryState(
          status: CategoryStatus.loaded,
          categories: tCategories,
        ),
      ],
    );

    blocTest<CategoryBloc, CategoryState>(
      'emits [loading, error] when fails',
      build: () {
        when(() => mockGetAllCategoriesUsecase()).thenAnswer(
            (_) async => const Left(ApiFailure(message: 'Server error')));
        return categoryBloc;
      },
      act: (bloc) => bloc.add(const CategoryGetAllEvent()),
      expect: () => [
        const CategoryState(status: CategoryStatus.loading),
        const CategoryState(
          status: CategoryStatus.error,
          errorMessage: 'Server error',
        ),
      ],
    );
  });

  group('CategoryGetByIdEvent', () {
    blocTest<CategoryBloc, CategoryState>(
      'emits [loading, loaded] with selected category when succeeds',
      build: () {
        when(() => mockGetCategoryByIdUsecase(any()))
            .thenAnswer((_) async => const Right(tCategory));
        return categoryBloc;
      },
      act: (bloc) =>
          bloc.add(const CategoryGetByIdEvent(categoryId: 'cat-1')),
      expect: () => [
        const CategoryState(status: CategoryStatus.loading),
        const CategoryState(
          status: CategoryStatus.loaded,
          selectedCategory: tCategory,
        ),
      ],
    );

    blocTest<CategoryBloc, CategoryState>(
      'emits [loading, error] when fails',
      build: () {
        when(() => mockGetCategoryByIdUsecase(any())).thenAnswer((_) async =>
            const Left(ApiFailure(message: 'Category not found')));
        return categoryBloc;
      },
      act: (bloc) =>
          bloc.add(const CategoryGetByIdEvent(categoryId: 'cat-1')),
      expect: () => [
        const CategoryState(status: CategoryStatus.loading),
        const CategoryState(
          status: CategoryStatus.error,
          errorMessage: 'Category not found',
        ),
      ],
    );
  });

  group('CategoryCreateEvent', () {
    blocTest<CategoryBloc, CategoryState>(
      'emits [loading, created] and triggers GetAll when succeeds',
      build: () {
        when(() => mockCreateCategoryUsecase(any()))
            .thenAnswer((_) async => const Right(true));
        when(() => mockGetAllCategoriesUsecase())
            .thenAnswer((_) async => Right(tCategories));
        return categoryBloc;
      },
      act: (bloc) => bloc.add(const CategoryCreateEvent(
        name: 'Electronics',
        description: 'Electronic devices',
      )),
      expect: () => [
        const CategoryState(status: CategoryStatus.loading),
        const CategoryState(status: CategoryStatus.created),
        const CategoryState(status: CategoryStatus.loading),
        CategoryState(
          status: CategoryStatus.loaded,
          categories: tCategories,
        ),
      ],
      verify: (_) {
        verify(() => mockCreateCategoryUsecase(any())).called(1);
        verify(() => mockGetAllCategoriesUsecase()).called(1);
      },
    );

    blocTest<CategoryBloc, CategoryState>(
      'emits [loading, error] when create fails',
      build: () {
        when(() => mockCreateCategoryUsecase(any())).thenAnswer(
            (_) async => const Left(ApiFailure(message: 'Create failed')));
        return categoryBloc;
      },
      act: (bloc) =>
          bloc.add(const CategoryCreateEvent(name: 'Electronics')),
      expect: () => [
        const CategoryState(status: CategoryStatus.loading),
        const CategoryState(
          status: CategoryStatus.error,
          errorMessage: 'Create failed',
        ),
      ],
    );
  });

  group('CategoryUpdateEvent', () {
    blocTest<CategoryBloc, CategoryState>(
      'emits [loading, updated] and triggers GetAll when succeeds',
      build: () {
        when(() => mockUpdateCategoryUsecase(any()))
            .thenAnswer((_) async => const Right(true));
        when(() => mockGetAllCategoriesUsecase())
            .thenAnswer((_) async => Right(tCategories));
        return categoryBloc;
      },
      act: (bloc) => bloc.add(const CategoryUpdateEvent(
        categoryId: 'cat-1',
        name: 'Updated Electronics',
      )),
      expect: () => [
        const CategoryState(status: CategoryStatus.loading),
        const CategoryState(status: CategoryStatus.updated),
        const CategoryState(status: CategoryStatus.loading),
        CategoryState(
          status: CategoryStatus.loaded,
          categories: tCategories,
        ),
      ],
    );
  });

  group('CategoryDeleteEvent', () {
    blocTest<CategoryBloc, CategoryState>(
      'emits [loading, deleted] and triggers GetAll when succeeds',
      build: () {
        when(() => mockDeleteCategoryUsecase(any()))
            .thenAnswer((_) async => const Right(true));
        when(() => mockGetAllCategoriesUsecase())
            .thenAnswer((_) async => const Right([]));
        return categoryBloc;
      },
      act: (bloc) =>
          bloc.add(const CategoryDeleteEvent(categoryId: 'cat-1')),
      expect: () => [
        const CategoryState(status: CategoryStatus.loading),
        const CategoryState(status: CategoryStatus.deleted),
        const CategoryState(status: CategoryStatus.loading),
        const CategoryState(status: CategoryStatus.loaded),
      ],
      verify: (_) {
        verify(() => mockDeleteCategoryUsecase(any())).called(1);
        verify(() => mockGetAllCategoriesUsecase()).called(1);
      },
    );
  });

  group('CategoryClearErrorEvent', () {
    blocTest<CategoryBloc, CategoryState>(
      'clears error message from state',
      build: () => categoryBloc,
      seed: () => const CategoryState(
        status: CategoryStatus.error,
        errorMessage: 'Some error',
      ),
      act: (bloc) => bloc.add(const CategoryClearErrorEvent()),
      expect: () => [
        const CategoryState(status: CategoryStatus.error),
      ],
    );
  });
}
