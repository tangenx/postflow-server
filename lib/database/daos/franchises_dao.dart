part of '../database.dart';

@DriftAccessor(tables: [Franchises])
class FranchisesDao extends DatabaseAccessor<PostflowDatabase>
    with _$FranchisesDaoMixin {
  FranchisesDao(super.attachedDatabase);

  // C
  Future<Franchise> create({required String name, String? description}) {
    final franchise = FranchisesCompanion.insert(
      name: name,
      description: Value.absentIfNull(description),
    );

    return into(franchises).insertReturning(franchise);
  }

  // R
  // return franchise by name or null
  // Future<Franchise?> getByName(String name) {
  //   return (select(
  //     franchises,
  //   )..where((t) => t.name.equals(name))).getSingleOrNull();
  // }

  Future<Franchise?> getById(UuidValue id) {
    return (select(
      franchises,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<List<Franchise>> search(String query, {int limit = 10}) {
    return (select(franchises)
          ..where((t) => t.name.like('%$query%'))
          ..orderBy([(t) => OrderingTerm(expression: t.name)])
          ..limit(limit))
        .get();
  }

  /// return latest 1000 franchises
  Future<List<Franchise>> getLatest() {
    return (select(franchises)
          ..orderBy([(t) => OrderingTerm(expression: t.id)])
          ..limit(1000))
        .get();
  }

  // U
  /// yeah it collides with `update` method from drift
  Future<Franchise> updateFranchise({
    required UuidValue id,
    String? name,
    String? description,
  }) async {
    final franchise = FranchisesCompanion(
      id: Value(id),
      name: Value.absentIfNull(name),
      description: Value.absentIfNull(description),
    );

    final updated = await (update(
      franchises,
    )..where((t) => t.id.equals(id))).writeReturning(franchise);
    if (updated.isEmpty) {
      throw NotFoundException('Franchise not found');
    }

    return updated.single;
  }

  // D
  /// it also collides with `delete` method from drift
  Future<int> deleteFranchise(UuidValue id) {
    return (delete(franchises)..where((t) => t.id.equals(id))).go();
  }
}
