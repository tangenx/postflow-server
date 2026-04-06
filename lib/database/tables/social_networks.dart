import 'package:drift/drift.dart';
import 'package:drift_postgres/drift_postgres.dart';

class SocialNetworks extends Table {
  UuidColumn get id => customType(PgTypes.uuid).withDefault(genRandomUuid())();
  TextColumn get slug => text().unique()();
  TextColumn get displayName => text()();
  JsonColumn get capabilities => customType(
    PgTypes.jsonb,
  ).withDefault(const Constant('{}', PgTypes.jsonb))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  @override
  Set<Column<Object>>? get primaryKey => {id};
}
