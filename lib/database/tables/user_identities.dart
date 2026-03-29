import 'package:drift/drift.dart';
import 'package:drift_postgres/drift_postgres.dart';

import '../types/pg_enum_type.dart';
import 'users.dart';

enum IdentityProvider { local, vk, github, discord, telegram }

const identityProviderType = PgEnumType<IdentityProvider>(
  pgTypeName: 'identity_provider',
  values: IdentityProvider.values,
);

class UserIdentities extends Table {
  UuidColumn get id => customType(PgTypes.uuid).withDefault(genRandomUuid())();
  UuidColumn get userId => customType(PgTypes.uuid).references(Users, #id)();
  Column<IdentityProvider> get provider => customType(identityProviderType)();
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
