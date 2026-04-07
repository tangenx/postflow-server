part of '../database.dart';

@DriftAccessor(tables: [SocialNetworks])
class SocialNetworksDao extends DatabaseAccessor<PostflowDatabase>
    with _$SocialNetworksDaoMixin {
  SocialNetworksDao(super.attachedDatabase);

  Future<SocialNetwork?> findById(UuidValue id) async {
    return (select(
      socialNetworks,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }
}
