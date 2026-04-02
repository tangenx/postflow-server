import 'package:shelf_router/shelf_router.dart';

import '../handlers/media_handler.dart';

Router mediaRouter(MediaHandler handler) {
  final router = Router();

  router.get('/files/<path>', handler.serveFile);
  router.post('/upload', handler.upload);
  router.post('/remote', handler.saveRemote);
  router.get('/<id>', handler.getById);
  router.delete('/<id>', handler.delete);

  return router;
}
