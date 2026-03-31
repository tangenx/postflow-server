import 'dart:io';

import 'package:dotenv/dotenv.dart';
import 'package:test/test.dart';
import 'package:postflow_server/config/app_config.dart';
import 'package:postflow_server/core/constants.dart';

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
        storageType: StorageType.local,
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
      expect(config.storageType, StorageType.local);
      expect(config.localStoragePath, isNull);
      expect(config.s3Endpoint, isNull);
      expect(config.s3Bucket, isNull);
      expect(config.s3Region, isNull);
      expect(config.s3AccessKey, isNull);
      expect(config.s3SecretKey, isNull);
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

      test('defaults storageType to local with null S3 fields', () {
        final config = AppConfig.fromEnvironment(_envFromContent(_baseEnv));

        expect(config.storageType, StorageType.local);
        expect(config.localStoragePath, isNull);
        expect(config.s3Endpoint, isNull);
        expect(config.s3Bucket, isNull);
        expect(config.s3Region, isNull);
        expect(config.s3AccessKey, isNull);
        expect(config.s3SecretKey, isNull);
      });

      test('parses s3 storageType and S3 fields', () {
        final config = AppConfig.fromEnvironment(
          _envFromContent('''
$_baseEnv
STORAGE_TYPE=s3
S3_ENDPOINT=http://localhost:3900
S3_BUCKET=mybucket
S3_REGION=garage
S3_ACCESS_KEY=ak
S3_SECRET_KEY=sk
LOCAL_STORAGE_PATH=/tmp/uploads
'''),
        );

        expect(config.storageType, StorageType.s3);
        expect(config.s3Endpoint, 'http://localhost:3900');
        expect(config.s3Bucket, 'mybucket');
        expect(config.s3Region, 'garage');
        expect(config.s3AccessKey, 'ak');
        expect(config.s3SecretKey, 'sk');
        expect(config.localStoragePath, '/tmp/uploads');
      });

      test('throws on invalid STORAGE_TYPE', () {
        expect(
          () => AppConfig.fromEnvironment(
            _envFromContent('''
$_baseEnv
STORAGE_TYPE=invalid
'''),
          ),
          throwsA(isA<ArgumentError>()),
        );
      });
    });
  });
}
