import 'package:drift/drift.dart';
import 'package:drift_postgres/drift_postgres.dart';

import 'artists.dart';
import 'posts.dart';

class PostArtists extends Table {
  UuidColumn get postId => customType(PgTypes.uuid).references(Posts, #id)();
  UuidColumn get artistId =>
      customType(PgTypes.uuid).references(Artists, #id)();

  @override
  Set<Column<Object>>? get primaryKey => {postId, artistId};
}
