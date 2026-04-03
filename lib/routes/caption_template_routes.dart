import 'package:shelf_router/shelf_router.dart';

import '../handlers/caption_template_handler.dart';

Router captionTemplateRouter(CaptionTemplateHandler handler) {
  final router = Router();

  router.get('/', handler.getTemplates);
  router.post('/', handler.create);
  router.get('/<id>', handler.getTemplate);
  router.put('/<id>', handler.update);
  router.delete('/<id>', handler.delete);
  router.get('/<id>/preview', handler.render);

  return router;
}
