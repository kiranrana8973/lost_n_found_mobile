import 'package:lost_n_found/features/item/domain/entities/item_entity.dart';

class ItemApiModel {
  final String? id;
  final String? reportedBy;
  final String? claimedBy;
  final String? category;
  final String itemName;
  final String? description;
  final String type;
  final String location;
  final String? media;
  final String? mediaType;
  final bool isClaimed;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  // Constructor
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

  Map<String, dynamic> toJson() {
    return {
      'itemName': itemName,
      'type': type,
      'location': location,
      if (reportedBy != null) 'reportedBy': reportedBy,
      if (category != null) 'category': category,
      if (description != null) 'description': description,
      if (media != null) 'media': media,
      if (mediaType != null) 'mediaType': mediaType,
    };
  }

  factory ItemApiModel.fromJson(Map<String, dynamic> json) {
    // Handle nested objects - server returns category and reportedBy as objects
    String? extractId(dynamic value) {
      if (value == null) return null;
      if (value is Map) return value['_id'] as String?;
      return value as String?;
    }

    return ItemApiModel(
      id: json['_id'] as String?,
      reportedBy: extractId(json['reportedBy']),
      claimedBy: extractId(json['claimedBy']),
      category: extractId(json['category']),
      itemName: json['itemName'] as String,
      description: json['description'] as String?,
      type: json['type'] as String,
      location: json['location'] as String,
      media: json['media'] as String?,
      mediaType: json['mediaType'] as String?,
      isClaimed: json['isClaimed'] as bool? ?? false,
      status: json['status'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

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
