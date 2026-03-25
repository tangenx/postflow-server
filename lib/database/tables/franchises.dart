import 'package:drift/drift.dart';
import 'package:drift_postgres/drift_postgres.dart';

class Franchises extends Table {
  UuidColumn get id => customType(PgTypes.uuid).withDefault(genRandomUuid())();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  Column<PgDateTime> get createdAt =>
      customType(PgTypes.timestampWithTimezone).withDefault(now())();

  @override
  Set<Column<Object>>? get primaryKey => {id};
}
