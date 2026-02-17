import 'package:equatable/equatable.dart';
import 'package:lost_n_found/features/category/domain/entities/category_entity.dart';

enum CategoryStatus { initial, loading, loaded, error, created, updated, deleted }

class CategoryState extends Equatable {
  final CategoryStatus status;
  final List<CategoryEntity> categories;
  final CategoryEntity? selectedCategory;
  final String? errorMessage;

  const CategoryState({
    this.status = CategoryStatus.initial,
    this.categories = const [],
    this.selectedCategory,
    this.errorMessage,
  });

  CategoryState copyWith({
    CategoryStatus? status,
    List<CategoryEntity>? categories,
    CategoryEntity? selectedCategory,
    bool clearSelectedCategory = false,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return CategoryState(
      status: status ?? this.status,
      categories: categories ?? this.categories,
      selectedCategory: clearSelectedCategory
          ? null
          : (selectedCategory ?? this.selectedCategory),
      errorMessage: clearErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [status, categories, selectedCategory, errorMessage];
}
