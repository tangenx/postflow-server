import 'package:postflow_server/routes/reference_routes.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../handlers/artist_handler.dart';
import '../handlers/character_handler.dart';
import '../handlers/franchise_handler.dart';
import 'auth_routes.dart';
import '../config/app_config.dart';
import '../di.dart';
import '../handlers/auth_handler.dart';
import '../handlers/health.dart';
import '../middlewares/auth_middleware.dart';
import '../middlewares/error_middleware.dart';
import '../middlewares/logging_middleware.dart';
import '../middlewares/rate_limit_middleware.dart';
import '../services/jwt_service.dart';

// TODO: require all handler classes
Handler buildRouter() {
  final config = sl<AppConfig>();
  final jwtService = sl<JwtService>();

  final router = Router();

  router.mount('/api/auth/', authRouter(sl.get<AuthHandler>()).call);
  // router.mount('/api/posts', handler);
  // router.mount('/api/media', handler);
  // router.mount('/api/schedules', handler);
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
