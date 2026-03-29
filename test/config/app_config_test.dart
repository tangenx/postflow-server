import 'dart:io';

import 'package:dotenv/dotenv.dart';
import 'package:test/test.dart';
import 'package:postflow_server/config/app_config.dart';

/// Creates a [DotEnv] loaded from a temporary file with the given [content].
DotEnv _envFromContent(String content) {
  final dir = Directory.systemTemp.createTempSync('postflow_test_');
  addTearDown(() => dir.deleteSync(recursive: true));
  final file = File('${dir.path}/.env')..writeAsStringSync(content);
  final env = DotEnv();
  env.load([file.path]);
  return env;
}

const _baseEnv = '''
DB_NAME=testdb
DB_USER=testuser
DB_PASSWORD=testpass
JWT_SECRET=test-jwt-secret-key-for-testing
AUTHENTICATION_ENABLED=true
''';

void main() {
  group('AppConfig', () {
    test('const constructor stores all fields', () {
      final config = AppConfig(
        dbName: 'testdb',
        dbHost: 'localhost',
        dbPort: 5432,
        dbUser: 'user',
        dbPassword: 'pass',
        authenticationEnabled: true,
        jwtSecret: 'secret',
        jwtAccessTtl: Duration(minutes: 15),
        jwtRefreshTtl: Duration(days: 7),
      );

      expect(config.dbName, 'testdb');
      expect(config.dbHost, 'localhost');
      expect(config.dbPort, 5432);
      expect(config.dbUser, 'user');
      expect(config.dbPassword, 'pass');
      expect(config.authenticationEnabled, isTrue);
      expect(config.jwtSecret, 'secret');
      expect(config.jwtAccessTtl, Duration(minutes: 15));
      expect(config.jwtRefreshTtl, Duration(days: 7));
    });

    group('fromEnvironment', () {
      test('creates config from environment variables', () {
        final config = AppConfig.fromEnvironment(_envFromContent(_baseEnv));

        expect(config.dbName, 'testdb');
        expect(config.dbUser, 'testuser');
        expect(config.dbPassword, 'testpass');
        expect(config.jwtSecret, 'test-jwt-secret-key-for-testing');
        expect(config.authenticationEnabled, isTrue);
      });

      test('uses defaults for optional values', () {
        final config = AppConfig.fromEnvironment(_envFromContent(_baseEnv));

        expect(config.dbHost, 'postflow-db');
        expect(config.dbPort, 5432);
        expect(config.jwtAccessTtl, Duration(seconds: 1800));
        // JWT_REFRESH_TTL default 604800 is parsed as days
        expect(config.jwtRefreshTtl, Duration(days: 604800));
      });

      test('overrides defaults when values provided', () {
        final config = AppConfig.fromEnvironment(
          _envFromContent('''
$_baseEnv
DB_HOST=custom-host
DB_PORT=3306
JWT_ACCESS_TTL=3600
'''),
        );

        expect(config.dbHost, 'custom-host');
        expect(config.dbPort, 3306);
        expect(config.jwtAccessTtl, Duration(seconds: 3600));
      });

      test('throws StateError on missing required DB_NAME', () {
        expect(
          () => AppConfig.fromEnvironment(
            _envFromContent('''
DB_USER=user
DB_PASSWORD=pass
JWT_SECRET=secret
AUTHENTICATION_ENABLED=true
'''),
          ),
          throwsA(isA<StateError>()),
        );
      });

      test('throws StateError on missing required JWT_SECRET', () {
        expect(
          () => AppConfig.fromEnvironment(
            _envFromContent('''
DB_NAME=db
DB_USER=user
DB_PASSWORD=pass
AUTHENTICATION_ENABLED=true
'''),
          ),
          throwsA(isA<StateError>()),
        );
      });

      test('parses authenticationEnabled as false', () {
        final config = AppConfig.fromEnvironment(
          _envFromContent('''
DB_NAME=testdb
DB_USER=testuser
DB_PASSWORD=testpass
JWT_SECRET=test-jwt-secret
AUTHENTICATION_ENABLED=false
'''),
        );

        expect(config.authenticationEnabled, isFalse);
      });
    });
  });
}
