part of '../database.dart';

@DriftAccessor(tables: [UserIdentities])
class UserIdentitiesDao extends DatabaseAccessor<PostflowDatabase>
    with _$UserIdentitiesDaoMixin {
  UserIdentitiesDao(super.attachedDatabase);

  Future<void> createLocalUserIdentity({
    required UuidValue userId,
    required String passwordHash,
  }) async {
    final userIdentity = UserIdentitiesCompanion.insert(
      userId: userId,
      provider: IdentityProvider.local,
      passwordHash: Value(passwordHash),
    );

    await into(userIdentities).insert(userIdentity);
  }

  /// finds the `LOCAL` user identity for the given [userId]
  Future<UserIdentity?> findLocalByUserId(UuidValue userId) async {
    final userIdentity =
        await (select(userIdentities)..where(
              (t) =>
                  t.userId.equals(userId) &
                  t.provider.equals(IdentityProvider.local.name),
            ))
            .getSingleOrNull();

    return userIdentity;
  }
}
