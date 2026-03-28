import 'dart:convert';

import 'package:postflow_server/utils/extract_cookie.dart';
import 'package:shelf/shelf.dart';

import '../config/app_config.dart';
import '../services/auth_service.dart';

class AuthHandler {
  final AuthService _authService;
  final AppConfig _config;

  AuthHandler(this._authService, this._config);

  Future<Response> register(Request request) async {
    final body = await request.readAsString();
    final data = jsonDecode(body);

    final authData = await _authService.register(
      data['username'],
      data['password'],
      email: data['email'],
    );

    return _authResponse(authData);
  }

  Future<Response> login(Request request) async {
    final body = await request.readAsString();
    final data = jsonDecode(body);

    final authData = await _authService.login(
      data['username'],
      data['password'],
    );

    return _authResponse(authData);
  }

  Future<Response> refresh(Request request) async {
    final cookie = request.headers['cookie'];
    String? refreshToken = extractCookie(cookie, 'refresh_token');

    if (refreshToken == null) {
      final body = await request.readAsString();
      final data = jsonDecode(body);

      refreshToken = data['refresh_token'];
    }

    if (refreshToken == null) {
      return Response.badRequest(body: 'Missing refresh token');
    }

    final authData = await _authService.refresh(refreshToken);
    return _authResponse(authData);
  }

  Future<Response> logout(Request request) async {
    final cookie = request.headers['cookie'];
    String? refreshToken = extractCookie(cookie, 'refresh_token');

    if (refreshToken == null) {
      final body = await request.readAsString();
      final data = jsonDecode(body);

      refreshToken = data['refresh_token'];
    }

    if (refreshToken == null) {
      return Response.badRequest(body: 'Missing refresh token');
    }

    await _authService.logout(refreshToken);

    return Response.ok(
      'logged out',
      headers: {
        'set-cookie': ['refresh_token=', 'Max-Age=0', 'Path=/'].join('; '),
      },
    );
  }

  // Helper
  Response _authResponse(AuthData authData) {
    return Response.ok(
      jsonEncode({
        'access_token': authData.accessToken,
        'refresh_token': authData.refreshToken,
      }),
      headers: {
        "content-type": "application/json",
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
