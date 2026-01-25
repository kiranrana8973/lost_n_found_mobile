import 'package:json_annotation/json_annotation.dart';
import 'package:lost_n_found/features/item/domain/entities/item_entity.dart';

part 'item_api_model.g.dart';

/// Helper to extract ID from nested object or string
String? _extractId(dynamic value) {
  if (value == null) return null;
  if (value is Map) return value['_id'] as String?;
  return value as String?;
}

@JsonSerializable()
class ItemApiModel {
  @JsonKey(name: '_id')
  final String? id;
  @JsonKey(fromJson: _extractId)
  final String? reportedBy;
  @JsonKey(fromJson: _extractId)
  final String? claimedBy;
  @JsonKey(fromJson: _extractId)
  final String? category;
  final String itemName;
  final String? description;
  final String type;
  final String location;
  final String? media;
  final String? mediaType;
  @JsonKey(defaultValue: false)
  final bool isClaimed;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ItemApiModel({
    this.id,
    this.reportedBy,
    this.claimedBy,
    this.category,
    required this.itemName,
    this.description,
    required this.type,
    required this.location,
    this.media,
    this.mediaType,
    this.isClaimed = false,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toJson() => _$ItemApiModelToJson(this);

  factory ItemApiModel.fromJson(Map<String, dynamic> json) =>
      _$ItemApiModelFromJson(json);

  ItemEntity toEntity() {
    return ItemEntity(
      itemId: id,
      reportedBy: reportedBy,
      claimedBy: claimedBy,
      category: category,
      itemName: itemName,
      description: description,
      type: type == 'lost' ? ItemType.lost : ItemType.found,
      location: location,
      media: media,
      mediaType: mediaType,
      isClaimed: isClaimed,
      status: status,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  factory ItemApiModel.fromEntity(ItemEntity entity) {
    return ItemApiModel(
      id: entity.itemId,
      reportedBy: entity.reportedBy,
      claimedBy: entity.claimedBy,
      category: entity.category,
      itemName: entity.itemName,
      description: entity.description,
      type: entity.type == ItemType.lost ? 'lost' : 'found',
      location: entity.location,
      media: entity.media,
      mediaType: entity.mediaType,
      isClaimed: entity.isClaimed,
      status: entity.status,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  static List<ItemEntity> toEntityList(List<ItemApiModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
