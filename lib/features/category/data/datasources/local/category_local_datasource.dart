import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lost_n_found/core/services/database/app_database.dart';
import 'package:lost_n_found/features/category/data/datasources/category_datasource.dart';

final categoryLocalDatasourceProvider =
    Provider<CategoryLocalDatasource>((ref) {
  final appDatabase = ref.read(appDatabaseProvider);
  return CategoryLocalDatasource(appDatabase: appDatabase);
});

class CategoryLocalDatasource implements ICategoryDataSource {
  final AppDatabase _db;

  CategoryLocalDatasource({required AppDatabase appDatabase})
      : _db = appDatabase;

  @override
  Future<bool> createCategory(CategoryModel category) async {
    try {
      await _db.createCategory(category);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> deleteCategory(String categoryId) async {
    try {
      await _db.deleteCategory(categoryId);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<CategoryModel>> getAllCategories() async {
    try {
      return await _db.getAllCategories();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<CategoryModel?> getCategoryById(String categoryId) async {
    try {
      return await _db.getCategoryById(categoryId);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> updateCategory(CategoryModel category) async {
    try {
      await _db.updateCategory(category);
      return true;
    } catch (e) {
      return false;
    }
  }
}
