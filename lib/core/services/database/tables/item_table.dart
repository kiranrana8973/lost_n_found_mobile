import 'package:drift/drift.dart';

@DataClassName('ItemModel')
@TableIndex(name: 'idx_item_type', columns: {#type})
@TableIndex(name: 'idx_item_reported_by', columns: {#reportedBy})
@TableIndex(name: 'idx_item_category_id', columns: {#categoryId})
class ItemTable extends Table {
  TextColumn get itemId => text()();
  TextColumn get reportedBy => text().nullable()();
  TextColumn get claimedBy => text().nullable()();
  TextColumn get categoryId => text().nullable()();
  TextColumn get itemName => text()();
  TextColumn get description => text().nullable()();

  /// 'lost' or 'found'
  TextColumn get type => text()();
  TextColumn get location => text()();
  TextColumn get media => text().nullable()();
  TextColumn get mediaType => text().nullable()();
  BoolColumn get isClaimed => boolean().withDefault(const Constant(false))();
  TextColumn get status => text().nullable()();

  @override
  Set<Column> get primaryKey => {itemId};
}
