part of '../database.dart';

@DriftAccessor(
  tables: [SocialAccountTargets, UserSocialAccounts, SocialNetworks],
)
class SocialAccountTargetsDao extends DatabaseAccessor<PostflowDatabase>
    with _$SocialAccountTargetsDaoMixin {
  SocialAccountTargetsDao(super.attachedDatabase);

  Future<SocialAccountTarget> create({
    required UuidValue userSocialAccountId,
    required String targetType,
    required String targetId,
    String? targetLabel,
    String? shortLink,
  }) {
    return into(socialAccountTargets).insertReturning(
      SocialAccountTargetsCompanion.insert(
        userSocialAccountId: userSocialAccountId,
        targetType: targetType,
        targetId: targetId,
        targetLabel: Value(targetLabel),
        shortLink: Value(shortLink),
      ),
    );
  }

  Future<SocialAccountTarget?> findById(UuidValue id) {
    return (select(
      socialAccountTargets,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<List<SocialAccountTarget>> findByAccount(UuidValue accountId) {
    return (select(socialAccountTargets)
          ..where((t) => t.userSocialAccountId.equals(accountId))
          ..orderBy([(t) => OrderingTerm.asc(t.targetId)]))
        .get();
  }

  Future<List<TargetWithAccount>> findByUser(UuidValue userId) async {
    final rows =
        await (select(socialAccountTargets).join([
                innerJoin(
                  userSocialAccounts,
                  userSocialAccounts.id.equalsExp(
                    socialAccountTargets.userSocialAccountId,
                  ),
                ),
                innerJoin(
                  socialNetworks,
                  socialNetworks.id.equalsExp(
                    userSocialAccounts.socialNetworkId,
                  ),
                ),
              ])
              ..where(userSocialAccounts.userId.equals(userId))
              ..where(socialAccountTargets.isActive.equals(true)))
            .get();

    return rows
        .map(
          (row) => TargetWithAccount(
            target: row.readTable(socialAccountTargets),
            account: row.readTable(userSocialAccounts),
            network: row.readTable(socialNetworks),
          ),
        )
        .toList();
  }

  Future<bool> belongsToUser(UuidValue targetId, UuidValue userId) async {
    final query =
        await (select(socialAccountTargets).join([
                innerJoin(
                  userSocialAccounts,
                  userSocialAccounts.id.equalsExp(
                    socialAccountTargets.userSocialAccountId,
                  ),
                ),
              ])
              ..where(socialAccountTargets.id.equals(targetId))
              ..where(userSocialAccounts.userId.equals(userId)))
            .getSingleOrNull();

    return query != null;
  }

  Future<SocialAccountTarget> updateTarget({
    required UuidValue id,
    required UuidValue userId,
    String? targetLabel,
    String? shortLink,
    bool? isActive,
  }) async {
    if (!(await belongsToUser(id, userId))) {
      throw NotFoundException('Target not found');
    }

    final updated =
        await (update(
          socialAccountTargets,
        )..where((t) => t.id.equals(id))).writeReturning(
          SocialAccountTargetsCompanion(
            targetLabel: Value.absentIfNull(targetLabel),
            shortLink: Value.absentIfNull(shortLink),
            isActive: Value.absentIfNull(isActive),
          ),
        );

    if (updated.isEmpty) {
      throw NotFoundException('Target not found');
    }

    return updated.single;
  }

  Future<void> deleteTarget(UuidValue id, UuidValue userId) async {
    if (!(await belongsToUser(id, userId))) {
      throw NotFoundException('Target not found');
    }

    await (delete(
          socialAccountTargets,
        )..where((t) => t.id.equals(id) & t.userSocialAccountId.equals(userId)))
        .go();
  }
}

class TargetWithAccount {
  final SocialAccountTarget target;
  final UserSocialAccount account;
  final SocialNetwork network;

  const TargetWithAccount({
    required this.target,
    required this.account,
    required this.network,
  });
}
