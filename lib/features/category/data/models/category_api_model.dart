import 'package:json_annotation/json_annotation.dart';
import 'package:lost_n_found/features/category/domain/entities/category_entity.dart';

part 'category_api_model.g.dart';

@JsonSerializable()
class CategoryApiModel {
  @JsonKey(name: '_id')
  final String? id;
  final String name;
  final String? description;
  final String? status;

  CategoryApiModel({
    this.id,
    required this.name,
    this.description,
    this.status,
  });

  Map<String, dynamic> toJson() => _$CategoryApiModelToJson(this);

  factory CategoryApiModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryApiModelFromJson(json);

  CategoryEntity toEntity() {
    return CategoryEntity(
      categoryId: id,
      name: name,
      description: description,
      status: status,
    );
  }

  factory CategoryApiModel.fromEntity(CategoryEntity entity) {
    return CategoryApiModel(
      id: entity.categoryId,
      name: entity.name,
      description: entity.description,
      status: entity.status,
    );
  }

  static List<CategoryEntity> toEntityList(List<CategoryApiModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
