part of '../database.dart';

@DriftAccessor(tables: [Characters])
class CharactersDao extends DatabaseAccessor<PostflowDatabase>
    with _$CharactersDaoMixin {
  CharactersDao(super.attachedDatabase);

  // C
  Future<Character> create({
    required String name,
    UuidValue? franchiseId,
    String? description,
  }) {
    final character = CharactersCompanion.insert(
      name: name,
      description: Value(description),
      franchiseId: Value(franchiseId),
    );

    return into(characters).insertReturning(character);
  }

  // R
  // return character by name or null
  // Future<Character?> getByName(String name) {
  //   return (select(
  //     characters,
  //   )..where((t) => t.name.equals(name))).getSingleOrNull();
  // }

  Future<Character?> getById(UuidValue id) {
    return (select(
      characters,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<List<Character>> search(String query, {int limit = 10}) {
    return (select(characters)
          ..where((t) => t.name.like('%$query%'))
          ..orderBy([(t) => OrderingTerm(expression: t.name)])
          ..limit(limit))
        .get();
  }

  /// return latest 1000 characters
  Future<List<Character>> getLatest() {
    return (select(characters)
          ..orderBy([(t) => OrderingTerm(expression: t.id)])
          ..limit(1000))
        .get();
  }

  // U
  /// yeah it collides with `update` method from drift
  Future<Character> updateCharacter({
    required UuidValue id,
    UuidValue? franchiseId,
    String? name,
    String? description,
  }) async {
    final character = CharactersCompanion(
      id: Value(id),
      franchiseId: Value.absentIfNull(franchiseId),
      name: Value.absentIfNull(name),
      description: Value.absentIfNull(description),
    );

    final updated = await (update(
      characters,
    )..where((t) => t.id.equals(id))).writeReturning(character);
    if (updated.isEmpty) {
      throw NotFoundException('Character not found');
    }

    return updated.single;
  }

  // D
  /// it also collides with `delete` method from drift
  Future<int> deleteCharacter(UuidValue id) {
    return (delete(characters)..where((t) => t.id.equals(id))).go();
  }
}
