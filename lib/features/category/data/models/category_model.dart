import 'package:lost_n_found/core/services/database/app_database.dart';
import 'package:lost_n_found/features/category/domain/entities/category_entity.dart';
import 'package:uuid/uuid.dart';

// The row class itself is generated into app_database.dart; re-export it so
// importing this file gives you both the model and its mappers.
export 'package:lost_n_found/core/services/database/app_database.dart'
    show CategoryModel;

// CategoryModel is the drift row class generated from CategoryTable.
// These extensions map it to and from the domain entity.

extension CategoryModelX on CategoryModel {
  CategoryEntity toEntity() {
    return CategoryEntity(
      categoryId: categoryId,
      name: name,
      description: description,
      status: status,
    );
  }
}

extension CategoryEntityX on CategoryEntity {
  CategoryModel toModel() {
    return CategoryModel(
      categoryId: categoryId ?? const Uuid().v4(),
      name: name,
      description: description,
      status: status ?? 'active',
    );
  }
}

extension CategoryModelListX on List<CategoryModel> {
  List<CategoryEntity> toEntityList() =>
      map((model) => model.toEntity()).toList();
}
