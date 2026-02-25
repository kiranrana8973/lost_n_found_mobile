import 'package:hive/hive.dart';
import 'package:lost_n_found/core/constants/hive_table_constant.dart';
import 'package:lost_n_found/features/item/data/models/item_api_model.dart';
import 'package:lost_n_found/features/item/domain/entities/item_entity.dart';
import 'package:uuid/uuid.dart';

part 'item_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.itemTypeId)
class ItemHiveModel extends HiveObject {
  @HiveField(0)
  final String? itemId;

  @HiveField(1)
  final String? reportedBy;

  @HiveField(2)
  final String? claimedBy;

  @HiveField(3)
  final String? category;

  @HiveField(4)
  final String itemName;

  @HiveField(5)
  final String? description;

  @HiveField(6)
  final String type;

  @HiveField(7)
  final String location;

  @HiveField(8)
  final String? media;

  @HiveField(9)
  final String? mediaType;

  @HiveField(10)
  final bool isClaimed;

  @HiveField(11)
  final String? status;

  ItemHiveModel({
    String? itemId,
    this.reportedBy,
    this.claimedBy,
    this.category,
    required this.itemName,
    this.description,
    required this.type,
    required this.location,
    this.media,
    this.mediaType,
    bool? isClaimed,
    String? status,
  }) : itemId = itemId ?? const Uuid().v4(),
       isClaimed = isClaimed ?? false,
       status = status ?? 'available';

  ItemEntity toEntity() {
    return ItemEntity(
      itemId: itemId,
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
    );
  }

  factory ItemHiveModel.fromEntity(ItemEntity entity) {
    return ItemHiveModel(
      itemId: entity.itemId,
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
    );
  }

  static List<ItemEntity> toEntityList(List<ItemHiveModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }

  factory ItemHiveModel.fromApiModel(ItemApiModel apiModel) {
    return ItemHiveModel(
      itemId: apiModel.id,
      reportedBy: apiModel.reportedBy,
      claimedBy: apiModel.claimedBy,
      category: apiModel.category,
      itemName: apiModel.itemName,
      description: apiModel.description,
      type: apiModel.type,
      location: apiModel.location,
      media: apiModel.media,
      mediaType: apiModel.mediaType,
      isClaimed: apiModel.isClaimed,
      status: apiModel.status,
    );
  }

  static List<ItemHiveModel> fromApiModelList(List<ItemApiModel> apiModels) {
    return apiModels.map((model) => ItemHiveModel.fromApiModel(model)).toList();
  }
}
