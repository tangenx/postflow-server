import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../config/app_config.dart';
import '../middlewares/auth_middleware.dart';
import '../handlers/check.dart';
import '../services/jwt_service.dart';

// TODO: require all handler classes
Handler buildRouter({
  required AppConfig config,
  required JwtService jwtService,
}) {
  final router = Router();

  // router.mount('/api/auth', handler);
  // router.mount('/api/posts', handler);
  // router.mount('/api/media', handler);
  // router.mount('/api/schedules', handler);
  // router.mount('/api/', references);
  router.get('/api/check', checkHandler);

  router.all('/<path|.*>', (Request req) => Response.notFound('Not found'));

  // TODO: auth middleware
  return Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(authMiddleware(config, jwtService))
      .addHandler(router.call);
}
