import 'package:drift/drift.dart';
import 'package:drift_postgres/drift_postgres.dart';

import 'characters.dart';
import 'posts.dart';

class PostCharacters extends Table {
  UuidColumn get postId => customType(PgTypes.uuid).references(Posts, #id)();
  UuidColumn get characterId =>
      customType(PgTypes.uuid).references(Characters, #id)();

  @override
  Set<Column<Object>>? get primaryKey => {postId, characterId};
}
