import 'package:dotenv/dotenv.dart';
import 'package:get_it/get_it.dart';

import 'config/app_config.dart';
import 'services/jwt_service.dart';

final getIt = GetIt.instance;

void registerDependencies() {
  final env = DotEnv(includePlatformEnvironment: true)..load();

  getIt.registerLazySingleton<AppConfig>(() => AppConfig.fromEnvironment(env));
  getIt.registerLazySingleton<JwtService>(() => JwtService(getIt<AppConfig>()));
}
