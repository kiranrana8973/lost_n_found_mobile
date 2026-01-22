import 'package:hive/hive.dart';
import 'package:lost_n_found/core/constants/hive_table_constant.dart';
import 'package:lost_n_found/features/item/domain/entities/item_entity.dart';
import 'package:uuid/uuid.dart';

part 'item_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.iteTypeId)
class ItemHiveModel extends HiveObject {
  @HiveField(0)
  final String? itemId;

  @HiveField(1)
  final String? reportedBy;

  @HiveField(2)
  final String? claimedBy;

  @HiveField(3)
  final String? categoryId;

  @HiveField(4)
  final String itemName;

  @HiveField(5)
  final String? description;

  @HiveField(6)
  final String type; // 'lost' or 'found'

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
    this.categoryId,
    required this.itemName,
    this.description,
    required this.type,
    required this.location,
    this.media,
    this.mediaType,
    bool? isClaimed,
    String? status,
  })  : itemId = itemId ?? const Uuid().v4(),
        isClaimed = isClaimed ?? false,
        status = status ?? 'active';

  ItemEntity toEntity() {
    return ItemEntity(
      itemId: itemId,
      reportedBy: reportedBy,
      claimedBy: claimedBy,
      categoryId: categoryId,
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
      categoryId: entity.categoryId,
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
}
