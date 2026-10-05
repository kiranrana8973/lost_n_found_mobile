import 'package:drift/drift.dart';

@DataClassName('AuthModel')
class AuthTable extends Table {
  TextColumn get authId => text()();
  TextColumn get fullName => text()();
  TextColumn get email => text().unique()();
  TextColumn get phoneNumber => text().nullable()();
  TextColumn get username => text()();
  TextColumn get password => text().nullable()();
  TextColumn get batchId => text().nullable()();
  TextColumn get profilePicture => text().nullable()();

  @override
  Set<Column> get primaryKey => {authId};
}
