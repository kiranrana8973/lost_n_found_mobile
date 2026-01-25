// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ItemApiModel _$ItemApiModelFromJson(Map<String, dynamic> json) => ItemApiModel(
      id: json['_id'] as String?,
      reportedBy: _extractId(json['reportedBy']),
      claimedBy: _extractId(json['claimedBy']),
      category: _extractId(json['category']),
      itemName: json['itemName'] as String,
      description: json['description'] as String?,
      type: json['type'] as String,
      location: json['location'] as String,
      media: json['media'] as String?,
      mediaType: json['mediaType'] as String?,
      isClaimed: json['isClaimed'] as bool? ?? false,
      status: json['status'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$ItemApiModelToJson(ItemApiModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'reportedBy': instance.reportedBy,
      'claimedBy': instance.claimedBy,
      'category': instance.category,
      'itemName': instance.itemName,
      'description': instance.description,
      'type': instance.type,
      'location': instance.location,
      'media': instance.media,
      'mediaType': instance.mediaType,
      'isClaimed': instance.isClaimed,
      'status': instance.status,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
