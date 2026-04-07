import 'package:dotenv/dotenv.dart';

import '../core/constants.dart';

class AppConfig {
  final String dbName;
  final String dbHost;
  final int dbPort;
  final String dbUser;
  final String dbPassword;
  final bool authenticationEnabled;
  final String jwtSecret;
  final Duration jwtAccessTtl;
  final Duration jwtRefreshTtl;
  final StorageType storageType; // local / s3
  final String? localStoragePath;
  final String? s3Endpoint;
  final String? s3Bucket;
  final String? s3Region;
  final String? s3AccessKey;
  final String? s3SecretKey;
  final Duration schedulerCheckInterval;
  final Duration mediaOrphanTtl;

  const AppConfig({
    required this.dbName,
    required this.dbHost,
    required this.dbPort,
    required this.dbUser,
    required this.dbPassword,
    required this.authenticationEnabled,
    required this.jwtSecret,
    required this.jwtAccessTtl,
    required this.jwtRefreshTtl,
    required this.storageType,
    this.localStoragePath,
    this.s3Bucket,
    this.s3Region,
    this.s3AccessKey,
    this.s3SecretKey,
    this.s3Endpoint,
    required this.schedulerCheckInterval,
    required this.mediaOrphanTtl,
  });

  factory AppConfig.fromEnvironment(DotEnv env) {
    String getValue(String key, {String? fallback}) {
      final value = env[key] ?? fallback;

      if (value == null) {
        throw StateError('Missing required env variable: $key');
      }

      return value;
    }

    return AppConfig(
      dbName: getValue('DB_NAME'),
      dbHost: getValue('DB_HOST', fallback: 'postflow-db'),
      dbPort: int.parse(getValue('DB_PORT', fallback: '5432')),
      dbUser: getValue('DB_USER'),
      dbPassword: getValue('DB_PASSWORD'),
      authenticationEnabled: getValue('AUTHENTICATION_ENABLED') == 'true',
      jwtSecret: getValue('JWT_SECRET'),
      jwtAccessTtl: Duration(
        seconds: int.parse(getValue('JWT_ACCESS_TTL', fallback: '1800')),
      ),
      jwtRefreshTtl: Duration(
        days: int.parse(getValue('JWT_REFRESH_TTL', fallback: '604800')),
      ),
      storageType: StorageType.values.byName(
        getValue('STORAGE_TYPE', fallback: 'local'),
      ),
      localStoragePath: env['LOCAL_STORAGE_PATH'],
      s3Endpoint: env['S3_ENDPOINT'],
      s3Bucket: env['S3_BUCKET'],
      s3Region: env['S3_REGION'],
      s3AccessKey: env['S3_ACCESS_KEY'],
      s3SecretKey: env['S3_SECRET_KEY'],
      schedulerCheckInterval: Duration(
        seconds: int.parse(
          getValue('SCHEDULER_CHECK_INTERVAL', fallback: '30'),
        ),
      ),
      mediaOrphanTtl: Duration(
        hours: int.parse(getValue('MEDIA_ORPHAN_TTL_HOURS', fallback: '24')),
      ),
    );
  }
}
