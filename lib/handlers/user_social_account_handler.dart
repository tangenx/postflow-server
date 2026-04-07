import 'package:drift_postgres/drift_postgres.dart';
import 'package:shelf/shelf.dart';

import '../database/database.dart';
import '../services/user_social_account_service.dart';
import '../utils/api_response.dart';
import '../utils/request_validation.dart';

class UserSocialAccountHandler {
  final UserSocialAccountService _service;

  UserSocialAccountHandler(this._service);

  /// GET /api/social-accounts
  Future<Response> getAccounts(Request request) async {
    final userId = request.context['userId'] as UuidValue;
    final accounts = await _service.getAccounts(userId);

    return ApiResponse.ok(accounts.map((a) => a.toJson()).toList());
  }

  /// GET /api/social-accounts/:id
  Future<Response> getAccount(Request request, String id) async {
    final userId = request.context['userId'] as UuidValue;
    final accountId = UuidValue.withValidation(id);
    final account = await _service.getAccount(accountId, userId);

    if (account == null) {
      return ApiResponse.error(404, 'NOT_FOUND', 'Account not found');
    }

    return ApiResponse.ok(account.toSafeJson());
  }

  /// POST /api/social-accounts
  /// {
  ///   "socialNetworkId": "00000000-0000-0000-0000-000000000001",
  ///   "accessToken": "1234567890",
  ///   "refreshToken": "1234567890",
  ///   "tokenExpiresAt": "2026-01-01T00:00:00.000Z",
  /// }
  Future<Response> create(Request request) async {
    final userId = request.context['userId'] as UuidValue;
    final data = RequestValidation.parseJsonObject(
      await request.readAsString(),
    );

    final account = await _service.create(
      userId: userId,
      socialNetworkId: UuidValue.withValidation(data['socialNetworkId']),
      accessToken: data['accessToken'],
      refreshToken: data['refreshToken'],
      tokenExpiresAt: data['tokenExpiresAt'] != null
          ? DateTime.parse(data['tokenExpiresAt'])
          : null,
    );

    return ApiResponse.ok(account.toSafeJson());
  }

  /// PUT /api/social-accounts/:id
  /// {
  ///   "screenName": "tangenx",
  ///   "accessToken": "1234567890",
  ///   "refreshToken": "1234567890",
  ///   "tokenExpiresAt": "2026-01-01T00:00:00.000Z",
  ///   "isActive": true
  /// }
  Future<Response> update(Request request, String id) async {
    final userId = request.context['userId'] as UuidValue;
    final accountId = UuidValue.withValidation(id);
    final data = RequestValidation.parseJsonObject(
      await request.readAsString(),
    );

    final account = await _service.update(
      id: accountId,
      userId: userId,
      screenName: data['screenName'],
      accessToken: data['accessToken'],
      refreshToken: data['refreshToken'],
      tokenExpiresAt: data['tokenExpiresAt'] != null
          ? DateTime.parse(data['tokenExpiresAt'])
          : null,
      isActive: data['isActive'],
    );

    return ApiResponse.ok(account.toSafeJson());
  }

  /// DELETE /api/social-accounts/:id
  Future<Response> delete(Request request, String id) async {
    final userId = request.context['userId'] as UuidValue;
    final accountId = UuidValue.withValidation(id);
    await _service.delete(accountId, userId);

    return ApiResponse.ok(null);
  }
}
