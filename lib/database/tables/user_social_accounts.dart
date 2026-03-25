import 'package:drift/drift.dart';
import 'package:drift_postgres/drift_postgres.dart';

import 'social_networks.dart';
import 'users.dart';

class UserSocialAccounts extends Table {
  UuidColumn get id => customType(PgTypes.uuid).withDefault(genRandomUuid())();
  UuidColumn get userId => customType(PgTypes.uuid).references(Users, #id)();
  UuidColumn get socialNetworkId =>
      customType(PgTypes.uuid).references(SocialNetworks, #id)();
  TextColumn get externalAccountId => text()();
  TextColumn get screenName => text().nullable()();
  TextColumn get accessToken => text().nullable()();
  TextColumn get refreshToken => text().nullable()();
  Column<PgDateTime> get tokenExpiresAt =>
      customType(PgTypes.timestampWithTimezone).nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  Column<PgDateTime> get createdAt =>
      customType(PgTypes.timestampWithTimezone).withDefault(now())();

  @override
  Set<Column<Object>>? get primaryKey => {id};

  @override
  List<Set<Column<Object>>>? get uniqueKeys => [
    {socialNetworkId, externalAccountId},
  ];
}
