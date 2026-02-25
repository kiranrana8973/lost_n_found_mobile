import 'package:hive/hive.dart';
import 'package:lost_n_found/core/constants/hive_table_constant.dart';
import 'package:lost_n_found/features/auth/data/models/auth_hive_model.dart';
import 'package:lost_n_found/features/batch/data/models/batch_hive_model.dart';
import 'package:lost_n_found/features/category/data/models/category_hive_model.dart';
import 'package:lost_n_found/features/item/data/models/item_hive_model.dart';
import 'package:path_provider/path_provider.dart';

typedef _AdapterEntry = ({int typeId, TypeAdapter adapter, String boxName});

List<_AdapterEntry> _buildAdapterTable() => [
  (
    typeId: HiveTableConstant.batchTypeId,
    adapter: BatchHiveModelAdapter(),
    boxName: HiveTableConstant.batchTable,
  ),
  (
    typeId: HiveTableConstant.studentTypeId,
    adapter: AuthHiveModelAdapter(),
    boxName: HiveTableConstant.studentTable,
  ),
  (
    typeId: HiveTableConstant.itemTypeId,
    adapter: ItemHiveModelAdapter(),
    boxName: HiveTableConstant.itemTable,
  ),
  (
    typeId: HiveTableConstant.categoryTypeId,
    adapter: CategoryHiveModelAdapter(),
    boxName: HiveTableConstant.categoryTable,
  ),
];

class HiveService {
  Future<void> init() async {
    final directory = await getApplicationDocumentsDirectory();
    Hive.init('${directory.path}/${HiveTableConstant.dbName}');

    for (final entry in _buildAdapterTable()) {
      if (!Hive.isAdapterRegistered(entry.typeId)) {
        Hive.registerAdapter(entry.adapter);
      }
    }

    await Future.wait([
      Hive.openBox<BatchHiveModel>(HiveTableConstant.batchTable),
      Hive.openBox<AuthHiveModel>(HiveTableConstant.studentTable),
      Hive.openBox<ItemHiveModel>(HiveTableConstant.itemTable),
      Hive.openBox<CategoryHiveModel>(HiveTableConstant.categoryTable),
    ]);
  }
}
