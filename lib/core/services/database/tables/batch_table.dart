import 'package:drift/drift.dart';

@DataClassName('BatchModel')
class BatchTable extends Table {
  TextColumn get batchId => text()();
  TextColumn get batchName => text()();
  TextColumn get status => text().nullable()();

  @override
  Set<Column> get primaryKey => {batchId};
}
