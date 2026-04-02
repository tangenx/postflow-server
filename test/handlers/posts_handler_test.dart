import 'dart:convert';

import 'package:drift_postgres/drift_postgres.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';
import 'package:postflow_server/core/constants.dart';
import 'package:postflow_server/core/exceptions.dart';
import 'package:postflow_server/database/database.dart';
import 'package:postflow_server/database/tables/posts.dart';
import 'package:postflow_server/handlers/posts_handler.dart';
import 'package:postflow_server/services/posts_service.dart';

// ---------------------------------------------------------------------------
// Fakes
// ---------------------------------------------------------------------------

class FakePostsService implements PostsService {
  List<PostWithRelations> getPostsResult = [];
  int getPostsCount = 0;
  PostWithRelations? createPostResult;
  PostWithRelations? getPostResult;
  PostWithRelations? updatePostResult;

  int deletePostCalled = 0;
  UuidValue? deletePostPostId;
  UuidValue? deletePostUserId;

  CreatePostRequest? lastCreateRequest;
  UpdatePostRequest? lastUpdateRequest;
  UuidValue? lastCreateUserId;
  UuidValue? lastGetPostId;
  UuidValue? lastGetUserId;
  UuidValue? lastUpdatePostId;
  UuidValue? lastUpdateUserId;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  Future<(List<PostWithRelations>, int)> getPostsByUserId(
    UuidValue userId, {
    int page = 1,
    int pageSize = 10,
  }) async => (getPostsResult, getPostsCount);

  @override
  Future<PostWithRelations> createPost({
    required UuidValue userId,
    required CreatePostRequest request,
  }) async {
    lastCreateUserId = userId;
    lastCreateRequest = request;
    return createPostResult!;
  }

  @override
  Future<PostWithRelations> getPost(UuidValue postId, UuidValue userId) async {
    lastGetPostId = postId;
    lastGetUserId = userId;
    if (getPostResult == null) {
      throw NotFoundException('Post not found');
    }
    return getPostResult!;
  }

  @override
  Future<PostWithRelations> updatePost({
    required UuidValue postId,
    required UuidValue userId,
    required UpdatePostRequest request,
  }) async {
    lastUpdatePostId = postId;
    lastUpdateUserId = userId;
    lastUpdateRequest = request;
    return updatePostResult!;
  }

