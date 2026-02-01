import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lost_n_found/core/error/failures.dart';
import 'package:lost_n_found/core/services/connectivity/network_info.dart';
import 'package:lost_n_found/features/category/data/datasources/category_datasource.dart';
import 'package:lost_n_found/features/category/data/datasources/local/category_local_datasource.dart';
import 'package:lost_n_found/features/category/data/models/category_api_model.dart';
import 'package:lost_n_found/features/category/data/models/category_hive_model.dart';
import 'package:lost_n_found/features/category/data/repositories/category_repository.dart';
import 'package:lost_n_found/features/category/domain/entities/category_entity.dart';
import 'package:mocktail/mocktail.dart';

class MockCategoryLocalDatasource extends Mock
    implements CategoryLocalDatasource {}

class MockCategoryRemoteDatasource extends Mock
    implements ICategoryRemoteDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late CategoryRepository repository;
  late MockCategoryLocalDatasource mockLocalDatasource;
  late MockCategoryRemoteDatasource mockRemoteDatasource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockLocalDatasource = MockCategoryLocalDatasource();
    mockRemoteDatasource = MockCategoryRemoteDatasource();
    mockNetworkInfo = MockNetworkInfo();
    repository = CategoryRepository(
      categoryLocalDatasource: mockLocalDatasource,
      categoryRemoteDatasource: mockRemoteDatasource,
      networkInfo: mockNetworkInfo,
    );
  });

  setUpAll(() {
    registerFallbackValue(
      CategoryHiveModel(name: 'Test Category'),
    );
    registerFallbackValue(<CategoryHiveModel>[]);
  });

  const tCategoryEntity = CategoryEntity(
    categoryId: '1',
    name: 'Electronics',
    description: 'Electronic items',
    status: 'active',
  );

  final tCategoryHiveModel = CategoryHiveModel(
    categoryId: '1',
    name: 'Electronics',
    description: 'Electronic items',
    status: 'active',
  );

  final tCategoryApiModelList = [
    CategoryApiModel(
      id: '1',
      name: 'Electronics',
      description: 'Electronic items',
      status: 'active',
    ),
    CategoryApiModel(
      id: '2',
      name: 'Books',
      description: 'Book items',
      status: 'active',
    ),
  ];

  final tCategoryHiveModelList = [
    CategoryHiveModel(
      categoryId: '1',
      name: 'Electronics',
      description: 'Electronic items',
      status: 'active',
    ),
    CategoryHiveModel(
      categoryId: '2',
      name: 'Books',
      description: 'Book items',
      status: 'active',
    ),
  ];

  group('createCategory', () {
    test('should return Right(true) when local create succeeds', () async {
      // Arrange
      when(() => mockLocalDatasource.createCategory(any()))
          .thenAnswer((_) async => true);

      // Act
      final result = await repository.createCategory(tCategoryEntity);

      // Assert
      expect(result, const Right(true));
      verify(() => mockLocalDatasource.createCategory(any())).called(1);
    });

    test('should return Left(LocalDatabaseFailure) when local create fails',
        () async {
      // Arrange
      when(() => mockLocalDatasource.createCategory(any()))
          .thenAnswer((_) async => false);

      // Act
      final result = await repository.createCategory(tCategoryEntity);

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<LocalDatabaseFailure>());
          expect((failure as LocalDatabaseFailure).message,
              'Failed to create category');
        },
        (_) => fail('Should return failure'),
      );
    });

    test('should return Left(LocalDatabaseFailure) when exception occurs',
        () async {
      // Arrange
      when(() => mockLocalDatasource.createCategory(any()))
          .thenThrow(Exception('Database error'));

      // Act
      final result = await repository.createCategory(tCategoryEntity);

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<LocalDatabaseFailure>()),
        (_) => fail('Should return failure'),
      );
    });
  });

  group('deleteCategory', () {
    test('should return Right(true) when delete succeeds', () async {
      // Arrange
      when(() => mockLocalDatasource.deleteCategory('1'))
          .thenAnswer((_) async => true);

      // Act
      final result = await repository.deleteCategory('1');

      // Assert
      expect(result, const Right(true));
      verify(() => mockLocalDatasource.deleteCategory('1')).called(1);
    });

    test('should return Left(LocalDatabaseFailure) when delete fails',
        () async {
      // Arrange
      when(() => mockLocalDatasource.deleteCategory('1'))
          .thenAnswer((_) async => false);

      // Act
      final result = await repository.deleteCategory('1');

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<LocalDatabaseFailure>());
          expect((failure as LocalDatabaseFailure).message,
              'Failed to delete category');
        },
        (_) => fail('Should return failure'),
      );
    });

    test('should return Left(LocalDatabaseFailure) when exception occurs',
        () async {
      // Arrange
      when(() => mockLocalDatasource.deleteCategory('1'))
          .thenThrow(Exception('Database error'));

      // Act
      final result = await repository.deleteCategory('1');

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<LocalDatabaseFailure>()),
        (_) => fail('Should return failure'),
      );
    });
  });

  group('getAllCategories', () {
    test(
        'should return remote data and cache it locally when online and remote call succeeds',
        () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDatasource.getAllCategories())
          .thenAnswer((_) async => tCategoryApiModelList);
      when(() => mockLocalDatasource.cacheAllCategories(any()))
          .thenAnswer((_) async {});

      // Act
      final result = await repository.getAllCategories();

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Should return data'),
        (categories) {
          expect(categories.length, 2);
          expect(categories[0].name, 'Electronics');
        },
      );
      verify(() => mockRemoteDatasource.getAllCategories()).called(1);
      verify(() => mockLocalDatasource.cacheAllCategories(any())).called(1);
    });

    test('should return cached data when online but exception occurs',
        () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDatasource.getAllCategories())
          .thenThrow(Exception('API Error'));
      when(() => mockLocalDatasource.getAllCategories())
          .thenAnswer((_) async => tCategoryHiveModelList);

      // Act
      final result = await repository.getAllCategories();

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Should return cached data'),
        (categories) => expect(categories.length, 2),
      );
    });

    test('should return cached data when offline', () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(() => mockLocalDatasource.getAllCategories())
          .thenAnswer((_) async => tCategoryHiveModelList);

      // Act
      final result = await repository.getAllCategories();

      // Assert
      expect(result.isRight(), true);
      verifyNever(() => mockRemoteDatasource.getAllCategories());
      verify(() => mockLocalDatasource.getAllCategories()).called(1);
    });

    test(
        'should return Left(LocalDatabaseFailure) when offline and local call fails',
        () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(() => mockLocalDatasource.getAllCategories())
          .thenThrow(Exception('Database Error'));

      // Act
      final result = await repository.getAllCategories();

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<LocalDatabaseFailure>()),
        (_) => fail('Should return failure'),
      );
    });
  });

  group('getCategoryById', () {
    test('should return category when it exists', () async {
      // Arrange
      when(() => mockLocalDatasource.getCategoryById('1'))
          .thenAnswer((_) async => tCategoryHiveModel);

      // Act
      final result = await repository.getCategoryById('1');

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Should return category'),
        (category) => expect(category.name, 'Electronics'),
      );
    });

    test('should return Left(LocalDatabaseFailure) when category not found',
        () async {
      // Arrange
      when(() => mockLocalDatasource.getCategoryById('1'))
          .thenAnswer((_) async => null);

      // Act
      final result = await repository.getCategoryById('1');

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<LocalDatabaseFailure>());
          expect(
              (failure as LocalDatabaseFailure).message, 'Category not found');
        },
        (_) => fail('Should return failure'),
      );
    });

    test('should return Left(LocalDatabaseFailure) when exception occurs',
        () async {
      // Arrange
      when(() => mockLocalDatasource.getCategoryById('1'))
          .thenThrow(Exception('Database error'));

      // Act
      final result = await repository.getCategoryById('1');

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<LocalDatabaseFailure>()),
        (_) => fail('Should return failure'),
      );
    });
  });

  group('updateCategory', () {
    test('should return Right(true) when update succeeds', () async {
      // Arrange
      when(() => mockLocalDatasource.updateCategory(any()))
          .thenAnswer((_) async => true);

      // Act
      final result = await repository.updateCategory(tCategoryEntity);

      // Assert
      expect(result, const Right(true));
      verify(() => mockLocalDatasource.updateCategory(any())).called(1);
    });

    test('should return Left(LocalDatabaseFailure) when update fails',
        () async {
      // Arrange
      when(() => mockLocalDatasource.updateCategory(any()))
          .thenAnswer((_) async => false);

      // Act
      final result = await repository.updateCategory(tCategoryEntity);

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<LocalDatabaseFailure>());
          expect((failure as LocalDatabaseFailure).message,
              'Failed to update category');
        },
        (_) => fail('Should return failure'),
      );
    });

    test('should return Left(LocalDatabaseFailure) when exception occurs',
        () async {
      // Arrange
      when(() => mockLocalDatasource.updateCategory(any()))
          .thenThrow(Exception('Database error'));

      // Act
      final result = await repository.updateCategory(tCategoryEntity);

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<LocalDatabaseFailure>()),
        (_) => fail('Should return failure'),
      );
    });
  });
}
