import 'package:drift/drift.dart';

@DataClassName('CategoryModel')
class CategoryTable extends Table {
  TextColumn get categoryId => text()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  TextColumn get status => text().nullable()();

  @override
  Set<Column> get primaryKey => {categoryId};
}
