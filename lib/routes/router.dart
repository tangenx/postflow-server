import 'package:postflow_server/routes/auth_routes.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../config/app_config.dart';
import '../di.dart';
import '../handlers/auth_handler.dart';
import '../middlewares/auth_middleware.dart';
import '../handlers/health.dart';
import '../middlewares/error_middleware.dart';
import '../middlewares/logging_middleware.dart';
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
  // router.mount('/api/', references);
  router.get('/health', healthHandler);

  router.all('/<path|.*>', (Request req) => Response.notFound('Not found'));

  return Pipeline()
      .addMiddleware(loggingMiddleware())
      .addMiddleware(errorMiddleware())
      .addMiddleware(authMiddleware(config, jwtService))
      .addHandler(router.call);
}
