import 'package:drift/drift.dart';
import 'package:drift_postgres/drift_postgres.dart';

import '../types/pg_enum_type.dart';
import 'users.dart';

enum PostStatus { draft, ready, partial, archived }

const postStatusType = PgEnumType<PostStatus>(
  pgTypeName: 'post_status',
  values: PostStatus.values,
);

class Posts extends Table {
  UuidColumn get id => customType(PgTypes.uuid).withDefault(genRandomUuid())();
  UuidColumn get createdBy => customType(PgTypes.uuid).references(Users, #id)();
  TextColumn get internalNote => text().nullable()();
  TextColumn get description => text().nullable()();
  Column<PostStatus> get status => customType(
    postStatusType,
  ).withDefault(Constant(PostStatus.draft, postStatusType))();
  Column<PgDateTime> get createdAt =>
      customType(PgTypes.timestampWithTimezone).withDefault(now())();
  Column<PgDateTime> get updatedAt =>
      customType(PgTypes.timestampWithTimezone).withDefault(now())();

  @override
  Set<Column<Object>>? get primaryKey => {id};
}
