import 'dart:convert';

import 'package:test/test.dart';
import 'package:postflow_server/config/app_config.dart';
import 'package:postflow_server/services/jwt_service.dart';

AppConfig _testConfig({
  String jwtSecret = 'test-secret-key-for-jwt-testing-purposes',
  Duration accessTtl = const Duration(minutes: 15),
}) {
  return AppConfig(
    dbName: 'test',
    dbHost: 'localhost',
    dbPort: 5432,
    dbUser: 'test',
    dbPassword: 'test',
    authenticationEnabled: true,
    jwtSecret: jwtSecret,
    jwtAccessTtl: accessTtl,
    jwtRefreshTtl: const Duration(days: 7),
  );
}

void main() {
  late JwtService jwtService;

  setUp(() {
    jwtService = JwtService(_testConfig());
  });

  group('JwtService', () {
    group('generateAccessToken', () {
      test('returns a non-empty string', () {
        final token = jwtService.generateAccessToken('user-123');
        expect(token, isNotEmpty);
      });

      test('returns different tokens for different users', () {
        final token1 = jwtService.generateAccessToken('user-1');
        final token2 = jwtService.generateAccessToken('user-2');
        expect(token1, isNot(equals(token2)));
      });

      test('returns a JWT with three parts', () {
        final token = jwtService.generateAccessToken('user-123');
        expect(token.split('.').length, equals(3));
      });
    });

    group('verifyAccessToken', () {
      test('returns userId for valid token', () {
        final token = jwtService.generateAccessToken('user-123');
        final userId = jwtService.verifyAccessToken(token);
        expect(userId, equals('user-123'));
      });

      test('returns null for invalid token string', () {
        final userId = jwtService.verifyAccessToken('invalid.token.here');
        expect(userId, isNull);
      });

      test('returns null for empty string', () {
        final userId = jwtService.verifyAccessToken('');
        expect(userId, isNull);
      });

      test('returns null for token signed with different secret', () {
        final otherService = JwtService(
          _testConfig(jwtSecret: 'different-secret-key-entirely-different'),
        );

        final token = otherService.generateAccessToken('user-123');
        final userId = jwtService.verifyAccessToken(token);
        expect(userId, isNull);
      });

      test('returns null for random string', () {
        final userId = jwtService.verifyAccessToken(
          'abc.def.ghi',
        );
        expect(userId, isNull);
      });

      test('returns correct userId for UUID format', () {
        const uuid = '550e8400-e29b-41d4-a716-446655440000';
        final token = jwtService.generateAccessToken(uuid);
        final userId = jwtService.verifyAccessToken(token);
        expect(userId, equals(uuid));
      });
    });

    group('generateRefreshToken', () {
      test('returns a non-empty string', () {
        final token = jwtService.generateRefreshToken('user-123');
        expect(token, isNotEmpty);
      });

      test('returns different tokens on each call', () {
        final token1 = jwtService.generateRefreshToken('user-123');
        final token2 = jwtService.generateRefreshToken('user-123');
        expect(token1, isNot(equals(token2)));
      });

      test('returns a valid base64-encoded string', () {
        final token = jwtService.generateRefreshToken('user-123');
        expect(() => base64Decode(token), returnsNormally);
      });

      test('decoded token is 32 bytes', () {
        final token = jwtService.generateRefreshToken('user-123');
        final bytes = base64Decode(token);
        expect(bytes.length, equals(32));
      });
    });
  });
}
