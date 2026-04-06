import 'dart:convert';

import 'package:drift_postgres/drift_postgres.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';
import 'package:postflow_server/core/exceptions.dart';
import 'package:postflow_server/database/database.dart';
import 'package:postflow_server/database/tables/post_schedules.dart' show ScheduleStatus;
import 'package:postflow_server/handlers/schedule_handler.dart';
import 'package:postflow_server/services/schedule_service.dart';

// ---------------------------------------------------------------------------
// Fakes
// ---------------------------------------------------------------------------

class FakeScheduleService implements ScheduleService {
  List<ScheduleWithDetails> getByPostResult = [];
  UuidValue? lastGetByPostPostId;
  UuidValue? lastGetByPostUserId;

  List<ScheduleWithDetails> createSchedulesResult = [];
  UuidValue? lastCreateUserId;
  UuidValue? lastCreatePostId;
  List<CreateScheduleRequest>? lastCreateRequests;

  PostSchedule? retryResult;
  UuidValue? lastRetryPostScheduleId;
  UuidValue? lastRetryUserId;
  DateTime? lastRetryScheduledAt;

  int cancelCalled = 0;
  UuidValue? lastCancelPostScheduleId;
  UuidValue? lastCancelUserId;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  Future<List<ScheduleWithDetails>> getByPostId(
    UuidValue postId,
    UuidValue userId,
  ) async {
    lastGetByPostPostId = postId;
    lastGetByPostUserId = userId;
    return getByPostResult;
  }

  @override
  Future<List<ScheduleWithDetails>> createSchedules({
    required UuidValue userId,
    required UuidValue postId,
    required List<CreateScheduleRequest> requests,
  }) async {
    lastCreateUserId = userId;
    lastCreatePostId = postId;
    lastCreateRequests = requests;
    return createSchedulesResult;
  }

  @override
  Future<PostSchedule> retrySchedule({
    required UuidValue postScheduleId,
    required UuidValue userId,
    required DateTime scheduledAt,
  }) async {
    lastRetryPostScheduleId = postScheduleId;
    lastRetryUserId = userId;
    lastRetryScheduledAt = scheduledAt;
    return retryResult!;
  }

