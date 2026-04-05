import 'dart:convert';

import 'package:drift_postgres/drift_postgres.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';
import 'package:postflow_server/core/exceptions.dart';
import 'package:postflow_server/database/database.dart';
import 'package:postflow_server/handlers/caption_template_handler.dart';
import 'package:postflow_server/services/caption_service.dart';

// ---------------------------------------------------------------------------
// Fakes
// ---------------------------------------------------------------------------

class FakeCaptionTemplatesDao implements CaptionTemplatesDao {
  CaptionTemplate? templateById;
  final List<CaptionTemplate> userTemplates = [];
  CaptionTemplate? createdTemplate;
  CaptionTemplate? updatedTemplate;
  bool deleted = false;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  Future<CaptionTemplate> create({
    required UuidValue ownerId,
    required String name,
    required String body,
  }) async {
    return createdTemplate ?? _testTemplate();
  }

  @override
  Future<List<CaptionTemplate>> findForUser(UuidValue userId) async =>
      userTemplates;

  @override
  Future<CaptionTemplate?> findById(UuidValue id) async => templateById;

  @override
  Future<CaptionTemplate> updateTemplate({
    required UuidValue id,
    required UuidValue ownerId,
    String? name,
    String? body,
  }) async {
    if (updatedTemplate != null) return updatedTemplate!;
    throw NotFoundException('Template not found');
  }

  @override
  Future<void> deleteTemplate(UuidValue id, UuidValue ownerId) async {
    deleted = true;
  }
}

class FakePostsDao implements PostsDao {
  PostWithRelations? postToReturn;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  Future<PostWithRelations?> findPostWithRelationsById(
    UuidValue id,
    UuidValue userId,
  ) async => postToReturn;
}

