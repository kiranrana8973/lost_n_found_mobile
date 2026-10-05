import 'package:lost_n_found/features/category/data/models/category_model.dart';

abstract interface class ICategoryDataSource {
  Future<List<CategoryModel>> getAllCategories();
  Future<CategoryModel?> getCategoryById(String categoryId);
  Future<bool> createCategory(CategoryModel category);
  Future<bool> updateCategory(CategoryModel category);
  Future<bool> deleteCategory(String categoryId);
}