  @override
  Future<void> cancelSchedule(UuidValue postScheduleId, UuidValue userId) async {
    cancelCalled++;
    lastCancelPostScheduleId = postScheduleId;
    lastCancelUserId = userId;
  }
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

const _userId = 'a10e8400-e29b-41d4-a716-446655440000';
const _postId = 'b20e8400-e29b-41d4-a716-446655440001';
const _targetId = 'c30e8400-e29b-41d4-a716-446655440002';
const _scheduleId = 'd40e8400-e29b-41d4-a716-446655440003';
const _accountId = 'e50e8400-e29b-41d4-a716-446655440004';
const _networkId = 'f60e8400-e29b-41d4-a716-446655440005';
const _templateId = 'a70e8400-e29b-41d4-a716-446655440006';

final _scheduledAt = DateTime.utc(2025, 6, 15, 12, 0, 0);

final _testSchedule = PostSchedule(
  id: UuidValue.fromString(_scheduleId),
  postId: UuidValue.fromString(_postId),
  socialAccountTargetId: UuidValue.fromString(_targetId),
  scheduledAt: PgDateTime(_scheduledAt),
  status: ScheduleStatus.pending,
  createdAt: PgDateTime(DateTime.utc(2025, 1, 1)),
  updatedAt: PgDateTime(DateTime.utc(2025, 1, 1)),
);

final _testTarget = SocialAccountTarget(
  id: UuidValue.fromString(_targetId),
  userSocialAccountId: UuidValue.fromString(_accountId),
  targetType: 'user',
  targetId: '12345',
  targetLabel: 'Test Target',
  shortLink: 'test_link',
  isActive: true,
);

final _testAccount = UserSocialAccount(
  id: UuidValue.fromString(_accountId),
  userId: UuidValue.fromString(_userId),
  socialNetworkId: UuidValue.fromString(_networkId),
  externalAccountId: 'ext_123',
  screenName: 'testuser',
  accessToken: 'token',
  refreshToken: 'refresh',
  tokenExpiresAt: PgDateTime(DateTime.utc(2026)),
  isActive: true,
  createdAt: PgDateTime(DateTime.utc(2025)),
);

final _testNetwork = SocialNetwork(
  id: UuidValue.fromString(_networkId),
  slug: 'test_network',
  displayName: 'Test Network',
  capabilities: '{}',
  isActive: true,
);

final _testScheduleWithDetails = ScheduleWithDetails(
  schedule: _testSchedule,
  target: _testTarget,
  account: _testAccount,
  network: _testNetwork,
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
  late FakeScheduleService fakeService;
  late ScheduleHandler handler;

  setUp(() {
    fakeService = FakeScheduleService();
    handler = ScheduleHandler(fakeService);
  });

  group('ScheduleHandler', () {
    group('getByPost', () {
      test('returns 200 with schedule list', () async {
        fakeService.getByPostResult = [_testScheduleWithDetails];

        final request = _withUserId(
          Request(
            'GET',
            Uri.parse('http://localhost/api/schedules/posts/$_postId'),
          ),
        );

        final response = await handler.getByPost(request, _postId);

        expect(response.statusCode, equals(200));
        final body = jsonDecode(await response.readAsString());
        expect(body['ok'], isTrue);
        expect(body['data'], hasLength(1));
        expect(body['data'][0]['id'], _scheduleId);
      });

      test('returns empty list when no schedules', () async {
        fakeService.getByPostResult = [];

        final request = _withUserId(
          Request(
            'GET',
            Uri.parse('http://localhost/api/schedules/posts/$_postId'),
          ),
        );

        final response = await handler.getByPost(request, _postId);

        expect(response.statusCode, equals(200));
        final body = jsonDecode(await response.readAsString());
        expect(body['data'], isEmpty);
      });

      test('passes correct postId and userId to service', () async {
        fakeService.getByPostResult = [];

        final request = _withUserId(
          Request(
            'GET',
            Uri.parse('http://localhost/api/schedules/posts/$_postId'),
          ),
        );

        await handler.getByPost(request, _postId);

        expect(
          fakeService.lastGetByPostPostId,
          UuidValue.fromString(_postId),
        );
        expect(
          fakeService.lastGetByPostUserId,
          UuidValue.fromString(_userId),
        );
      });
    });

    group('createSchedules', () {
      test('returns 200 with created schedules', () async {
        fakeService.createSchedulesResult = [_testScheduleWithDetails];

        final request = _withUserId(
          _jsonRequest('POST', 'api/schedules/posts/$_postId', {
            'schedules': [
              {
                'socialAccountTargetId': _targetId,
                'scheduledAt': _scheduledAt.toIso8601String(),
              },
            ],
          }),
        );

        final response = await handler.createSchedules(request, _postId);

        expect(response.statusCode, equals(200));
        final body = jsonDecode(await response.readAsString());
        expect(body['ok'], isTrue);
        expect(body['data'], hasLength(1));
        expect(body['data'][0]['id'], _scheduleId);
      });

      test('passes correct userId, postId, and parsed requests to service',
          () async {
        fakeService.createSchedulesResult = [];

        final request = _withUserId(
          _jsonRequest('POST', 'api/schedules/posts/$_postId', {
            'schedules': [
              {
                'socialAccountTargetId': _targetId,
                'scheduledAt': _scheduledAt.toIso8601String(),
                'templateId': _templateId,
                'captionBody': 'Hello, world!',
                'templateVariables': {'character': 'John Doe'},
              },
            ],
          }),
        );

        await handler.createSchedules(request, _postId);

        expect(fakeService.lastCreateUserId, UuidValue.fromString(_userId));
        expect(fakeService.lastCreatePostId, UuidValue.fromString(_postId));
        expect(fakeService.lastCreateRequests, hasLength(1));
        final parsed = fakeService.lastCreateRequests!.single;
        expect(
          parsed.socialAccountTargetId,
          UuidValue.fromString(_targetId),
        );
        expect(parsed.scheduledAt, _scheduledAt);
        expect(parsed.templateId, UuidValue.fromString(_templateId));
        expect(parsed.captionBody, 'Hello, world!');
        expect(parsed.templateVariables, {'character': 'John Doe'});
      });

      test('returns 400 on invalid JSON body', () {
        final request = _withUserId(
          Request(
            'POST',
            Uri.parse('http://localhost/api/schedules/posts/$_postId'),
            body: 'not json',
            headers: {'content-type': 'application/json'},
          ),
        );

        expect(
          () => handler.createSchedules(request, _postId),
          throwsA(isA<ValidationException>()),
        );
      });

      test('returns 400 on invalid UUID in postId path', () {
        final request = _withUserId(
          _jsonRequest('POST', 'api/schedules/posts/bad-uuid', {
            'schedules': [],
          }),
        );

        expect(
          () => handler.createSchedules(request, 'bad-uuid'),
          throwsA(isA<FormatException>()),
        );
      });

      test('returns 400 on invalid scheduledAt date format in request', () {
        final request = _withUserId(
          _jsonRequest('POST', 'api/schedules/posts/$_postId', {
            'schedules': [
              {
                'socialAccountTargetId': _targetId,
                'scheduledAt': 'not-a-date',
              },
            ],
          }),
        );

        expect(
          () => handler.createSchedules(request, _postId),
          throwsA(isA<FormatException>()),
        );
      });
    });

    group('retrySchedule', () {
      test('returns 200 with retried schedule', () async {
        fakeService.retryResult = _testSchedule;

        final request = _withUserId(
          _jsonRequest('POST', 'api/schedules/$_scheduleId/retry', {
            'scheduledAt': _scheduledAt.toIso8601String(),
          }),
        );

        final response = await handler.retrySchedule(request, _scheduleId);

        expect(response.statusCode, equals(200));
        final body = jsonDecode(await response.readAsString());
        expect(body['ok'], isTrue);
        expect(body['data']['id'], _scheduleId);
      });

      test(
          'passes correct postScheduleId, userId, and scheduledAt to service',
          () async {
        fakeService.retryResult = _testSchedule;

        final newScheduledAt = DateTime.utc(2025, 7, 1, 9, 0, 0);
        final request = _withUserId(
          _jsonRequest('POST', 'api/schedules/$_scheduleId/retry', {
            'scheduledAt': newScheduledAt.toIso8601String(),
          }),
        );

        await handler.retrySchedule(request, _scheduleId);

        expect(
          fakeService.lastRetryPostScheduleId,
          UuidValue.fromString(_scheduleId),
        );
        expect(fakeService.lastRetryUserId, UuidValue.fromString(_userId));
        expect(fakeService.lastRetryScheduledAt, newScheduledAt);
      });

      test('returns 400 on invalid UUID in path', () {
        final request = _withUserId(
          _jsonRequest('POST', 'api/schedules/bad-uuid/retry', {
            'scheduledAt': _scheduledAt.toIso8601String(),
          }),
        );

        expect(
          () => handler.retrySchedule(request, 'bad-uuid'),
          throwsA(isA<FormatException>()),
        );
      });

      test('returns 400 on missing scheduledAt in body', () {
        final request = _withUserId(
          _jsonRequest('POST', 'api/schedules/$_scheduleId/retry', {}),
        );

        expect(
          () => handler.retrySchedule(request, _scheduleId),
          throwsA(isA<ValidationException>()),
        );
      });
    });

    group('cancelSchedule', () {
      test('returns 200 with null data', () async {
        final request = _withUserId(
          Request(
            'POST',
            Uri.parse('http://localhost/api/schedules/$_scheduleId/cancel'),
          ),
        );

        final response = await handler.cancelSchedule(request, _scheduleId);

        expect(response.statusCode, equals(200));
        final body = jsonDecode(await response.readAsString());
        expect(body['ok'], isTrue);
        expect(body['data'], isNull);
      });

      test('passes correct postScheduleId and userId to service', () async {
        final request = _withUserId(
          Request(
            'POST',
            Uri.parse('http://localhost/api/schedules/$_scheduleId/cancel'),
          ),
        );

        await handler.cancelSchedule(request, _scheduleId);

        expect(fakeService.cancelCalled, 1);
        expect(
          fakeService.lastCancelPostScheduleId,
          UuidValue.fromString(_scheduleId),
        );
        expect(
          fakeService.lastCancelUserId,
          UuidValue.fromString(_userId),
        );
      });

      test('returns 400 on invalid UUID in path', () {
        final request = _withUserId(
          Request(
            'POST',
            Uri.parse('http://localhost/api/schedules/bad-uuid/cancel'),
          ),
        );

        expect(
          () => handler.cancelSchedule(request, 'bad-uuid'),
          throwsA(isA<FormatException>()),
        );
      });
    });
  });
}
