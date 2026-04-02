import 'package:shelf_router/shelf_router.dart';

import '../handlers/artist_handler.dart';
import '../handlers/character_handler.dart';
import '../handlers/franchise_handler.dart';

Router referenceRouter({
  required ArtistHandler artistHandler,
  required CharacterHandler characterHandler,
  required FranchiseHandler franchiseHandler,
}) {
  final router = Router();

  router.get('/artists', artistHandler.search);
  router.get('/artists/<id>', artistHandler.getById);
  router.post('/artists', artistHandler.create);
  router.put('/artists/<id>', artistHandler.update);
  router.delete('/artists/<id>', artistHandler.delete);

  router.get('/characters', characterHandler.search);
  router.get('/characters/<id>', characterHandler.getById);
  router.post('/characters', characterHandler.create);
  router.put('/characters/<id>', characterHandler.update);
  router.delete('/characters/<id>', characterHandler.delete);

  router.get('/franchises', franchiseHandler.search);
  router.get('/franchises/<id>', franchiseHandler.getById);
  router.post('/franchises', franchiseHandler.create);
  router.put('/franchises/<id>', franchiseHandler.update);
  router.delete('/franchises/<id>', franchiseHandler.delete);

  return router;
}
