import 'package:drift/drift.dart';
import 'package:drift_postgres/drift_postgres.dart';

import 'users.dart';

class CaptionTemplates extends Table {
  UuidColumn get id => customType(PgTypes.uuid).withDefault(genRandomUuid())();
  UuidColumn get ownerId =>
      customType(PgTypes.uuid).nullable().references(Users, #id)();
  TextColumn get name => text()();
  TextColumn get body => text()();
  JsonColumn get variables => customType(
    PgTypes.jsonb,
  ).withDefault(const Constant('[]', PgTypes.jsonb))();
  BoolColumn get isGlobal => boolean().withDefault(const Constant(false))();
  Column<PgDateTime> get createdAt =>
      customType(PgTypes.timestampWithTimezone).withDefault(now())();
  Column<PgDateTime> get updatedAt =>
      customType(PgTypes.timestampWithTimezone).withDefault(now())();

  @override
  Set<Column<Object>>? get primaryKey => {id};
}
