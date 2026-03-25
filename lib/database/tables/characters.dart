import 'package:drift/drift.dart';
import 'package:drift_postgres/drift_postgres.dart';

import 'franchises.dart';

class Characters extends Table {
  UuidColumn get id => customType(PgTypes.uuid).withDefault(genRandomUuid())();
  UuidColumn get franchiseId =>
      customType(PgTypes.uuid).references(Franchises, #id)();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  Column<PgDateTime> get createdAt =>
      customType(PgTypes.timestampWithTimezone).withDefault(now())();

  @override
  Set<Column<Object>>? get primaryKey => {id};
}
