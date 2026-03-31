import 'package:dotenv/dotenv.dart';
import 'package:get_it/get_it.dart';

import 'config/app_config.dart';
import 'core/constants.dart';
import 'database/database.dart';
import 'handlers/artist_handler.dart';
import 'handlers/auth_handler.dart';
import 'handlers/character_handler.dart';
import 'handlers/franchise_handler.dart';
import 'handlers/user_handler.dart';
import 'services/auth_service.dart';
import 'services/jwt_service.dart';
import 'services/storage/local_storage_service.dart';
import 'services/storage/remote_storage_service.dart';
import 'services/storage/s3_storage_service.dart';
import 'services/storage/storage_service.dart';

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
  sl.registerSingleton<UserSettingsDao>(
    UserSettingsDao(sl.get<PostflowDatabase>()),
  );
  sl.registerSingleton<ArtistsDao>(ArtistsDao(sl.get<PostflowDatabase>()));
  sl.registerSingleton<CharactersDao>(
    CharactersDao(sl.get<PostflowDatabase>()),
  );
  sl.registerSingleton<FranchisesDao>(
    FranchisesDao(sl.get<PostflowDatabase>()),
  );

  // services
  sl.registerSingleton<JwtService>(JwtService(sl.get<AppConfig>()));
  sl.registerSingleton<AuthService>(
    AuthService(
      userIdentitiesDao: sl.get<UserIdentitiesDao>(),
      jwtService: sl.get<JwtService>(),
      usersDao: sl.get<UsersDao>(),
      userSettingsDao: sl.get<UserSettingsDao>(),
      refreshTokensDao: sl.get<RefreshTokensDao>(),
      config: sl.get<AppConfig>(),
    ),
  );
  sl.registerLazySingleton<StorageService>(
    () => switch (sl.get<AppConfig>().storageType) {
      StorageType.local => LocalStorageService(sl.get<AppConfig>()),
      StorageType.s3 => S3StorageService(sl.get<AppConfig>()),
      StorageType.remote => RemoteStorageService(),
    },
  );

  // handlers
  sl.registerSingleton<AuthHandler>(
    AuthHandler(sl.get<AuthService>(), sl.get<AppConfig>()),
  );
  sl.registerSingleton<ArtistHandler>(ArtistHandler(sl.get<ArtistsDao>()));
  sl.registerSingleton<CharacterHandler>(
    CharacterHandler(sl.get<CharactersDao>()),
  );
  sl.registerSingleton<FranchiseHandler>(
    FranchiseHandler(sl.get<FranchisesDao>()),
  );
  sl.registerSingleton<UserHandler>(UserHandler(sl.get<UserSettingsDao>()));
}
