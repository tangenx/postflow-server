import 'package:shelf_router/shelf_router.dart';

import '../handlers/user_handler.dart';

Router userRouter(UserHandler handler) {
  final router = Router();

  router.get('/', handler.getSettings);
  router.put('/', handler.updateSettings);

  return router;
}
