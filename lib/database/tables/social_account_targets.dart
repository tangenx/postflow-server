import 'package:drift/drift.dart';
import 'package:drift_postgres/drift_postgres.dart';

import 'user_social_accounts.dart';

class SocialAccountTargets extends Table {
  UuidColumn get id => customType(PgTypes.uuid).withDefault(genRandomUuid())();
  UuidColumn get userSocialAccountId =>
      customType(PgTypes.uuid).references(UserSocialAccounts, #id)();
  // 'user', 'group', 'channel', 'chat'
  TextColumn get targetType => text()();
  // group id, channel @username, telegram chat_id, etc.
  TextColumn get targetId => text()();
  // human-readable label shown in UI, e.g. "My Art Channel"
  TextColumn get targetLabel => text().nullable()();
  // short link for captions, e.g. "@mypostaccount" or "t.me/mychannel"
  TextColumn get shortLink => text().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  @override
  Set<Column<Object>>? get primaryKey => {id};

  @override
  List<Set<Column<Object>>>? get uniqueKeys => [
    {userSocialAccountId, targetId},
  ];
}
