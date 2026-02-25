import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lost_n_found/core/error/failures.dart';
import 'package:lost_n_found/features/category/data/datasources/local/category_local_datasource.dart';
import 'package:lost_n_found/features/category/data/models/category_api_model.dart';
import 'package:lost_n_found/features/category/data/models/category_hive_model.dart';
import 'package:lost_n_found/features/category/data/repositories/category_repository.dart';
import 'package:lost_n_found/features/category/domain/entities/category_entity.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/test_mocks.dart';

class MockCategoryLocalDatasource extends Mock
    implements CategoryLocalDatasource {}

class FakeCategoryHiveModel extends Fake implements CategoryHiveModel {}

void main() {
  late CategoryRepository repository;
  late MockCategoryLocalDatasource mockLocalDataSource;
  late MockCategoryRemoteDataSource mockRemoteDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUpAll(() {
    registerFallbackValue(FakeCategoryHiveModel());
  });

  setUp(() {
    mockLocalDataSource = MockCategoryLocalDatasource();
    mockRemoteDataSource = MockCategoryRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = CategoryRepository(
      categoryLocalDatasource: mockLocalDataSource,
      categoryRemoteDatasource: mockRemoteDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  const tCategoryEntity = CategoryEntity(
    categoryId: '1',
    name: 'Electronics',
    description: 'Electronic items',
    status: 'active',
  );

  final tCategoryApiModel = CategoryApiModel(
    id: '1',
    name: 'Electronics',
    description: 'Electronic items',
    status: 'active',
  );

  final tCategoryApiModels = [tCategoryApiModel];

  final tCategoryHiveModel = CategoryHiveModel(
    categoryId: '1',
    name: 'Electronics',
    description: 'Electronic items',
    status: 'active',
  );

  final tCategoryHiveModels = [tCategoryHiveModel];

  group('getAllCategories', () {
    test(
      'should return Right(List<CategoryEntity>) and cache when online',
      () async {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(
          () => mockRemoteDataSource.getAllCategories(),
        ).thenAnswer((_) async => tCategoryApiModels);
        when(
          () => mockLocalDataSource.cacheAllCategories(any()),
        ).thenAnswer((_) async {});

        final result = await repository.getAllCategories();

        expect(result.isRight(), true);
        result.fold((_) => fail('Should be Right'), (categories) {
          expect(categories, isA<List<CategoryEntity>>());
          expect(categories.length, 1);
          expect(categories[0].name, 'Electronics');
        });
        verify(() => mockLocalDataSource.cacheAllCategories(any())).called(1);
      },
    );

    test('should return cached categories when offline', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(
        () => mockLocalDataSource.getAllCategories(),
      ).thenAnswer((_) async => tCategoryHiveModels);

      final result = await repository.getAllCategories();

      expect(result.isRight(), true);
      result.fold((_) => fail('Should be Right'), (categories) {
        expect(categories, isA<List<CategoryEntity>>());
        expect(categories.length, 1);
      });
      verify(() => mockLocalDataSource.getAllCategories()).called(1);
      verifyNever(() => mockRemoteDataSource.getAllCategories());
    });
  });

  group('createCategory', () {
    test('should return Right(true) when local creation succeeds', () async {
      when(
        () => mockLocalDataSource.createCategory(any()),
      ).thenAnswer((_) async => true);

      final result = await repository.createCategory(tCategoryEntity);

      expect(result, const Right(true));
      verify(() => mockLocalDataSource.createCategory(any())).called(1);
    });

    test(
      'should return Left(LocalDatabaseFailure) when local creation fails',
      () async {
        when(
          () => mockLocalDataSource.createCategory(any()),
        ).thenAnswer((_) async => false);

        final result = await repository.createCategory(tCategoryEntity);

        expect(result.isLeft(), true);
        result.fold((failure) {
          expect(failure, isA<LocalDatabaseFailure>());
          expect(failure.message, 'Failed to create category');
        }, (_) => fail('Should be Left'));
      },
    );
  });

  group('deleteCategory', () {
    const tCategoryId = '1';

    test('should return Right(true) when local deletion succeeds', () async {
      when(
        () => mockLocalDataSource.deleteCategory(any()),
      ).thenAnswer((_) async => true);

      final result = await repository.deleteCategory(tCategoryId);

      expect(result, const Right(true));
      verify(() => mockLocalDataSource.deleteCategory(tCategoryId)).called(1);
    });

    test(
      'should return Left(LocalDatabaseFailure) when local deletion fails',
      () async {
        when(
          () => mockLocalDataSource.deleteCategory(any()),
        ).thenAnswer((_) async => false);

        final result = await repository.deleteCategory(tCategoryId);

        expect(result.isLeft(), true);
        result.fold((failure) {
          expect(failure, isA<LocalDatabaseFailure>());
          expect(failure.message, 'Failed to delete category');
        }, (_) => fail('Should be Left'));
      },
    );
  });
}
