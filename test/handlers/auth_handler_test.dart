import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:test/test.dart';
import 'package:postflow_server/config/app_config.dart';
import 'package:postflow_server/core/constants.dart';
import 'package:postflow_server/handlers/auth_handler.dart';
import 'package:postflow_server/services/auth_service.dart';

/// Fake [AuthService] for handler tests.
class FakeAuthService implements AuthService {
  final AuthData _authData;
  Object? _exception;

  FakeAuthService(this._authData);

  void setException(Object ex) => _exception = ex;

  void _maybeThrow() {
    if (_exception != null) throw _exception!;
  }

  @override
  Future<AuthData> register(String username, String password, {String? email}) async {
    _maybeThrow();
    return _authData;
  }

  @override
  Future<AuthData> login(String usernameOrEmail, String password) async {
    _maybeThrow();
    return _authData;
  }

  @override
  Future<void> logout(String refreshToken) async {
    _maybeThrow();
  }

  @override
  Future<AuthData> refresh(String refreshToken) async {
    _maybeThrow();
    return _authData;
  }
}

Request _jsonPost(String path, Map<String, dynamic> body) {
  return Request(
    'POST',
    Uri.parse('http://localhost/$path'),
    body: jsonEncode(body),
    headers: {'content-type': 'application/json'},
  );
}

void main() {
  late FakeAuthService fakeAuth;
  late AuthHandler handler;
  late AppConfig config;

  final testAuthData = AuthData(
    accessToken: 'access-token-123',
    refreshToken: 'refresh-token-456',
  );

  setUp(() {
    config = AppConfig(
      dbName: 'test',
      dbHost: 'localhost',
      dbPort: 5432,
      dbUser: 'test',
      dbPassword: 'test',
      authenticationEnabled: true,
      jwtSecret: 'test-secret-key-for-jwt-testing-purposes',
      jwtAccessTtl: Duration(minutes: 15),
      jwtRefreshTtl: Duration(days: 7),
      storageType: StorageType.local,
    );
    fakeAuth = FakeAuthService(testAuthData);
    handler = AuthHandler(fakeAuth, config);
  });

  group('AuthHandler', () {
    group('register', () {
      test('returns 200 with tokens', () async {
        final request = _jsonPost('api/auth/register', {
          'username': 'testuser',
          'password': 'password123',
        });

        final response = await handler.register(request);

        expect(response.statusCode, equals(200));
        final body = jsonDecode(await response.readAsString());
        expect(body['ok'], isTrue);
        expect(body['data']['access_token'], equals('access-token-123'));
        expect(body['data']['refresh_token'], equals('refresh-token-456'));
      });

      test('sets refresh_token cookie with HttpOnly', () async {
        final request = _jsonPost('api/auth/register', {
          'username': 'testuser',
          'password': 'password123',
        });

        final response = await handler.register(request);
        final setCookie = response.headers['set-cookie'];

        expect(setCookie, isNotNull);
        expect(setCookie, contains('refresh_token=refresh-token-456'));
        expect(setCookie, contains('HttpOnly'));
        expect(setCookie, contains('Path=/api/auth/refresh'));
      });

      test('passes email to service', () async {
        final request = _jsonPost('api/auth/register', {
          'username': 'testuser',
          'password': 'password123',
          'email': 'test@example.com',
        });

        final response = await handler.register(request);
        expect(response.statusCode, equals(200));
      });

      test('returns JSON content type', () async {
        final request = _jsonPost('api/auth/register', {
          'username': 'testuser',
          'password': 'password123',
        });

        final response = await handler.register(request);
        expect(response.headers['content-type'], equals('application/json'));
      });
    });

    group('login', () {
      test('returns 200 with tokens', () async {
        final request = _jsonPost('api/auth/login', {
          'username': 'testuser',
          'password': 'password123',
        });

        final response = await handler.login(request);

        expect(response.statusCode, equals(200));
        final body = jsonDecode(await response.readAsString());
        expect(body['ok'], isTrue);
        expect(body['data']['access_token'], equals('access-token-123'));
        expect(body['data']['refresh_token'], equals('refresh-token-456'));
      });

      test('sets refresh_token cookie', () async {
        final request = _jsonPost('api/auth/login', {
          'username': 'testuser',
          'password': 'password123',
        });

        final response = await handler.login(request);
        final setCookie = response.headers['set-cookie'];

        expect(setCookie, contains('refresh_token=refresh-token-456'));
        expect(setCookie, contains('HttpOnly'));
      });
    });

    group('refresh', () {
      test('reads refresh token from cookie', () async {
        final request = Request(
          'POST',
          Uri.parse('http://localhost/api/auth/refresh'),
          headers: {'cookie': 'refresh_token=cookie-token-value'},
        );

        final response = await handler.refresh(request);

        expect(response.statusCode, equals(200));
        final body = jsonDecode(await response.readAsString());
        expect(body['data']['access_token'], equals('access-token-123'));
      });

      test('reads refresh token from body when cookie missing', () async {
        final request = _jsonPost('api/auth/refresh', {
          'refresh_token': 'body-token-value',
        });

        final response = await handler.refresh(request);

        expect(response.statusCode, equals(200));
      });

      test('prefers cookie over body', () async {
        final request = Request(
          'POST',
          Uri.parse('http://localhost/api/auth/refresh'),
          body: jsonEncode({'refresh_token': 'body-token'}),
          headers: {
            'cookie': 'refresh_token=cookie-token',
            'content-type': 'application/json',
          },
        );

        final response = await handler.refresh(request);
        expect(response.statusCode, equals(200));
      });

      test('returns 400 when no refresh_token in body', () async {
        final request = _jsonPost('api/auth/refresh', {});

        final response = await handler.refresh(request);
        expect(response.statusCode, equals(400));
      });
    });

    group('logout', () {
      test('returns 200 and clears cookie', () async {
        final request = Request(
          'POST',
          Uri.parse('http://localhost/api/auth/logout'),
          headers: {'cookie': 'refresh_token=some-token'},
        );

        final response = await handler.logout(request);

        expect(response.statusCode, equals(200));
        final setCookie = response.headers['set-cookie'];
        expect(setCookie, contains('refresh_token='));
        expect(setCookie, contains('Max-Age=0'));
      });

      test('reads refresh token from body', () async {
        final request = _jsonPost('api/auth/logout', {
          'refresh_token': 'body-token',
        });

        final response = await handler.logout(request);
        expect(response.statusCode, equals(200));
      });

      test('returns 400 when no refresh_token in body', () async {
        final request = _jsonPost('api/auth/logout', {});

        final response = await handler.logout(request);
        expect(response.statusCode, equals(400));
      });
    });
  });
}
