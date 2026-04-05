import 'package:dotenv/dotenv.dart';
import 'package:get_it/get_it.dart';

import 'config/app_config.dart';
import 'core/constants.dart';
import 'database/database.dart';
import 'handlers/artist_handler.dart';
import 'handlers/auth_handler.dart';
import 'handlers/caption_template_handler.dart';
import 'handlers/character_handler.dart';
import 'handlers/franchise_handler.dart';
import 'handlers/media_handler.dart';
import 'handlers/posts_handler.dart';
import 'handlers/schedule_handler.dart';
import 'handlers/social_account_target_handler.dart';
import 'handlers/user_handler.dart';
import 'handlers/user_social_account_hander.dart';
import 'services/auth_service.dart';
import 'services/caption_service.dart';
import 'services/jwt_service.dart';
import 'services/media_service.dart';
import 'services/posts_service.dart';
import 'services/schedule_service.dart';
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
  sl.registerSingleton<MediaDao>(MediaDao(sl.get<PostflowDatabase>()));
  sl.registerSingleton<PostsDao>(PostsDao(sl.get<PostflowDatabase>()));
  sl.registerSingleton<CaptionTemplatesDao>(
    CaptionTemplatesDao(sl.get<PostflowDatabase>()),
  );
  sl.registerSingleton<SocialAccountTargetsDao>(
    SocialAccountTargetsDao(sl.get<PostflowDatabase>()),
  );
  sl.registerSingleton<UserSocialAccountsDao>(
    UserSocialAccountsDao(sl.get<PostflowDatabase>()),
  );
  sl.registerSingleton<ScheduleDao>(ScheduleDao(sl.get<PostflowDatabase>()));

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
  sl.registerSingleton<MediaService>(
    MediaService(
      mediaDao: sl.get<MediaDao>(),
      storageService: sl.get<StorageService>(),
      config: sl.get<AppConfig>(),
    ),
  );
  sl.registerSingleton<CaptionService>(CaptionService());
  sl.registerSingleton<PostsService>(
    PostsService(
      postsDao: sl.get<PostsDao>(),
      artistsDao: sl.get<ArtistsDao>(),
      charactersDao: sl.get<CharactersDao>(),
      franchisesDao: sl.get<FranchisesDao>(),
      db: sl.get<PostflowDatabase>(),
    ),
  );
  sl.registerSingleton<ScheduleService>(
    ScheduleService(
      scheduleDao: sl.get<ScheduleDao>(),
      postsDao: sl.get<PostsDao>(),
      db: sl.get<PostflowDatabase>(),
      socialAccountTargetsDao: sl.get<SocialAccountTargetsDao>(),
      captionService: sl.get<CaptionService>(),
      captionTemplatesDao: sl.get<CaptionTemplatesDao>(),
    ),
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
  sl.registerSingleton<CaptionTemplateHandler>(
    CaptionTemplateHandler(
      captionTemplatesDao: sl.get<CaptionTemplatesDao>(),
      captionService: sl.get<CaptionService>(),
      postsDao: sl.get<PostsDao>(),
      socialAccountTargetsDao: sl.get<SocialAccountTargetsDao>(),
    ),
  );
  sl.registerSingleton<PostsHandler>(PostsHandler(sl.get<PostsService>()));
  sl.registerSingleton<MediaHandler>(
    MediaHandler(
      mediaService: sl.get<MediaService>(),
      mediaDao: sl.get<MediaDao>(),
      config: sl.get<AppConfig>(),
      storageService: sl.get<StorageService>(),
    ),
  );
  sl.registerSingleton<SocialAccountTargetHandler>(
    SocialAccountTargetHandler(
      socialAccountTargetsDao: sl.get<SocialAccountTargetsDao>(),
      accountsDao: sl.get<UserSocialAccountsDao>(),
    ),
  );
  sl.registerSingleton<UserSocialAccountHandler>(
    UserSocialAccountHandler(sl.get<UserSocialAccountsDao>()),
  );
  sl.registerSingleton<ScheduleHandler>(
    ScheduleHandler(sl.get<ScheduleService>()),
  );
}
