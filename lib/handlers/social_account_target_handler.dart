import 'package:drift_postgres/drift_postgres.dart';
import 'package:shelf/shelf.dart';

import '../database/database.dart';
import '../utils/api_response.dart';
import '../utils/request_validation.dart';

class SocialAccountTargetHandler {
  final SocialAccountTargetsDao _socialAccountTargetsDao;
  final UserSocialAccountsDao _accountsDao;

  SocialAccountTargetHandler({
    required SocialAccountTargetsDao socialAccountTargetsDao,
    required UserSocialAccountsDao accountsDao,
  }) : _socialAccountTargetsDao = socialAccountTargetsDao,
       _accountsDao = accountsDao;

  /// GET /api/social-accounts/:accountId/targets
  Future<Response> getTargets(Request request, String accountId) async {
    final userId = request.context['userId'] as UuidValue;
    final validatedAccountId = UuidValue.withValidation(accountId);

    final account = await _accountsDao.findByIdAndUser(
      validatedAccountId,
      userId,
    );
    if (account == null) {
      return ApiResponse.error(404, 'NOT_FOUND', 'Account not found');
    }

    final targets = await _socialAccountTargetsDao.findByAccount(
      validatedAccountId,
    );

    return ApiResponse.ok(targets.map((t) => t.toJson()).toList());
  }

  /// POST /api/social-accounts/:accountId/targets
  /// { "targetType": "channel", "targetId": "-1001758061942", "targetLabel": "Xvvxzds", "shortLink": "xvvzxds" }
  Future<Response> create(Request request, String accountId) async {
    final userId = request.context['userId'] as UuidValue;
    final validatedAccountId = UuidValue.withValidation(accountId);

    final account = await _accountsDao.findByIdAndUser(
      validatedAccountId,
      userId,
    );
    if (account == null) {
      return ApiResponse.error(404, 'NOT_FOUND', 'Account not found');
    }

    final data = RequestValidation.parseJsonObject(
      await request.readAsString(),
    );

    final targetType = RequestValidation.requiredSocialAccountTargetType(
      data,
      'targetType',
    );
    final targetId = RequestValidation.requiredString(
      data,
      'targetId',
      minLength: 1,
      maxLength: 255,
    );
    final targetLabel = RequestValidation.optionalString(
      data,
      'targetLabel',
      maxLength: 255,
    );
    final shortLink = RequestValidation.optionalString(
      data,
      'shortLink',
      maxLength: 255,
    );

    final target = await _socialAccountTargetsDao.create(
      userSocialAccountId: validatedAccountId,
      targetType: targetType,
      targetId: targetId,
      targetLabel: targetLabel,
      shortLink: shortLink,
    );

    return ApiResponse.ok(target.toJson());
  }

  /// PUT /api/social-accounts/targets/:targetId
  Future<Response> update(
    Request request,
    String accountId,
    String targetId,
  ) async {
    final userId = request.context['userId'] as UuidValue;
    final validatedTargetId = UuidValue.withValidation(targetId);

    final data = RequestValidation.parseJsonObject(
      await request.readAsString(),
    );

    if (data['targetType'] != null) {
      RequestValidation.requiredSocialAccountTargetType(data, 'targetType');
    }

    final target = await _socialAccountTargetsDao.updateTarget(
      id: validatedTargetId,
      userId: userId,
      targetLabel: RequestValidation.optionalString(
        data,
        'targetLabel',
        maxLength: 255,
      ),
      shortLink: RequestValidation.optionalString(
        data,
        'shortLink',
        maxLength: 255,
      ),
      isActive: RequestValidation.optionalBool(data, 'isActive'),
    );

    return ApiResponse.ok(target.toJson());
  }

  /// DELETE /api/social-accounts/targets/:targetId
  Future<Response> delete(Request request, String id) async {
    final userId = request.context['userId'] as UuidValue;
    final validatedTargetId = UuidValue.withValidation(id);

    await _socialAccountTargetsDao.deleteTarget(validatedTargetId, userId);

    return ApiResponse.ok(null);
  }
}
