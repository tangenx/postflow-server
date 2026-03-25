import 'package:drift/drift.dart';
import 'package:drift_postgres/drift_postgres.dart';

import 'users.dart';

class RefreshTokens extends Table {
  UuidColumn get id => customType(PgTypes.uuid).withDefault(genRandomUuid())();
  UuidColumn get userId => customType(PgTypes.uuid).references(Users, #id)();
  TextColumn get tokenHash => text().unique()();
  Column<PgDateTime> get expiresAt =>
      customType(PgTypes.timestampWithTimezone)();
  Column<PgDateTime> get revokedAt =>
      customType(PgTypes.timestampWithTimezone).nullable()();

  Column<PgDateTime> get createdAt =>
      customType(PgTypes.timestampWithTimezone).withDefault(now())();

  @override
  Set<Column<Object>>? get primaryKey => {id};
}
