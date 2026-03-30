part of '../database.dart';

@DriftAccessor(tables: [Artists])
class ArtistsDao extends DatabaseAccessor<PostflowDatabase>
    with _$ArtistsDaoMixin {
  ArtistsDao(super.attachedDatabase);

  // lets do the CRUD the proper way

  // C
  Future<Artist> create({
    required String name,
    String? sourceUrl,
    String? notes,
  }) {
    final artist = ArtistsCompanion.insert(
      name: name,
      sourceUrl: Value.absentIfNull(sourceUrl),
      notes: Value.absentIfNull(notes),
    );

    return into(artists).insertReturning(artist);
  }

  // R
  // return artist by name or null
  // Future<Artist?> getByName(String name) {
  //   return (select(
  //     artists,
  //   )..where((t) => t.name.equals(name))).getSingleOrNull();
  // }

  Future<Artist?> getById(UuidValue id) {
    return (select(artists)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<List<Artist>> search(String query, {int limit = 10}) {
    return (select(artists)
          ..where((t) => t.name.like('%$query%'))
          ..orderBy([(t) => OrderingTerm(expression: t.name)])
          ..limit(limit))
        .get();
  }

  /// return latest 1000 artists
  Future<List<Artist>> getLatest() {
    return (select(artists)
          ..orderBy([(t) => OrderingTerm(expression: t.id)])
          ..limit(1000))
        .get();
  }

  // U
  /// yeah it collides with `update` method from drift
  Future<Artist> updateArtist({
    required UuidValue id,
    String? name,
    String? sourceUrl,
    String? notes,
  }) async {
    final artist = ArtistsCompanion(
      id: Value(id),
      name: Value.absentIfNull(name),
      sourceUrl: Value.absentIfNull(sourceUrl),
      notes: Value.absentIfNull(notes),
    );

    final updated = await (update(
      artists,
    )..where((t) => t.id.equals(id))).writeReturning(artist);
    if (updated.isEmpty) {
      throw NotFoundException('Artist not found');
    }

    return updated.single;
  }

  // D
  /// its also collides with `delete` method from drift
  Future<int> deleteArtist(UuidValue id) {
    return (delete(artists)..where((t) => t.id.equals(id))).go();
  }
}
