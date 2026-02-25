import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lost_n_found/core/constants/hive_table_constant.dart';
import 'package:lost_n_found/core/services/hive/hive_box.dart';
import 'package:lost_n_found/features/category/data/datasources/category_datasource.dart';
import 'package:lost_n_found/features/category/data/models/category_hive_model.dart';

final categoryLocalDatasourceProvider = Provider<CategoryLocalDatasource>((
  ref,
) {
  return CategoryLocalDatasource();
});

class CategoryLocalDatasource implements ICategoryDataSource {
  final HiveBox<CategoryHiveModel> _box;

  CategoryLocalDatasource()
    : _box = HiveBox<CategoryHiveModel>(HiveTableConstant.categoryTable);

  @override
  Future<bool> createCategory(CategoryHiveModel category) async {
    try {
      await _box.put(category.categoryId!, category);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> deleteCategory(String categoryId) async {
    try {
      await _box.delete(categoryId);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<CategoryHiveModel>> getAllCategories() async {
    try {
      return _box.getAll();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<CategoryHiveModel?> getCategoryById(String categoryId) async {
    try {
      return _box.get(categoryId);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> updateCategory(CategoryHiveModel category) async {
    try {
      return await _box.update(category.categoryId!, category);
    } catch (e) {
      return false;
    }
  }

  Future<void> cacheAllCategories(List<CategoryHiveModel> categories) async {
    await _box.replaceAll({for (final c in categories) c.categoryId!: c});
  }
}
