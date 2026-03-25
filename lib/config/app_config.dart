import 'package:dotenv/dotenv.dart';

class AppConfig {
  final String dbName;
  final String dbHost;
  final int dbPort;
  final String dbUser;
  final String dbPassword;
  final bool authenticationEnabled;

  const AppConfig({
    required this.dbName,
    required this.dbHost,
    required this.dbPort,
    required this.dbUser,
    required this.dbPassword,
    required this.authenticationEnabled,
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
    );
  }
}
