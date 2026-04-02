import 'package:drift/drift.dart';
import 'package:drift_postgres/drift_postgres.dart';

import 'franchises.dart';
import 'posts.dart';

class PostFranchises extends Table {
  UuidColumn get postId => customType(PgTypes.uuid).references(Posts, #id)();
  UuidColumn get franchiseId =>
      customType(PgTypes.uuid).references(Franchises, #id)();

  @override
  Set<Column<Object>>? get primaryKey => {postId, franchiseId};
}
