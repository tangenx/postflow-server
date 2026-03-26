part of '../database.dart';

@DriftAccessor(tables: [Artists])
class ArtistsDao extends DatabaseAccessor<PostflowDatabase>
    with _$ArtistsDaoMixin {
  ArtistsDao(super.attachedDatabase);

  Future<List<Artist>> getLatestArtists() {
    return (select(artists)..limit(1000)).get();
  }
}
