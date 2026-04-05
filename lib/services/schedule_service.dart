import 'package:drift_postgres/drift_postgres.dart';
import 'package:postflow_server/database/tables/posts.dart';

import '../core/exceptions.dart';
import 'caption_service.dart';
import '../database/database.dart'
    show
        CaptionTemplatesDao,
        PostSchedule,
        PostWithRelations,
        PostflowDatabase,
        PostsDao,
        ScheduleDao,
        ScheduleWithDetails,
        SocialAccountTargetsDao;

class ScheduleService {
  final ScheduleDao _scheduleDao;
  final SocialAccountTargetsDao _socialAccountTargetsDao;
  final PostsDao _postsDao;
  final PostflowDatabase _db;
  final CaptionTemplatesDao _captionTemplatesDao;
  final CaptionService _captionService;

  ScheduleService({
    required ScheduleDao scheduleDao,
    required PostsDao postsDao,
    required PostflowDatabase db,
    required SocialAccountTargetsDao socialAccountTargetsDao,
    required CaptionService captionService,
    required CaptionTemplatesDao captionTemplatesDao,
  }) : _captionTemplatesDao = captionTemplatesDao,
       _captionService = captionService,
       _socialAccountTargetsDao = socialAccountTargetsDao,
       _db = db,
       _scheduleDao = scheduleDao,
       _postsDao = postsDao;

  Future<List<ScheduleWithDetails>> createSchedules({
    required UuidValue userId,
    required UuidValue postId,
    required List<CreateScheduleRequest> requests,
  }) async {
    final existingPost = await _postsDao.findPostWithRelationsById(
      postId,
      userId,
    );
    if (existingPost == null) {
      throw NotFoundException('Post not found');
    }

    return _db.transaction(() async {
      final results = List<ScheduleWithDetails>.empty(growable: true);

      for (final request in requests) {
        if (!(await _socialAccountTargetsDao.belongsToUser(
          request.socialAccountTargetId,
          userId,
        ))) {
          throw NotFoundException(
            'Social account target not found: ${request.socialAccountTargetId}',
          );
        }

        final schedule = await _scheduleDao.createSchedule(
          postId: postId,
          socialAccountTargetId: request.socialAccountTargetId,
          scheduledAt: request.scheduledAt,
        );

        if (request.templateId != null || request.captionBody != null) {
          final caption = await _resolveCaption(
            request: request,
            post: existingPost,
            scheduleId: schedule.id,
          );

          await _scheduleDao.createCaption(
            postScheduleId: schedule.id,
            renderedBody: caption,
            templateId: request.templateId,
            templateVariables: request.templateVariables,
          );
        }

        final details = await _scheduleDao.findSchedulesForPost(postId, userId);
        results.add(details.firstWhere((d) => d.schedule.id == schedule.id));
      }

      await _postsDao.updatePost(
        id: postId,
        userId: userId,
        status: PostStatus.ready,
      );

      return results;
    });
  }

  Future<List<ScheduleWithDetails>> getByPostId(
    UuidValue postId,
    UuidValue userId,
  ) async {
    final post = await _postsDao.findPostById(postId, userId);
    if (post == null) {
      throw NotFoundException('Post not found');
    }

    return _scheduleDao.findSchedulesForPost(postId, userId);
  }

  Future<PostSchedule> retrySchedule({
    required UuidValue postScheduleId,
    required UuidValue userId,
    required DateTime scheduledAt,
  }) {
    return _scheduleDao.retry(
      postScheduleId: postScheduleId,
      userId: userId,
      scheduledAt: scheduledAt,
    );
  }

  Future<void> cancelSchedule(UuidValue postScheduleId, UuidValue userId) {
    return _scheduleDao.cancel(postScheduleId, userId);
  }

  Future<String> _resolveCaption({
    required CreateScheduleRequest request,
    required PostWithRelations post,
    required UuidValue scheduleId,
  }) async {
    // user provided a body, use that
    if (request.captionBody != null) {
      return request.captionBody!;
    }

    final template = await _captionTemplatesDao.findById(request.templateId!);
    if (template == null) {
      throw NotFoundException('Template not found');
    }

    final targetDetails = await _socialAccountTargetsDao.findById(
      request.socialAccountTargetId,
    );
    if (targetDetails == null) {
      throw NotFoundException('Social account target not found');
    }

    return _captionService.renderWithCustomVariables(
      templateBody: template.body,
      post: post,
      target: targetDetails,
      customVariables: request.templateVariables?.cast<String, String>() ?? {},
    );
  }
}

class CreateScheduleRequest {
  final UuidValue socialAccountTargetId;
  final DateTime scheduledAt;
  final UuidValue? templateId;
  final String? captionBody;
  final Map<String, dynamic>? templateVariables;

  const CreateScheduleRequest({
    required this.socialAccountTargetId,
    required this.scheduledAt,
    this.templateId,
    this.captionBody,
    this.templateVariables = const {},
  });

  factory CreateScheduleRequest.fromJson(Map<String, dynamic> json) {
    return CreateScheduleRequest(
      socialAccountTargetId: UuidValue.withValidation(
        json['social_account_target_id'] as String,
      ),
      scheduledAt: DateTime.parse(json['scheduled_at'] as String).toUtc(),
      templateId: json['template_id'] != null
          ? UuidValue.withValidation(json['template_id'] as String)
          : null,
      captionBody: json['caption_body'] as String?,
      templateVariables:
          json['template_variables'] as Map<String, dynamic>? ?? {},
    );
  }
}
