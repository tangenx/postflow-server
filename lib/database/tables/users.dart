import 'package:drift/drift.dart';
import 'package:drift_postgres/drift_postgres.dart';

class Users extends Table {
  UuidColumn get id => customType(PgTypes.uuid).withDefault(genRandomUuid())();
  TextColumn get username => text().unique()();
  TextColumn get email => text().nullable().unique()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  Column<PgDateTime> get createdAt =>
      customType(PgTypes.timestampWithTimezone).withDefault(now())();
  Column<PgDateTime> get updatedAt =>
      customType(PgTypes.timestampWithTimezone).withDefault(now())();

  @override
  Set<Column<Object>>? get primaryKey => {id};
}
