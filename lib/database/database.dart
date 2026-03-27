import 'package:drift/drift.dart';
import 'package:drift_postgres/drift_postgres.dart';
import 'package:postgres/postgres.dart' as pg;

import '../config/app_config.dart';
import '../di.dart';
import 'tables/artists.dart';
import 'tables/caption_templates.dart';
import 'tables/characters.dart';
import 'tables/franchises.dart';
import 'tables/media_files.dart';
import 'tables/media_types.dart';
import 'tables/post_artists.dart';
import 'tables/post_captions.dart';
import 'tables/post_characters.dart';
import 'tables/post_media.dart';
import 'tables/post_schedules.dart';
import 'tables/posts.dart';
import 'tables/refresh_tokens.dart';
import 'tables/social_account_targets.dart';
import 'tables/social_networks.dart';
import 'tables/user_identities.dart';
import 'tables/user_social_accounts.dart';
import 'tables/users.dart';

part 'database.g.dart';
part './daos/artists_dao.dart';
part './daos/users_dao.dart';
part './daos/user_identities_dao.dart';
part './daos/refresh_tokens_dao.dart';

@DriftDatabase(
  tables: [
    Users,
    UserIdentities,
    RefreshTokens,
    SocialNetworks,
    UserSocialAccounts,
    SocialAccountTargets,
    Artists,
    Franchises,
    Characters,
    MediaTypes,
    MediaFiles,
    CaptionTemplates,
    Posts,
    PostMedia,
    PostArtists,
    PostCharacters,
    PostSchedules,
    PostCaptions,
  ],
)
class PostflowDatabase extends _$PostflowDatabase {
  PostflowDatabase([QueryExecutor? executor])
    : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    final config = getIt<AppConfig>();

    return PgDatabase(
      settings: pg.ConnectionSettings(
        // because we are always in a container, we can disable SSL
        sslMode: pg.SslMode.disable,
      ),
      endpoint: pg.Endpoint(
        host: config.dbHost,
        database: config.dbName,
        username: config.dbUser,
        password: config.dbPassword,
        port: config.dbPort,
      ),
    );
  }
}
