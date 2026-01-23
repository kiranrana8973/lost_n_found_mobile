import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lost_n_found/core/error/failures.dart';
import 'package:lost_n_found/core/services/connectivity/network_info.dart';
import 'package:lost_n_found/features/category/data/datasources/category_datasource.dart';
import 'package:lost_n_found/features/category/data/datasources/local/category_local_datasource.dart';
import 'package:lost_n_found/features/category/data/datasources/remote/category_remote_datasource.dart';
import 'package:lost_n_found/features/category/data/models/category_api_model.dart';
import 'package:lost_n_found/features/category/data/models/category_hive_model.dart';
import 'package:lost_n_found/features/category/domain/entities/category_entity.dart';
import 'package:lost_n_found/features/category/domain/repositories/category_repository.dart';

final categoryRepositoryProvider = Provider<ICategoryRepository>((ref) {
  final categoryLocalDatasource = ref.read(categoryLocalDatasourceProvider);
  final categoryRemoteDatasource = ref.read(categoryRemoteDatasourceProvider);
  final networkInfo = ref.read(networkInfoProvider);
  return CategoryRepository(
    categoryLocalDatasource: categoryLocalDatasource,
    categoryRemoteDatasource: categoryRemoteDatasource,
    networkInfo: networkInfo,
  );
});

class CategoryRepository implements ICategoryRepository {
  final CategoryLocalDatasource _categoryLocalDataSource;
  final ICategoryRemoteDataSource _categoryRemoteDataSource;
  final NetworkInfo _networkInfo;

  CategoryRepository({
    required CategoryLocalDatasource categoryLocalDatasource,
    required ICategoryRemoteDataSource categoryRemoteDatasource,
    required NetworkInfo networkInfo,
  })  : _categoryLocalDataSource = categoryLocalDatasource,
        _categoryRemoteDataSource = categoryRemoteDatasource,
        _networkInfo = networkInfo;

  @override
  Future<Either<Failure, bool>> createCategory(CategoryEntity category) async {
    try {
      final categoryModel = CategoryHiveModel.fromEntity(category);
      final result =
          await _categoryLocalDataSource.createCategory(categoryModel);
      if (result) {
        return const Right(true);
      }
      return const Left(
        LocalDatabaseFailure(message: "Failed to create category"),
      );
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteCategory(String categoryId) async {
    try {
      final result =
          await _categoryLocalDataSource.deleteCategory(categoryId);
      if (result) {
        return const Right(true);
      }
      return const Left(
        LocalDatabaseFailure(message: "Failed to delete category"),
      );
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<CategoryEntity>>> getAllCategories() async {
    if (await _networkInfo.isConnected) {
      try {
        final models = await _categoryRemoteDataSource.getAllCategories();
        // Cache the data locally for offline access
        final hiveModels = CategoryHiveModel.fromApiModelList(models);
        await _categoryLocalDataSource.cacheAllCategories(hiveModels);
        final entities = CategoryApiModel.toEntityList(models);
        return Right(entities);
      } catch (e) {
        // API failed, try to return cached data
        return _getCachedCategories();
      }
    } else {
      return _getCachedCategories();
    }
  }

  /// Helper method to get cached categories
  Future<Either<Failure, List<CategoryEntity>>> _getCachedCategories() async {
    try {
      final models = await _categoryLocalDataSource.getAllCategories();
      final entities = CategoryHiveModel.toEntityList(models);
      return Right(entities);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, CategoryEntity>> getCategoryById(
      String categoryId) async {
    try {
      final model =
          await _categoryLocalDataSource.getCategoryById(categoryId);
      if (model != null) {
        final entity = model.toEntity();
        return Right(entity);
      }
      return const Left(LocalDatabaseFailure(message: 'Category not found'));
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> updateCategory(CategoryEntity category) async {
    try {
      final categoryModel = CategoryHiveModel.fromEntity(category);
      final result =
          await _categoryLocalDataSource.updateCategory(categoryModel);
      if (result) {
        return const Right(true);
      }
      return const Left(
        LocalDatabaseFailure(message: "Failed to update category"),
      );
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }
}
