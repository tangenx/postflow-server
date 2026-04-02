import 'package:drift_postgres/drift_postgres.dart';
import 'package:postflow_server/utils/api_response.dart';
import 'package:shelf/shelf.dart';

import '../services/posts_service.dart';
import '../utils/request_validation.dart';

class PostsHandler {
  final PostsService _postsService;

  PostsHandler(this._postsService);

  /// GET /api/posts?page=1&page_size=10
  Future<Response> getPosts(Request request) async {
    final userId = request.context['userId'] as UuidValue;
    final page = RequestValidation.optionalPositiveInt(
      request.url.queryParameters,
      'page',
      fallback: 1,
      max: 9_999_999,
    );
    final pageSize = RequestValidation.optionalPositiveInt(
      request.url.queryParameters,
      'page_size',
      fallback: 10,
      max: 100,
    );

    final (posts, count) = await _postsService.getPostsByUserId(
      userId,
      page: page,
      pageSize: pageSize,
    );

    return ApiResponse.paginated(
      posts.map((p) => p.toJson()).toList(),
      page: page,
      total: count,
      pageSize: pageSize,
    );
  }

  /// POST /api/posts
  Future<Response> createPost(Request request) async {
    final userId = request.context['userId'] as UuidValue;
    final data = RequestValidation.parseJsonObject(
      await request.readAsString(),
    );

    RequestValidation.optionalString(data, 'description', maxLength: 4000);
    RequestValidation.optionalString(data, 'internal_note', maxLength: 4000);

    final post = await _postsService.createPost(
      userId: userId,
      request: CreatePostRequest.fromJson(data),
    );

    return ApiResponse.ok(post.toJson());
  }

  /// GET /api/posts/:id
  Future<Response> getPost(Request request, String id) async {
    final userId = request.context['userId'] as UuidValue;
    final postId = UuidValue.withValidation(id);
    final post = await _postsService.getPost(postId, userId);

    return ApiResponse.ok(post.toJson());
  }

  /// PUT /api/posts/:id
  Future<Response> updatePost(Request request, String id) async {
    final userId = request.context['userId'] as UuidValue;
    final postId = UuidValue.withValidation(id);
    final data = RequestValidation.parseJsonObject(
      await request.readAsString(),
    );

    RequestValidation.optionalString(data, 'description', maxLength: 4000);
    RequestValidation.optionalString(data, 'internal_note', maxLength: 4000);

    final post = await _postsService.updatePost(
      userId: userId,
      postId: postId,
      request: UpdatePostRequest.fromJson(data),
    );

    return ApiResponse.ok(post.toJson());
  }

  /// DELETE /api/posts/:id
  Future<Response> deletePost(Request request, String id) async {
    final userId = request.context['userId'] as UuidValue;
    final postId = UuidValue.withValidation(id);
    await _postsService.deletePost(postId, userId);

    return ApiResponse.ok(null);
  }
}
