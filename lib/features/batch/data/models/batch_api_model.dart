import 'package:json_annotation/json_annotation.dart';
import 'package:lost_n_found/features/batch/domain/entities/batch_entity.dart';

part 'batch_api_model.g.dart';

@JsonSerializable()
class BatchApiModel {
  @JsonKey(name: '_id')
  final String? id;
  final String batchName;
  final String? status;

  BatchApiModel({this.id, required this.batchName, this.status});

  Map<String, dynamic> toJson() => _$BatchApiModelToJson(this);

  factory BatchApiModel.fromJson(Map<String, dynamic> json) =>
      _$BatchApiModelFromJson(json);

  // toEntity
  BatchEntity toEntity() {
    return BatchEntity(batchId: id, batchName: batchName, status: status);
  }

  // fromEntity

  factory BatchApiModel.fromEntity(BatchEntity entity) {
    return BatchApiModel(batchName: entity.batchName);
  }

  // toEntityList
  static List<BatchEntity> toEntityList(List<BatchApiModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }

  // fromEntityList
}
