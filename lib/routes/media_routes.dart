import 'package:shelf_router/shelf_router.dart';

import '../handlers/media_handler.dart';

Router mediaRouter(MediaHandler handler) {
  final router = Router();

  router.get('/api/media/files/<path>', handler.serveFile);
  router.post('/api/media/upload', handler.upload);
  router.post('/api/media/remote', handler.saveRemote);
  router.get('/api/media/:id', handler.getById);
  router.delete('/api/media/:id', handler.delete);

  return router;
}
