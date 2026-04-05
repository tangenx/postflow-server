import 'package:drift_postgres/drift_postgres.dart';
import '../services/caption_service.dart';
import 'package:shelf/shelf.dart';

import '../database/database.dart';
import '../utils/api_response.dart';
import '../utils/request_validation.dart';

class CaptionTemplateHandler {
  final CaptionTemplatesDao _captionTemplatesDao;
  final CaptionService _captionService;
  final PostsDao _postsDao;
  final SocialAccountTargetsDao _socialAccountTargetsDao;

  CaptionTemplateHandler({
    required CaptionTemplatesDao captionTemplatesDao,
    required CaptionService captionService,
    required PostsDao postsDao,
    required SocialAccountTargetsDao socialAccountTargetsDao,
  }) : _captionTemplatesDao = captionTemplatesDao,
       _captionService = captionService,
       _postsDao = postsDao,
       _socialAccountTargetsDao = socialAccountTargetsDao;

  /// GET /caption_templates
  Future<Response> getTemplates(Request request) async {
    final userId = request.context['userId'] as UuidValue;
    final templates = await _captionTemplatesDao.findForUser(userId);

    return ApiResponse.ok(templates.map((t) => t.toJson()).toList());
  }

  /// GET /caption_templates/:id
  Future<Response> getTemplate(Request request, String id) async {
    final templateId = UuidValue.withValidation(id);
    final template = await _captionTemplatesDao.findById(templateId);

    if (template == null) {
      return ApiResponse.error(404, 'NOT_FOUND', 'Template not found');
    }

    return ApiResponse.ok(template.toJson());
  }

  /// POST /caption_templates
  Future<Response> create(Request request) async {
    final data = RequestValidation.parseJsonObject(
      await request.readAsString(),
    );
    final ownerId = request.context['userId'] as UuidValue;
    final name = RequestValidation.requiredString(
      data,
      'name',
      minLength: 1,
      maxLength: 255,
    );
    final body = RequestValidation.requiredString(
      data,
      'body',
      minLength: 1,
      maxLength: 4000,
    );

    final template = await _captionTemplatesDao.create(
      ownerId: ownerId,
      name: name,
      body: body,
    );

    return ApiResponse.ok(template.toJson());
  }

  /// PUT /caption_templates/:id
  Future<Response> update(Request request, String id) async {
    final templateId = UuidValue.withValidation(id);
    final data = RequestValidation.parseJsonObject(
      await request.readAsString(),
    );
    final ownerId = request.context['userId'] as UuidValue;
    final name = RequestValidation.optionalString(data, 'name', maxLength: 255);
    final body = RequestValidation.optionalString(
      data,
      'body',
      maxLength: 4000,
    );

    final template = await _captionTemplatesDao.updateTemplate(
      id: templateId,
      ownerId: ownerId,
      name: name,
      body: body,
    );

    return ApiResponse.ok(template.toJson());
  }

  /// DELETE /caption_templates/:id
  Future<Response> delete(Request request, String id) async {
    final templateId = UuidValue.withValidation(id);
    final ownerId = request.context['userId'] as UuidValue;
    await _captionTemplatesDao.deleteTemplate(templateId, ownerId);

    return ApiResponse.ok(null);
  }

  /// GET /caption_templates/:id/render
  /// renders a template with the given variables
  /// { "post_id": "uuid", "target_id": "uuid", "overrides": {} }
  Future<Response> render(Request request, String id) async {
    final userId = request.context['userId'] as UuidValue;

    final body = RequestValidation.parseJsonObject(
      await request.readAsString(),
    );

    final templateId = UuidValue.withValidation(id);
    final template = await _captionTemplatesDao.findById(templateId);
    if (template == null) {
      return ApiResponse.error(404, 'NOT_FOUND', 'Template not found');
    }

    final socialAccountTarget = await _socialAccountTargetsDao.findById(
      UuidValue.withValidation(body['targetId']),
    );
    if (socialAccountTarget == null) {
      return ApiResponse.error(404, 'NOT_FOUND', 'Target not found');
    }

    final post = await _postsDao.findPostWithRelationsById(
      UuidValue.withValidation(body['postId']),
      userId,
    );
    if (post == null) {
      return ApiResponse.error(404, 'NOT_FOUND', 'Post not found');
    }

    final overrides = RequestValidation.parseJsonObject(
      body['overrides'] as String,
    );

    final render = _captionService.renderWithCustomVariables(
      templateBody: template.body,
      post: post,
      target: socialAccountTarget,
      customVariables: overrides.cast<String, Object>(),
    );

    return ApiResponse.ok(render);
  }
}
