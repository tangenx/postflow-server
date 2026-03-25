import 'package:drift/drift.dart';
import 'package:drift_postgres/drift_postgres.dart';

import 'posts.dart';
import 'social_account_targets.dart';

enum ScheduleStatus { pending, publishing, published, failed, cancelled }

class PostSchedules extends Table {
  UuidColumn get id => customType(PgTypes.uuid).withDefault(genRandomUuid())();
  UuidColumn get postId => customType(PgTypes.uuid).references(Posts, #id)();
  UuidColumn get socialAccountTargetId =>
      customType(PgTypes.uuid).references(SocialAccountTargets, #id)();
  Column<PgDateTime> get scheduledAt =>
      customType(PgTypes.timestampWithTimezone)();
  TextColumn get status => textEnum<ScheduleStatus>().withDefault(
    Constant(ScheduleStatus.pending.name),
  )();
  TextColumn get externalPostId => text().nullable()();
  Column<PgDateTime> get publishedAt =>
      customType(PgTypes.timestampWithTimezone).nullable()();
  TextColumn get errorMessage => text().nullable()();
  Column<PgDateTime> get createdAt =>
      customType(PgTypes.timestampWithTimezone).withDefault(now())();
  Column<PgDateTime> get updatedAt =>
      customType(PgTypes.timestampWithTimezone).withDefault(now())();

  @override
  Set<Column<Object>>? get primaryKey => {id};
}
