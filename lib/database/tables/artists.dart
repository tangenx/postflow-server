import 'package:drift/drift.dart';
import 'package:drift_postgres/drift_postgres.dart';

class Artists extends Table {
  UuidColumn get id => customType(PgTypes.uuid).withDefault(genRandomUuid())();
  TextColumn get name => text()();
  TextColumn get sourceUrl => text().nullable()();
  TextColumn get notes => text().nullable()();
  Column<PgDateTime> get createdAt =>
      customType(PgTypes.timestampWithTimezone).withDefault(now())();

  @override
  Set<Column<Object>>? get primaryKey => {id};
}
