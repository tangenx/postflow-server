import 'package:shelf_router/shelf_router.dart';

import '../handlers/posts_handler.dart';

Router postsRouter(PostsHandler handler) {
  final router = Router();

  router.get('/', handler.getPosts);
  router.post('/', handler.createPost);
  router.get('/<id>', handler.getPost);
  router.put('/<id>', handler.updatePost);
  router.delete('/<id>', handler.deletePost);

  return router;
}
