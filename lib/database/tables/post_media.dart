import 'package:drift/drift.dart';
import 'package:drift_postgres/drift_postgres.dart';

import 'media_files.dart';
import 'posts.dart';

class PostMedia extends Table {
  UuidColumn get id => customType(PgTypes.uuid).withDefault(genRandomUuid())();
  UuidColumn get postId => customType(PgTypes.uuid).references(Posts, #id)();
  UuidColumn get mediaFileId =>
      customType(PgTypes.uuid).references(MediaFiles, #id)();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  @override
  Set<Column<Object>>? get primaryKey => {id};

  @override
  List<Set<Column<Object>>>? get uniqueKeys => [
    {postId, mediaFileId},
  ];
}
