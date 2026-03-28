part of '../database.dart';

@DriftAccessor(tables: [RefreshTokens])
class RefreshTokensDao extends DatabaseAccessor<PostflowDatabase>
    with _$RefreshTokensDaoMixin {
  RefreshTokensDao(super.attachedDatabase);

  Future<void> store(UuidValue userId, String token, DateTime expiresAt) async {
    final refreshToken = RefreshTokensCompanion.insert(
      userId: userId,
      tokenHash: token,
      expiresAt: PgDateTime(expiresAt),
    );

    await into(refreshTokens).insert(refreshToken);
  }

  Future<RefreshToken?> findValidByHash(String tokenHash) async {
    final now = DateTime.now();

    final refreshToken =
        await (select(refreshTokens)..where(
              (t) =>
                  t.tokenHash.equals(tokenHash) &
                  t.expiresAt.isBiggerThan(Variable(PgDateTime(now))) &
                  t.revokedAt.isNull(),
            ))
            .getSingleOrNull();

    return refreshToken;
  }

  /// revoke the refresh token by token id from the database
  Future<int> revoke(UuidValue id) {
    return (delete(refreshTokens)..where((t) => t.id.equals(id))).go();
  }

  Future<int> revokeByHash(String tokenHash) {
    return (delete(
      refreshTokens,
    )..where((t) => t.tokenHash.equals(tokenHash))).go();
  }
}
