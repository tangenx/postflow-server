import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../handlers/check.dart';

// TODO: require all handler classes
Handler buildRouter() {
  final router = Router();

  // router.mount('/api/auth', handler);
  // router.mount('/api/posts', handler);
  // router.mount('/api/media', handler);
  // router.mount('/api/schedules', handler);
  // router.mount('/api/', references);
  router.get('/api/check', checkHandler);

  router.all('/<path|.*>', (Request req) => Response.notFound('Not found'));

  // TODO: auth middleware
  return Pipeline().addMiddleware(logRequests()).addHandler(router.call);
}
