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

  /// find the VALID (not revoked) refresh token by token hash
  Future<RefreshToken?> findValidByHash(String tokenHash) async {
    final now = const CustomExpression<PgDateTime>('NOW()');

    final refreshToken =
        await (select(refreshTokens)..where(
              (t) =>
                  t.tokenHash.equals(tokenHash) &
                  t.expiresAt.isBiggerThan(now) &
                  t.revokedAt.isNull(),
            ))
            .getSingleOrNull();

    return refreshToken;
  }

  /// revoke the refresh token by token id from the database
  Future<int> revoke(UuidValue id) {
    return (delete(refreshTokens)..where((t) => t.id.equals(id))).go();
  }

  /// revoke the refresh token by token hash from the database
  Future<int> revokeByHash(String tokenHash) {
    return (delete(
      refreshTokens,
    )..where((t) => t.tokenHash.equals(tokenHash))).go();
  }
}
