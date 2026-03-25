import 'package:drift/drift.dart';
import 'package:drift_postgres/drift_postgres.dart';

class MediaTypes extends Table {
  UuidColumn get id => customType(PgTypes.uuid).withDefault(genRandomUuid())();
  TextColumn get slug => text().unique()();
  TextColumn get displayName => text()();
  // Drift doesn't have a native TEXT[] column; store as JSONB array
  Column<List<String>> get allowedExtensions => customType(
    PgTypes.textArray,
  ).withDefault(Constant([], PgTypes.textArray))();
  IntColumn get maxSizeMb => integer().withDefault(const Constant(20))();

  @override
  Set<Column<Object>>? get primaryKey => {id};
}
