import 'package:drift/drift.dart';
import 'package:drift_postgres/drift_postgres.dart';

import 'users.dart';

enum IdentityProvider { local, vk, github, discord, telegram }

class UserIdentities extends Table {
  UuidColumn get id => customType(PgTypes.uuid).withDefault(genRandomUuid())();
  UuidColumn get userId => customType(PgTypes.uuid).references(Users, #id)();
  TextColumn get provider => textEnum<IdentityProvider>()();
  TextColumn get providerSubject => text().nullable()();
  TextColumn get passwordHash => text().nullable()();
  Column<PgDateTime> get createdAt =>
      customType(PgTypes.timestampWithTimezone).withDefault(now())();

  @override
  List<Set<Column<Object>>>? get uniqueKeys => [
    {provider, providerSubject},
    {userId, provider},
  ];

  @override
  Set<Column<Object>>? get primaryKey => {id};
}
