import 'package:drift_postgres/drift_postgres.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';
import 'package:postflow_server/config/app_config.dart';
import 'package:postflow_server/middlewares/auth_middleware.dart';
import 'package:postflow_server/services/jwt_service.dart';

AppConfig _testConfig({bool authEnabled = true}) {
  return AppConfig(
    dbName: 'test',
    dbHost: 'localhost',
    dbPort: 5432,
    dbUser: 'test',
    dbPassword: 'test',
    authenticationEnabled: authEnabled,
    jwtSecret: 'test-secret-key-for-jwt-testing-purposes',
    jwtAccessTtl: const Duration(minutes: 15),
    jwtRefreshTtl: const Duration(days: 7),
  );
}

Request _request(String path, {String? authHeader}) {
  final headers = <String, String>{};
  if (authHeader != null) headers['authorization'] = authHeader;
  return Request('GET', Uri.parse('http://localhost/$path'), headers: headers);
}

void main() {
  late JwtService jwtService;

  setUp(() {
    jwtService = JwtService(_testConfig());
  });

  group('authMiddleware', () {
    test('skips auth for health route', () async {
      final middleware = authMiddleware(_testConfig(), jwtService);
      final handler = middleware((r) => Future.value(Response.ok('ok')));

      final response = await handler(_request('health'));
      expect(response.statusCode, equals(200));
    });

    test('skips auth for api/auth/login', () async {
      final middleware = authMiddleware(_testConfig(), jwtService);
      final handler = middleware((r) => Future.value(Response.ok('ok')));

      final response = await handler(_request('api/auth/login'));
      expect(response.statusCode, equals(200));
    });

    test('skips auth for api/auth/register', () async {
      final middleware = authMiddleware(_testConfig(), jwtService);
      final handler = middleware((r) => Future.value(Response.ok('ok')));

      final response = await handler(_request('api/auth/register'));
      expect(response.statusCode, equals(200));
    });

    test('skips auth for api/auth/refresh', () async {
      final middleware = authMiddleware(_testConfig(), jwtService);
      final handler = middleware((r) => Future.value(Response.ok('ok')));

      final response = await handler(_request('api/auth/refresh'));
      expect(response.statusCode, equals(200));
    });

    test('returns 401 for missing auth header on protected route', () async {
      final middleware = authMiddleware(_testConfig(), jwtService);
      final handler = middleware((r) => Future.value(Response.ok('ok')));

      final response = await handler(_request('api/posts'));
      expect(response.statusCode, equals(401));
    });

    test('returns 401 for invalid Bearer token', () async {
      final middleware = authMiddleware(_testConfig(), jwtService);
      final handler = middleware((r) => Future.value(Response.ok('ok')));

      final response = await handler(
        _request('api/posts', authHeader: 'Bearer invalid.token'),
      );
      expect(response.statusCode, equals(401));
    });

    test('returns 401 for header without Bearer prefix', () async {
      final middleware = authMiddleware(_testConfig(), jwtService);
      final handler = middleware((r) => Future.value(Response.ok('ok')));

      final response = await handler(
        _request('api/posts', authHeader: 'Token sometoken'),
      );
      expect(response.statusCode, equals(401));
    });

    test('passes valid token and injects user-id into context', () async {
      final middleware = authMiddleware(_testConfig(), jwtService);

      UuidValue? capturedUserId;
      Future<Response> testHandler(Request request) async {
        capturedUserId = request.context['user-id'] as UuidValue?;
        return Response.ok('ok');
      }

      final handler = middleware(testHandler);
      const uuid = '550e8400-e29b-41d4-a716-446655440000';
      final token = jwtService.generateAccessToken(uuid);

      final response = await handler(
        _request('api/posts', authHeader: 'Bearer $token'),
      );

      expect(response.statusCode, equals(200));
      expect(capturedUserId, isNotNull);
      expect(capturedUserId.toString(), equals(uuid));
    });

    test('injects zero UUID when authentication is disabled', () async {
      final config = _testConfig(authEnabled: false);
      final middleware = authMiddleware(config, jwtService);

      UuidValue? capturedUserId;
      Future<Response> testHandler(Request request) async {
        capturedUserId = request.context['user-id'] as UuidValue?;
        return Response.ok('ok');
      }

      final handler = middleware(testHandler);
      final response = await handler(_request('api/posts'));

      expect(response.statusCode, equals(200));
      expect(capturedUserId, isNotNull);
      expect(
        capturedUserId.toString(),
        equals('00000000-0000-0000-0000-000000000000'),
      );
    });
  });
}