class FakeSocialAccountTargetsDao implements SocialAccountTargetsDao {
  SocialAccountTarget? targetToReturn;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  Future<SocialAccountTarget?> findById(UuidValue id) async => targetToReturn;
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

const _userId = '550e8400-e29b-41d4-a716-446655440000';
const _templateId = '660e8400-e29b-41d4-a716-446655440001';

CaptionTemplate _testTemplate({
  String name = 'My Template',
  String body = '{{artist}} - {{franchise}}',
}) {
  return CaptionTemplate(
    id: UuidValue.fromString(_templateId),
    ownerId: UuidValue.fromString(_userId),
    name: name,
    body: body,
    variables: [],
    isGlobal: false,
    createdAt: PgDateTime(DateTime.utc(2024)),
    updatedAt: PgDateTime(DateTime.utc(2024)),
  );
}

Request _jsonPost(String path, Map<String, dynamic> body) {
  return Request(
    'POST',
    Uri.parse('http://localhost/$path'),
    body: jsonEncode(body),
    headers: {'content-type': 'application/json'},
  );
}

Request _jsonPut(String path, Map<String, dynamic> body) {
  return Request(
    'PUT',
    Uri.parse('http://localhost/$path'),
    body: jsonEncode(body),
    headers: {'content-type': 'application/json'},
  );
}

Request _withUserId(Request request) {
  return request.change(
    context: {'userId': UuidValue.fromString(_userId)},
  );
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  late FakeCaptionTemplatesDao fakeDao;
  late FakePostsDao fakePostsDao;
  late FakeSocialAccountTargetsDao fakeTargetsDao;
  late CaptionTemplateHandler handler;

  setUp(() {
    fakeDao = FakeCaptionTemplatesDao();
    fakePostsDao = FakePostsDao();
    fakeTargetsDao = FakeSocialAccountTargetsDao();
    handler = CaptionTemplateHandler(
      captionTemplatesDao: fakeDao,
      captionService: CaptionService(),
      postsDao: fakePostsDao,
      socialAccountTargetsDao: fakeTargetsDao,
    );
  });

  group('CaptionTemplateHandler', () {
    group('getTemplates', () {
      test('returns list of templates', () async {
        fakeDao.userTemplates.add(_testTemplate());

        final request = _withUserId(
          Request('GET', Uri.parse('http://localhost/api/caption-templates')),
        );
        final response = await handler.getTemplates(request);

        expect(response.statusCode, equals(200));
        final body = jsonDecode(await response.readAsString());
        expect(body['ok'], isTrue);
        expect((body['data'] as List).length, equals(1));
      });

      test('returns empty list when no templates', () async {
        final request = _withUserId(
          Request('GET', Uri.parse('http://localhost/api/caption-templates')),
        );
        final response = await handler.getTemplates(request);

        expect(response.statusCode, equals(200));
        final body = jsonDecode(await response.readAsString());
        expect((body['data'] as List), isEmpty);
      });
    });

    group('getTemplate', () {
      test('returns template when found', () async {
        fakeDao.templateById = _testTemplate();

        final request = _withUserId(
          Request('GET', Uri.parse('http://localhost/api/caption-templates/$_templateId')),
        );
        final response = await handler.getTemplate(request, _templateId);

        expect(response.statusCode, equals(200));
        final body = jsonDecode(await response.readAsString());
        expect(body['ok'], isTrue);
        expect(body['data']['name'], equals('My Template'));
      });

      test('returns 404 when not found', () async {
        fakeDao.templateById = null;

        final request = _withUserId(
          Request('GET', Uri.parse('http://localhost/api/caption-templates/$_templateId')),
        );
        final response = await handler.getTemplate(request, _templateId);

        expect(response.statusCode, equals(404));
        final body = jsonDecode(await response.readAsString());
        expect(body['ok'], isFalse);
        expect(body['error']['code'], equals('NOT_FOUND'));
      });
    });

    group('create', () {
      test('returns created template', () async {
        fakeDao.createdTemplate = _testTemplate(name: 'New', body: 'Hello');

        final request = _withUserId(_jsonPost('api/caption-templates', {
          'name': 'New',
          'body': 'Hello',
        }));

        final response = await handler.create(request);

        expect(response.statusCode, equals(200));
        final body = jsonDecode(await response.readAsString());
        expect(body['ok'], isTrue);
        expect(body['data']['name'], equals('New'));
        expect(body['data']['body'], equals('Hello'));
      });
    });

    group('update', () {
      test('returns updated template', () async {
        fakeDao.updatedTemplate = _testTemplate(name: 'Updated');

        final request = _withUserId(_jsonPut('api/caption-templates/$_templateId', {
          'name': 'Updated',
        }));

        final response = await handler.update(request, _templateId);

        expect(response.statusCode, equals(200));
        final body = jsonDecode(await response.readAsString());
        expect(body['ok'], isTrue);
        expect(body['data']['name'], equals('Updated'));
      });

      test('throws NotFoundException when template not found', () {
        fakeDao.updatedTemplate = null;

        final request = _withUserId(_jsonPut('api/caption-templates/$_templateId', {
          'name': 'Updated',
        }));

        expect(
          () => handler.update(request, _templateId),
          throwsA(isA<NotFoundException>()),
        );
      });
    });

    group('delete', () {
      test('deletes template and returns ok', () async {
        final request = _withUserId(
          Request('DELETE', Uri.parse('http://localhost/api/caption-templates/$_templateId')),
        );
        final response = await handler.delete(request, _templateId);

        expect(response.statusCode, equals(200));
        final body = jsonDecode(await response.readAsString());
        expect(body['ok'], isTrue);
        expect(fakeDao.deleted, isTrue);
      });
    });

    group('render', () {
      test('returns 404 when template not found', () async {
        fakeDao.templateById = null;

        final request = _withUserId(_jsonPost(
          'api/caption-templates/$_templateId/preview',
          {'post_id': '00000000-0000-0000-0000-000000000000', 'target_id': '00000000-0000-0000-0000-000000000000', 'overrides': '{}'},
        ));

        final response = await handler.render(request, _templateId);

        expect(response.statusCode, equals(404));
      });

      test('returns 404 when target not found', () async {
        fakeDao.templateById = _testTemplate();
        fakeTargetsDao.targetToReturn = null;

        final request = _withUserId(_jsonPost(
          'api/caption-templates/$_templateId/preview',
          {'post_id': '00000000-0000-0000-0000-000000000000', 'target_id': '00000000-0000-0000-0000-000000000000', 'overrides': '{}'},
        ));

        final response = await handler.render(request, _templateId);

        expect(response.statusCode, equals(404));
      });

      test('returns 404 when post not found', () async {
        fakeDao.templateById = _testTemplate();
        fakeTargetsDao.targetToReturn = SocialAccountTarget(
          id: UuidValue.fromString('00000000-0000-0000-0000-000000000000'),
          userSocialAccountId: UuidValue.fromString(_userId),
          targetType: 'instagram',
          targetId: '123',
          targetLabel: 'IG',
          shortLink: null,
          isActive: true,
        );
        fakePostsDao.postToReturn = null;

        final request = _withUserId(_jsonPost(
          'api/caption-templates/$_templateId/preview',
          {'post_id': '00000000-0000-0000-0000-000000000000', 'target_id': '00000000-0000-0000-0000-000000000000', 'overrides': '{}'},
        ));

        final response = await handler.render(request, _templateId);

        expect(response.statusCode, equals(404));
      });
    });
  });
}
