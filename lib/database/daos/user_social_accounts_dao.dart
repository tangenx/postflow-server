part of '../database.dart';

@DriftAccessor(tables: [UserSocialAccounts, SocialNetworks])
class UserSocialAccountsDao extends DatabaseAccessor<PostflowDatabase>
    with _$UserSocialAccountsDaoMixin {
  UserSocialAccountsDao(super.attachedDatabase);

  Future<UserSocialAccount> create({
    required UuidValue userId,
    required UuidValue socialNetworkId,
    required String externalAccountId,
    String? screenName,
    String? accessToken,
    String? refreshToken,
    DateTime? tokenExpiresAt,
  }) {
    return into(userSocialAccounts).insertReturning(
      UserSocialAccountsCompanion.insert(
        userId: userId,
        socialNetworkId: socialNetworkId,
        externalAccountId: externalAccountId,
        screenName: Value(screenName),
        accessToken: Value(accessToken),
        refreshToken: Value(refreshToken),
        tokenExpiresAt: tokenExpiresAt != null
            ? Value(PgDateTime(tokenExpiresAt))
            : Value(null),
      ),
    );
  }

  Future<UserSocialAccount?> findById(UuidValue id) {
    return (select(
      userSocialAccounts,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<UserSocialAccount?> findByIdAndUser(UuidValue id, UuidValue userId) {
    return (select(userSocialAccounts)
          ..where((t) => t.id.equals(id) & t.userId.equals(userId)))
        .getSingleOrNull();
  }

  Future<List<AccountWithNetwork>> findByUser(UuidValue userId) async {
    final query =
        await (select(userSocialAccounts).join([
                innerJoin(
                  socialNetworks,
                  socialNetworks.id.equalsExp(
                    userSocialAccounts.socialNetworkId,
                  ),
                ),
              ])
              ..where(userSocialAccounts.userId.equals(userId))
              ..orderBy([OrderingTerm.asc(socialNetworks.displayName)]))
            .get();

    return query
        .map(
          (row) => AccountWithNetwork(
            account: row.readTable(userSocialAccounts),
            network: row.readTable(socialNetworks),
          ),
        )
        .toList();
  }

  Future<UserSocialAccount> updateSocialAccount({
    required UuidValue id,
    required UuidValue userId,
    String? screenName,
    String? accessToken,
    String? refreshToken,
    DateTime? tokenExpiresAt,
    bool? isActive,
  }) async {
    final updated =
        await (update(userSocialAccounts)
              ..where((t) => t.id.equals(id) & t.userId.equals(userId)))
            .writeReturning(
              UserSocialAccountsCompanion(
                screenName: Value.absentIfNull(screenName),
                accessToken: Value.absentIfNull(accessToken),
                refreshToken: Value.absentIfNull(refreshToken),
                tokenExpiresAt: tokenExpiresAt != null
                    ? Value(PgDateTime(tokenExpiresAt))
                    : Value.absent(),
                isActive: Value.absentIfNull(isActive),
              ),
            );

    if (updated.isEmpty) {
      throw NotFoundException('User social account not found');
    }

    return updated.single;
  }

  Future<void> deleteSocialAccount(UuidValue id, UuidValue userId) {
    return (delete(
      userSocialAccounts,
    )..where((t) => t.id.equals(id) & t.userId.equals(userId))).go();
  }
}

extension UserSocialAccountJson on UserSocialAccount {
  Map<String, dynamic> toSafeJson() {
    return <String, dynamic>{
      'id': id.toString(),
      'socialNetworkId': socialNetworkId.toString(),
      'externalAccountId': externalAccountId,
      'screenName': screenName,
      'tokenExpiresAt': tokenExpiresAt?.dateTime.toIso8601String(),
      'isActive': isActive,
      'createdAt': createdAt.dateTime.toIso8601String(),
    };
  }
}

class AccountWithNetwork {
  final UserSocialAccount account;
  final SocialNetwork network;

  const AccountWithNetwork({required this.account, required this.network});

  Map<String, dynamic> toJson() {
    return {
      'id': account.id.toString(),
      'externalAccountId': account.externalAccountId,
      'screenName': account.screenName,
      'tokenExpiresAt': account.tokenExpiresAt?.dateTime.toIso8601String(),
      'isActive': account.isActive,
      'createdAt': account.createdAt.dateTime.toIso8601String(),
      'network': {
        'id': network.id.toString(),
        'slug': network.slug,
        'displayName': network.displayName,
        'capabilities': network.capabilities,
        'isActive': network.isActive,
      },
    };
  }
}
