import 'package:drift_postgres/drift_postgres.dart';
import 'package:shelf/shelf.dart';

import '../core/exceptions.dart';
import '../database/database.dart';
import '../utils/api_response.dart';
import '../utils/request_validation.dart';

class UserHandler {
  final UserSettingsDao _userSettingsDao;

  UserHandler(this._userSettingsDao);

  /// GET /user
  Future<Response> getSettings(Request request) async {
    final userId = _requireUserId(request);
    var settings = await _userSettingsDao.getByUserId(userId);

    settings ??= await _userSettingsDao.create(userId);

    return ApiResponse.ok(settings.toJson());
  }

  /// PUT /user
  Future<Response> updateSettings(Request request) async {
    final userId = _requireUserId(request);
    final data = RequestValidation.parseJsonObject(
      await request.readAsString(),
    );
    final saucenaoApiKey = RequestValidation.optionalString(
      data,
      'saucenaoApiKey',
      maxLength: 512,
    );

    final existing = await _userSettingsDao.getByUserId(userId);
    if (existing == null) {
      await _userSettingsDao.create(userId);
    }

    final updated = await _userSettingsDao.updateSettings(
      userId: userId,
      saucenaoApiKey: saucenaoApiKey,
    );

    return ApiResponse.ok(updated.toJson());
  }

  UuidValue _requireUserId(Request request) {
    final userId = request.context['user-id'];
    if (userId is! UuidValue) {
      throw UnauthorizedException('Missing authenticated user');
    }

    return userId;
  }
}
