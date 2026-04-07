import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../config/app_config.dart';
import '../di.dart';
import '../handlers/artist_handler.dart';
import '../handlers/auth_handler.dart';
import '../handlers/caption_template_handler.dart';
import '../handlers/character_handler.dart';
import '../handlers/franchise_handler.dart';
import '../handlers/health.dart';
import '../handlers/media_handler.dart';
import '../handlers/posts_handler.dart';
import '../handlers/schedule_handler.dart';
import '../handlers/social_account_target_handler.dart';
import '../handlers/user_handler.dart';
import '../handlers/user_social_account_handler.dart';
import '../middlewares/auth_middleware.dart';
import '../middlewares/error_middleware.dart';
import '../middlewares/logging_middleware.dart';
import '../middlewares/rate_limit_middleware.dart';
import '../services/jwt_service.dart';
import 'auth_routes.dart';
import 'caption_template_routes.dart';
import 'media_routes.dart';
import 'posts_routes.dart';
import 'reference_routes.dart';
import 'schedule_routes.dart';
import 'social_account_target_router.dart';
import 'user_routes.dart';

Handler buildRouter() {
  final config = sl<AppConfig>();
  final jwtService = sl<JwtService>();

  final router = Router();

  router.mount('/api/auth/', authRouter(sl.get<AuthHandler>()).call);
  router.mount('/api/user/', userRouter(sl.get<UserHandler>()).call);
  router.mount('/api/posts/', postsRouter(sl.get<PostsHandler>()).call);
  router.mount('/api/media/', mediaRouter(sl.get<MediaHandler>()).call);
  router.mount(
    '/api/caption-templates/',
    captionTemplateRouter(sl.get<CaptionTemplateHandler>()).call,
  );
  router.mount(
    '/api/social-accounts/',
    socialRoutes(
      sl.get<SocialAccountTargetHandler>(),
      sl.get<UserSocialAccountHandler>(),
    ).call,
  );
  router.mount(
    '/api/schedules/',
    scheduleRoutes(sl.get<ScheduleHandler>()).call,
  );
  router.mount(
    '/api/',
    referenceRouter(
      artistHandler: sl.get<ArtistHandler>(),
      characterHandler: sl.get<CharacterHandler>(),
      franchiseHandler: sl.get<FranchiseHandler>(),
    ).call,
  );
  router.get('/health', healthHandler);

  router.all('/<path|.*>', (Request req) => Response.notFound('Not found'));

  return Pipeline()
      .addMiddleware(loggingMiddleware())
      .addMiddleware(errorMiddleware())
      .addMiddleware(
        rateLimitMiddleware({
          'api/auth/login': RateLimiter(
            maxRequests: 10,
            timeFrame: Duration(minutes: 1),
          ),
          'api/auth/refresh': RateLimiter(
            maxRequests: 30,
            timeFrame: Duration(minutes: 1),
          ),
          'api/auth/register': RateLimiter(
            maxRequests: 5,
            timeFrame: Duration(minutes: 1),
          ),
        }, RateLimiter(maxRequests: 200, timeFrame: Duration(minutes: 1))),
      )
      .addMiddleware(authMiddleware(config, jwtService))
      .addHandler(router.call);
}
