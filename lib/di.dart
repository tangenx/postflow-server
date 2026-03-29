import 'package:dotenv/dotenv.dart';
import 'package:get_it/get_it.dart';

import 'config/app_config.dart';
import 'database/database.dart';
import 'handlers/auth_handler.dart';
import 'services/auth_service.dart';
import 'services/jwt_service.dart';

final sl = GetIt.instance;

void registerDependencies() {
  final env = DotEnv(includePlatformEnvironment: true)..load();

  // config
  sl.registerSingleton<AppConfig>((AppConfig.fromEnvironment(env)));
  sl.registerSingleton<PostflowDatabase>(PostflowDatabase());

  // daos
  sl.registerSingleton<RefreshTokensDao>(
    RefreshTokensDao(sl.get<PostflowDatabase>()),
  );
  sl.registerSingleton<UsersDao>(UsersDao(sl.get<PostflowDatabase>()));
  sl.registerSingleton<UserIdentitiesDao>(
    UserIdentitiesDao(sl.get<PostflowDatabase>()),
  );

  // services
  sl.registerSingleton<JwtService>(JwtService(sl<AppConfig>()));
  sl.registerSingleton<AuthService>(
    AuthService(
      userIdentitiesDao: sl<UserIdentitiesDao>(),
      jwtService: sl<JwtService>(),
      usersDao: sl<UsersDao>(),
      refreshTokensDao: sl<RefreshTokensDao>(),
      config: sl<AppConfig>(),
    ),
  );

  // handlers
  sl.registerSingleton<AuthHandler>(
    AuthHandler(sl<AuthService>(), sl<AppConfig>()),
  );
}
