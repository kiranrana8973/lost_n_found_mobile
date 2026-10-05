import 'package:lost_n_found/core/services/database/app_database.dart';
import 'package:lost_n_found/features/item/domain/entities/item_entity.dart';
import 'package:uuid/uuid.dart';

// The row class itself is generated into app_database.dart; re-export it so
// importing this file gives you both the model and its mappers.
export 'package:lost_n_found/core/services/database/app_database.dart'
    show ItemModel;

// ItemModel is the drift row class generated from ItemTable.
// These extensions map it to and from the domain entity.

extension ItemModelX on ItemModel {
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
}

extension ItemEntityX on ItemEntity {
  ItemModel toModel() {
    return ItemModel(
      itemId: itemId ?? const Uuid().v4(),
      reportedBy: reportedBy,
      claimedBy: claimedBy,
      categoryId: categoryId,
      itemName: itemName,
      description: description,
      type: type == ItemType.lost ? 'lost' : 'found',
      location: location,
      media: media,
      mediaType: mediaType,
      isClaimed: isClaimed,
      status: status ?? 'active',
    );
  }
}

extension ItemModelListX on List<ItemModel> {
  List<ItemEntity> toEntityList() => map((model) => model.toEntity()).toList();
}
