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

  Future<RefreshToken?> findByHash(String tokenHash) async {
    final refreshToken = await (select(
      refreshTokens,
    )..where((t) => t.tokenHash.equals(tokenHash))).getSingleOrNull();

    return refreshToken;
  }

  Future<int> revoke(UuidValue id) {
    return (delete(refreshTokens)..where((t) => t.id.equals(id))).go();
  }
}
