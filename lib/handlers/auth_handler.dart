import 'package:postflow_server/utils/extract_cookie.dart';
import 'package:shelf/shelf.dart';

import '../config/app_config.dart';
import '../services/auth_service.dart';
import '../utils/api_response.dart';
import '../utils/request_validation.dart';

class AuthHandler {
  final AuthService _authService;
  final AppConfig _config;

  AuthHandler(this._authService, this._config);

  /// POST /auth/register
  Future<Response> register(Request request) async {
    final data = RequestValidation.parseJsonObject(
      await request.readAsString(),
    );
    final username = RequestValidation.requiredString(
      data,
      'username',
      minLength: 3,
      maxLength: 64,
    );
    final password = RequestValidation.requiredString(
      data,
      'password',
      minLength: 8,
      maxLength: 256,
    );
    final email = RequestValidation.optionalString(
      data,
      'email',
      maxLength: 320,
    );

    final authData = await _authService.register(
      username,
      password,
      email: email,
    );

    return _authResponse(authData);
  }

  /// POST /auth/login
  Future<Response> login(Request request) async {
    final data = RequestValidation.parseJsonObject(
      await request.readAsString(),
    );
    final username = RequestValidation.requiredString(
      data,
      'username',
      minLength: 3,
      maxLength: 64,
    );
    final password = RequestValidation.requiredString(
      data,
      'password',
      minLength: 8,
      maxLength: 256,
    );

    final authData = await _authService.login(username, password);

    return _authResponse(authData);
  }

  /// POST /auth/refresh
  Future<Response> refresh(Request request) async {
    final cookie = request.headers['cookie'];
    String? refreshToken = extractCookie(cookie, 'refresh_token');

    if (refreshToken == null) {
      final data = RequestValidation.parseJsonObject(
        await request.readAsString(),
      );
      refreshToken = RequestValidation.optionalString(data, 'refresh_token');
    }

    if (refreshToken == null) {
      return Response.badRequest(body: 'Missing refresh token');
    }

    final authData = await _authService.refresh(refreshToken);
    return _authResponse(authData);
  }

  /// POST /auth/logout
  Future<Response> logout(Request request) async {
    final cookie = request.headers['cookie'];
    String? refreshToken = extractCookie(cookie, 'refresh_token');

    if (refreshToken == null) {
      final data = RequestValidation.parseJsonObject(
        await request.readAsString(),
      );
      refreshToken = RequestValidation.optionalString(data, 'refresh_token');
    }

    if (refreshToken == null) {
      return Response.badRequest(body: 'Missing refresh token');
    }

    await _authService.logout(refreshToken);

    return ApiResponse.ok(
      null,
      headers: {
        'set-cookie': ['refresh_token=', 'Max-Age=0', 'Path=/'].join('; '),
      },
    );
  }

  // Helper
  Response _authResponse(AuthData authData) {
    return ApiResponse.ok(
      {
        'access_token': authData.accessToken,
        'refresh_token': authData.refreshToken,
      },
      headers: {
        "set-cookie": [
          'refresh_token=${authData.refreshToken}',
          'Max-Age=${_config.jwtRefreshTtl.inSeconds}',
          'Path=/api/auth/refresh',
          'HttpOnly',
        ].join('; '),
      },
    );
  }
}
