import 'package:shelf_router/shelf_router.dart';

import '../handlers/auth_handler.dart';

Router authRouter(AuthHandler handler) {
  final router = Router();

  router.post('/register', handler.register);
  router.post('/login', handler.login);
  router.post('/refresh', handler.refresh);
  router.post('/logout', handler.logout);
  // TODO: oauth

  return router;
}
