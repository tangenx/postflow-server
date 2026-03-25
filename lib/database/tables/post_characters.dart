import 'package:drift/drift.dart';
import 'package:drift_postgres/drift_postgres.dart';

import 'characters.dart';
import 'franchises.dart';
import 'posts.dart';

class PostCharacters extends Table {
  UuidColumn get postId => customType(PgTypes.uuid).references(Posts, #id)();
  UuidColumn get characterId =>
      customType(PgTypes.uuid).references(Characters, #id)();
  // which franchise context the character appears in (e.g. crossover setting)
  UuidColumn get contextFranchiseId =>
      customType(PgTypes.uuid).nullable().references(Franchises, #id)();

  @override
  Set<Column<Object>>? get primaryKey => {postId, characterId};
}