  @override
  Future<void> deletePost(UuidValue postId, UuidValue userId) async {
    deletePostCalled++;
    deletePostPostId = postId;
    deletePostUserId = userId;
  }
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

const _userId = '550e8400-e29b-41d4-a716-446655440000';
const _postId = '660e8400-e29b-41d4-a716-446655440001';
const _mediaId = '770e8400-e29b-41d4-a716-446655440002';
const _artistId = '880e8400-e29b-41d4-a716-446655440003';
const _characterId = '990e8400-e29b-41d4-a716-446655440004';
const _franchiseId = 'aa0e8400-e29b-41d4-a716-446655440005';
const _contextFranchiseId = 'bb0e8400-e29b-41d4-a716-446655440006';

final _testPost = Post(
  id: UuidValue.fromString(_postId),
  createdBy: UuidValue.fromString(_userId),
  internalNote: 'test note',
  description: 'test description',
  status: PostStatus.draft,
  createdAt: PgDateTime(DateTime.utc(2024, 1, 1)),
  updatedAt: PgDateTime(DateTime.utc(2024, 1, 1)),
);

final _testPostWithRelations = PostWithRelations(
  post: _testPost,
  media: [],
  artists: [],
  characters: [],
);

final _testMediaFile = MediaFile(
  id: UuidValue.fromString(_mediaId),
  uploadedBy: UuidValue.fromString(_userId),
  mediaTypeId: UuidValue.fromString(_franchiseId),
  storageType: StorageType.local,
  storagePath: 'test.png',
  originalFilename: 'test.png',
  fileSizeBytes: BigInt.from(1024),
  metadata: {},
  uploadedAt: PgDateTime(DateTime.utc(2024)),
);

final _testPostWithMedia = PostWithRelations(
  post: _testPost,
  media: [_testMediaFile],
  artists: [],
  characters: [],
);

Request _withUserId(Request request) {
  return request.change(context: {'userId': UuidValue.fromString(_userId)});
}

Request _jsonRequest(String method, String path, Map<String, dynamic> body) {
  return Request(
    method,
    Uri.parse('http://localhost/$path'),
    body: jsonEncode(body),
    headers: {'content-type': 'application/json'},
  );
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  late FakePostsService fakeService;
  late PostsHandler handler;

  setUp(() {
    fakeService = FakePostsService();
    handler = PostsHandler(fakeService);
  });

  group('PostsHandler', () {
    group('getPosts', () {
      test('returns paginated list of posts', () async {
        fakeService.getPostsResult = [_testPostWithRelations];
        fakeService.getPostsCount = 1;

        final request = Request(
          'GET',
          Uri.parse('http://localhost/api/posts?page=1&page_size=10'),
        ).change(context: {'userId': UuidValue.fromString(_userId)});

        final response = await handler.getPosts(request);

        expect(response.statusCode, equals(200));
        final body = jsonDecode(await response.readAsString());
        expect(body['ok'], isTrue);
        expect(body['data'], hasLength(1));
        expect(body['meta']['page'], equals(1));
        expect(body['meta']['page_size'], equals(10));
        expect(body['meta']['total'], equals(1));
      });

      test('uses default pagination when no query params', () async {
        fakeService.getPostsResult = [];
        fakeService.getPostsCount = 0;

        final request = Request(
          'GET',
          Uri.parse('http://localhost/api/posts'),
        ).change(context: {'userId': UuidValue.fromString(_userId)});

        final response = await handler.getPosts(request);

        expect(response.statusCode, equals(200));
        final body = jsonDecode(await response.readAsString());
        expect(body['meta']['page'], equals(1));
        expect(body['meta']['page_size'], equals(10));
      });

      test('returns empty list when no posts', () async {
        fakeService.getPostsResult = [];
        fakeService.getPostsCount = 0;

        final request = Request(
          'GET',
          Uri.parse('http://localhost/api/posts'),
        ).change(context: {'userId': UuidValue.fromString(_userId)});

        final response = await handler.getPosts(request);

        expect(response.statusCode, equals(200));
        final body = jsonDecode(await response.readAsString());
        expect(body['data'], isEmpty);
        expect(body['meta']['total'], equals(0));
      });
    });

    group('createPost', () {
      test('creates post and returns 200', () async {
        fakeService.createPostResult = _testPostWithRelations;

        final request = _withUserId(
          _jsonRequest('POST', 'api/posts', {
            'description': 'test',
            'internal_note': 'note',
            'media': [_mediaId],
            'artists': [
              {'id': _artistId},
            ],
            'characters': [
              {'id': _characterId, 'context_franchise_id': _contextFranchiseId},
            ],
          }),
        );

        final response = await handler.createPost(request);

        expect(response.statusCode, equals(200));
        final body = jsonDecode(await response.readAsString());
        expect(body['ok'], isTrue);
        expect(body['data'], isNotNull);
        expect(body['data']['description'], 'test description');
        expect(body['data']['status'], 'draft');
      });

      test('passes userId from context to service', () async {
        fakeService.createPostResult = _testPostWithRelations;

        final request = _withUserId(
          _jsonRequest('POST', 'api/posts', {
            'media': [],
            'artists': [],
            'characters': [],
          }),
        );

        await handler.createPost(request);

        expect(fakeService.lastCreateUserId, UuidValue.fromString(_userId));
      });

      test('throws ValidationException for invalid JSON', () {
        final request = _withUserId(
          Request(
            'POST',
            Uri.parse('http://localhost/api/posts'),
            body: 'not json',
            headers: {'content-type': 'application/json'},
          ),
        );

        expect(
          () => handler.createPost(request),
          throwsA(isA<ValidationException>()),
        );
      });

      test('throws ValidationException for empty body', () {
        final request = _withUserId(
          Request(
            'POST',
            Uri.parse('http://localhost/api/posts'),
            body: '',
            headers: {'content-type': 'application/json'},
          ),
        );

        expect(
          () => handler.createPost(request),
          throwsA(isA<ValidationException>()),
        );
      });

      test('throws FormatException for invalid media UUID', () {
        final request = _withUserId(
          _jsonRequest('POST', 'api/posts', {
            'media': ['not-a-uuid'],
            'artists': [],
            'characters': [],
          }),
        );

        expect(
          () => handler.createPost(request),
          throwsA(isA<FormatException>()),
        );
      });
    });

    group('getPost', () {
      test('returns post by id', () async {
        fakeService.getPostResult = _testPostWithMedia;

        final request = Request(
          'GET',
          Uri.parse('http://localhost/api/posts/$_postId'),
        ).change(context: {'userId': UuidValue.fromString(_userId)});

        final response = await handler.getPost(request, _postId);

        expect(response.statusCode, equals(200));
        final body = jsonDecode(await response.readAsString());
        expect(body['ok'], isTrue);
        expect(body['data'], isNotNull);
        expect(body['data']['media'], hasLength(1));
      });

      test('throws NotFoundException when post not found', () {
        fakeService.getPostResult = null;

        final request = Request(
          'GET',
          Uri.parse('http://localhost/api/posts/$_postId'),
        ).change(context: {'userId': UuidValue.fromString(_userId)});

        expect(
          () => handler.getPost(request, _postId),
          throwsA(isA<NotFoundException>()),
        );
      });

      test('throws FormatException for invalid UUID', () {
        final request = Request(
          'GET',
          Uri.parse('http://localhost/api/posts/not-a-uuid'),
        ).change(context: {'userId': UuidValue.fromString(_userId)});

        expect(
          () => handler.getPost(request, 'not-a-uuid'),
          throwsA(isA<FormatException>()),
        );
      });
    });

    group('updatePost', () {
      test('updates post and returns 200', () async {
        fakeService.updatePostResult = PostWithRelations(
          post: Post(
            id: UuidValue.fromString(_postId),
            createdBy: UuidValue.fromString(_userId),
            internalNote: 'updated note',
            description: 'updated desc',
            status: PostStatus.ready,
            createdAt: PgDateTime(DateTime.utc(2024, 1, 1)),
            updatedAt: PgDateTime(DateTime.utc(2024, 1, 2)),
          ),
          media: [],
          artists: [],
          characters: [],
        );

        final request = _withUserId(
          _jsonRequest('PUT', 'api/posts/$_postId', {
            'description': 'updated desc',
            'status': 'ready',
          }),
        );

        final response = await handler.updatePost(request, _postId);

        expect(response.statusCode, equals(200));
        final body = jsonDecode(await response.readAsString());
        expect(body['ok'], isTrue);
        expect(body['data']['status'], 'ready');
      });

      test('passes postId and userId to service', () async {
        fakeService.updatePostResult = _testPostWithRelations;

        final request = _withUserId(
          _jsonRequest('PUT', 'api/posts/$_postId', {'description': 'desc'}),
        );

        await handler.updatePost(request, _postId);

        expect(fakeService.lastUpdatePostId, UuidValue.fromString(_postId));
        expect(fakeService.lastUpdateUserId, UuidValue.fromString(_userId));
      });

      test('throws ValidationException for invalid JSON', () {
        final request = _withUserId(
          Request(
            'PUT',
            Uri.parse('http://localhost/api/posts/$_postId'),
            body: 'not json',
            headers: {'content-type': 'application/json'},
          ),
        );

        expect(
          () => handler.updatePost(request, _postId),
          throwsA(isA<ValidationException>()),
        );
      });

      test('throws FormatException for invalid post UUID', () {
        final request = _withUserId(
          _jsonRequest('PUT', 'api/posts/bad-uuid', {'description': 'desc'}),
        );

        expect(
          () => handler.updatePost(request, 'bad-uuid'),
          throwsA(isA<FormatException>()),
        );
      });
    });

    group('deletePost', () {
      test('deletes post and returns 200', () async {
        final request = Request(
          'DELETE',
          Uri.parse('http://localhost/api/posts/$_postId'),
        ).change(context: {'userId': UuidValue.fromString(_userId)});

        final response = await handler.deletePost(request, _postId);

        expect(response.statusCode, equals(200));
        final body = jsonDecode(await response.readAsString());
        expect(body['ok'], isTrue);
        expect(fakeService.deletePostCalled, 1);
      });

      test('passes postId and userId to service', () async {
        final request = Request(
          'DELETE',
          Uri.parse('http://localhost/api/posts/$_postId'),
        ).change(context: {'userId': UuidValue.fromString(_userId)});

        await handler.deletePost(request, _postId);

        expect(fakeService.deletePostPostId, UuidValue.fromString(_postId));
        expect(fakeService.deletePostUserId, UuidValue.fromString(_userId));
      });

      test('throws FormatException for invalid UUID', () {
        final request = Request(
          'DELETE',
          Uri.parse('http://localhost/api/posts/bad-uuid'),
        ).change(context: {'userId': UuidValue.fromString(_userId)});

        expect(
          () => handler.deletePost(request, 'bad-uuid'),
          throwsA(isA<FormatException>()),
        );
      });
    });
  });
}
