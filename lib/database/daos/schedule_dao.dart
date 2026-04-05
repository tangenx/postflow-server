part of '../database.dart';

@DriftAccessor(
  tables: [
    PostSchedules,
    PostCaptions,
    SocialAccountTargets,
    UserSocialAccounts,
    SocialNetworks,
  ],
)
class ScheduleDao extends DatabaseAccessor<PostflowDatabase>
    with _$ScheduleDaoMixin {
  ScheduleDao(super.attachedDatabase);

  Future<PostSchedule> createSchedule({
    required UuidValue postId,
    required UuidValue socialAccountTargetId,
    required DateTime scheduledAt,
  }) async {
    return into(postSchedules).insertReturning(
      PostSchedulesCompanion.insert(
        postId: postId,
        socialAccountTargetId: socialAccountTargetId,
        scheduledAt: PgDateTime(scheduledAt),
      ),
    );
  }

  Future<PostCaption> createCaption({
    required UuidValue postScheduleId,
    required String renderedBody,
    UuidValue? templateId,
    Map<String, dynamic>? templateVariables,
  }) {
    return into(postCaptions).insertReturning(
      PostCaptionsCompanion.insert(
        postScheduleId: postScheduleId,
        renderedBody: renderedBody,
        templateId: Value(templateId),
        variableOverrides: Value(templateVariables ?? {}),
      ),
    );
  }

  Future<PostSchedule?> findById(UuidValue id) {
    return (select(
      postSchedules,
    )..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  Future<List<ScheduleWithDetails>> findSchedulesForPost(
    UuidValue postId,
    UuidValue userId,
  ) async {
    final rows =
        await (select(postSchedules).join([
                innerJoin(
                  socialAccountTargets,
                  socialAccountTargets.id.equalsExp(
                    postSchedules.socialAccountTargetId,
                  ),
                ),
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
                leftOuterJoin(
                  postCaptions,
                  postCaptions.postScheduleId.equalsExp(postSchedules.id),
                ),
              ])
              ..where(postSchedules.postId.equals(postId))
              ..where(userSocialAccounts.userId.equals(userId))
              ..orderBy([OrderingTerm.asc(postSchedules.scheduledAt)]))
            .get();

    return rows.map((row) {
      return ScheduleWithDetails(
        schedule: row.readTable(postSchedules),
        target: row.readTable(socialAccountTargets),
        account: row.readTable(userSocialAccounts),
        network: row.readTable(socialNetworks),
        caption: row.readTable(postCaptions),
      );
    }).toList();
  }

  /// all pending posts for scheduler
  Future<List<ScheduleWithDetails>> findPending() async {
    final now = DateTime.now().toUtc();
    final rows =
        await (select(postSchedules).join([
                innerJoin(
                  socialAccountTargets,
                  socialAccountTargets.id.equalsExp(
                    postSchedules.socialAccountTargetId,
                  ),
                ),
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
                leftOuterJoin(
                  postCaptions,
                  postCaptions.postScheduleId.equalsExp(postSchedules.id),
                ),
              ])
              ..where(postSchedules.status.equals(ScheduleStatus.pending))
              ..where(
                postSchedules.scheduledAt.isSmallerOrEqualValue(
                  PgDateTime(now),
                ),
              )
              ..orderBy([OrderingTerm.asc(postSchedules.scheduledAt)]))
            .get();

    return rows.map((row) {
      return ScheduleWithDetails(
        schedule: row.readTable(postSchedules),
        target: row.readTable(socialAccountTargets),
        account: row.readTable(userSocialAccounts),
        network: row.readTable(socialNetworks),
        caption: row.readTable(postCaptions),
      );
    }).toList();
  }

  Future<void> setStatus(
    UuidValue postScheduleId,
    ScheduleStatus status, {
    String? externalPostId,
    String? errorMessage,
    DateTime? publishedAt,
  }) {
    return (update(
      postSchedules,
    )..where((p) => p.id.equals(postScheduleId))).write(
      PostSchedulesCompanion(
        status: Value(status),
        externalPostId: Value.absentIfNull(externalPostId),
        errorMessage: Value.absentIfNull(errorMessage),
        publishedAt: publishedAt != null
            ? Value(PgDateTime(publishedAt))
            : Value.absent(),
      ),
    );
  }

  /// retry a failed post
  Future<PostSchedule> retry({
    required UuidValue postScheduleId,
    required UuidValue userId,
    required DateTime scheduledAt,
  }) async {
    final existing = await _findByIdAndUser(postScheduleId, userId);
    if (existing == null) {
      throw NotFoundException('Schedule not found');
    }
    if (existing.status != ScheduleStatus.failed) {
      throw ValidationException('Schedule is not failed');
    }

    final updated =
        await (update(
          postSchedules,
        )..where((p) => p.id.equals(postScheduleId))).writeReturning(
          PostSchedulesCompanion(
            status: Value(ScheduleStatus.pending),
            scheduledAt: Value(PgDateTime(scheduledAt)),
            errorMessage: Value(null),
          ),
        );

    return updated.single;
  }

  Future<void> cancel(UuidValue postScheduleId, UuidValue userId) async {
    final existing = await _findByIdAndUser(postScheduleId, userId);
    if (existing == null) {
      throw NotFoundException('Schedule not found');
    }
    if (existing.status != ScheduleStatus.pending) {
      throw ValidationException('Schedule is not pending');
    }

    await (update(postSchedules)..where((p) => p.id.equals(postScheduleId)))
        .write(PostSchedulesCompanion(status: Value(ScheduleStatus.cancelled)));
  }

  Future<PostSchedule?> _findByIdAndUser(UuidValue id, UuidValue userId) async {
    final rows =
        await (select(postSchedules).join([
                innerJoin(
                  socialAccountTargets,
                  socialAccountTargets.id.equalsExp(
                    postSchedules.socialAccountTargetId,
                  ),
                ),
                innerJoin(
                  userSocialAccounts,
                  userSocialAccounts.id.equalsExp(
                    socialAccountTargets.userSocialAccountId,
                  ),
                ),
              ])
              ..where(postSchedules.id.equals(id))
              ..where(userSocialAccounts.userId.equals(userId)))
            .getSingleOrNull();

    return rows?.readTable(postSchedules);
  }
}

class ScheduleWithDetails {
  final PostSchedule schedule;
  final SocialAccountTarget target;
  final UserSocialAccount account;
  final SocialNetwork network;
  final PostCaption? caption;

  const ScheduleWithDetails({
    required this.schedule,
    required this.target,
    required this.account,
    required this.network,
    this.caption,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': schedule.id.toString(),
      'postId': schedule.postId.toString(),
      'scheduledAt': schedule.scheduledAt.dateTime.toIso8601String(),
      'status': schedule.status.toString(),
      'publishedAt': schedule.publishedAt?.dateTime.toIso8601String(),
      'externalPostId': schedule.externalPostId,
      'errorMessage': schedule.errorMessage,
      'caption': caption != null
          ? {
              'renderedBody': caption!.renderedBody,
              'templateId': caption!.templateId?.toString(),
              'variableOverrides': caption!.variableOverrides,
            }
          : null,
      'target': {
        'id': target.id.toString(),
        'targetType': target.targetType,
        'targetId': target.targetId,
        'targetLabel': target.targetLabel,
        'shortLink': target.shortLink,
      },
      'account': {
        'id': account.id.toString(),
        'screenName': account.screenName,
      },
      'network': {
        'id': network.id.toString(),
        'slug': network.slug,
        'displayName': network.displayName,
      },
    };
  }
}
