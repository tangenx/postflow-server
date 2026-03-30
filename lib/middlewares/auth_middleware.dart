import 'package:drift_postgres/drift_postgres.dart';
import 'package:shelf/shelf.dart';

import '../config/app_config.dart';
import '../services/jwt_service.dart';
import '../utils/is_route_public.dart';

Middleware authMiddleware(AppConfig config, JwtService jwtService) {
  return (Handler handler) {
    return (Request request) {
      if (isRoutePublic(request.url.path)) {
        return handler(request);
      }

      if (!config.authenticationEnabled) {
        return handler(
          request.change(
            context: {
              // ok this doesn't need validation
              'user-id': UuidValue.fromString(
                '00000000-0000-0000-0000-000000000000',
              ),
            },
          ),
        );
      }

      final authHeader = request.headers['authorization'];
      if (authHeader == null || !authHeader.startsWith('Bearer ')) {
        return Response.unauthorized(null);
      }

      final token = authHeader.substring(7);
      final userId = jwtService.verifyAccessToken(token);

      if (userId == null) {
        return Response.unauthorized(null);
      }

      return handler(
        // also this doesn't need validation too because it's from the database
        request.change(context: {'user-id': UuidValue.fromString(userId)}),
      );
    };
  };
}
