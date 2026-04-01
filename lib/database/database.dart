import 'package:drift/drift.dart';
import 'package:drift_postgres/drift_postgres.dart';
import 'package:postgres/postgres.dart' as pg;

import '../config/app_config.dart';
import '../core/constants.dart';
import '../core/exceptions.dart';
import '../di.dart';
import '../utils/logger.dart';
import 'codec/enum_codec.dart';
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
import 'tables/user_settings.dart';
import 'tables/user_social_accounts.dart';
import 'tables/users.dart';

part './daos/artists_dao.dart';
part './daos/characters_dao.dart';
part './daos/franchises_dao.dart';
part './daos/media_dao.dart';
part './daos/posts_dao.dart';
part './daos/refresh_tokens_dao.dart';
part './daos/user_settings_dao.dart';
part './daos/user_identities_dao.dart';
part './daos/users_dao.dart';
part 'database.g.dart';

const _log = Logger('Database');

@DriftDatabase(
  tables: [
    Users,
    UserIdentities,
    UserSettings,
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
    return LazyDatabase(
      () async {
        final config = sl<AppConfig>();

        final endpoint = pg.Endpoint(
          host: config.dbHost,
          database: config.dbName,
          username: config.dbUser,
          password: config.dbPassword,
          port: config.dbPort,
        );

        // ALL OF THIS just because postgres doesn't decode enums properly
        final rawConnection = await pg.Connection.open(
          endpoint,
          settings: pg.ConnectionSettings(sslMode: pg.SslMode.disable),
        );
        final result = await rawConnection.execute(
          "SELECT typname, oid::text FROM pg_type WHERE typtype = 'e'",
        );
        final enumCodec = EnumTextCodec();

        final Map<int, pg.Codec> codecs = {};

        for (final row in result) {
          final oid = int.parse(row[1] as String);
          final name = row[0] as String;

          _log.info('Registering codec for enum $name with OID $oid');
          codecs[oid] = enumCodec;
        }

        await rawConnection.close();

        final registry = pg.TypeRegistry(codecs: codecs);

        return PgDatabase(
          settings: pg.ConnectionSettings(
            // because we are always in a container, we can disable SSL
            sslMode: pg.SslMode.disable,
            typeRegistry: registry,
          ),
          endpoint: pg.Endpoint(
            host: config.dbHost,
            database: config.dbName,
            username: config.dbUser,
            password: config.dbPassword,
            port: config.dbPort,
          ),
        );
      },
      dialect: SqlDialect.postgres,
      openImmediately: true,
    );
  }
}
