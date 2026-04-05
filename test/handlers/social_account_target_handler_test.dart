import 'dart:convert';

import 'package:drift_postgres/drift_postgres.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';
import 'package:postflow_server/core/exceptions.dart';
import 'package:postflow_server/database/database.dart';
import 'package:postflow_server/handlers/social_account_target_handler.dart';

// ---------------------------------------------------------------------------
// Fake DAOs
// ---------------------------------------------------------------------------

class FakeSocialAccountTargetsDao implements SocialAccountTargetsDao {
  final List<SocialAccountTarget> _targets;
  Object? _exception;
  SocialAccountTarget? createdTarget;
  SocialAccountTarget? updatedTarget;
  int deleteCallCount = 0;
  (UuidValue, UuidValue)? deleteCalledWith;

  FakeSocialAccountTargetsDao([this._targets = const []]);

  void setException(Object ex) => _exception = ex;

  void _maybeThrow() {
    if (_exception != null) throw _exception!;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  Future<List<SocialAccountTarget>> findByAccount(UuidValue accountId) async {
    _maybeThrow();
    return _targets.where((t) => t.userSocialAccountId == accountId).toList();
  }

  @override
  Future<SocialAccountTarget> create({
    required UuidValue userSocialAccountId,
    required String targetType,
    required String targetId,
    String? targetLabel,
    String? shortLink,
  }) async {
    _maybeThrow();
    final target = SocialAccountTarget(
      id: UuidValue.fromString('33333333-3333-4333-8333-333333333333'),
      userSocialAccountId: userSocialAccountId,
      targetType: targetType,
      targetId: targetId,
      targetLabel: targetLabel,
      shortLink: shortLink,
      isActive: true,
    );
    createdTarget = target;
    return target;
  }

  @override
  Future<SocialAccountTarget> updateTarget({
    required UuidValue id,
    required UuidValue userId,
    String? targetLabel,
    String? shortLink,
    bool? isActive,
  }) async {
    _maybeThrow();
    final existing = _targets.where((t) => t.id == id).firstOrNull;
    if (existing == null) {
      throw NotFoundException('Target not found');
    }
    final updated = SocialAccountTarget(
      id: existing.id,
      userSocialAccountId: existing.userSocialAccountId,
      targetType: existing.targetType,
      targetId: existing.targetId,
      targetLabel: targetLabel ?? existing.targetLabel,
      shortLink: shortLink ?? existing.shortLink,
      isActive: isActive ?? existing.isActive,
    );
    updatedTarget = updated;
    return updated;
  }

  @override
  Future<void> deleteTarget(UuidValue id, UuidValue userId) async {
    _maybeThrow();
    deleteCallCount++;
    deleteCalledWith = (id, userId);
    final found = _targets.any((t) => t.id == id);
    if (!found) {
      throw NotFoundException('Target not found');
    }
  }
}

class FakeUserSocialAccountsDao implements UserSocialAccountsDao {
  UserSocialAccount? findByIdAndUserResult;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  Future<UserSocialAccount?> findByIdAndUser(
    UuidValue id,
    UuidValue userId,
  ) async {
    return findByIdAndUserResult;
  }
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

const _userId = '11111111-1111-4111-8111-111111111111';
const _accountId = '22222222-2222-4222-8222-222222222222';
const _targetId = '33333333-3333-4333-8333-333333333333';

final _testTarget = SocialAccountTarget(
  id: UuidValue.fromString(_targetId),
  userSocialAccountId: UuidValue.fromString(_accountId),
  targetType: 'channel',
  targetId: '-1001758061942',
  targetLabel: 'Test Channel',
  shortLink: 't.me/testchannel',
  isActive: true,
);

final _testTargets = [_testTarget];

final _ownedAccount = UserSocialAccount(
  id: UuidValue.fromString(_accountId),
  userId: UuidValue.fromString(_userId),
  socialNetworkId: UuidValue.fromString('44444444-4444-4444-8444-444444444444'),
  externalAccountId: 'ext-123',
  isActive: true,
  createdAt: PgDateTime(DateTime.utc(2024)),
);

Request _mockRequest({
  UuidValue? userId,
  String? body,
  String pathInfo = 'test',
}) {
  final uri = Uri.parse('http://localhost/api/social-accounts/$pathInfo');
  final request = Request(
    'GET',
    uri,
    body: body,
    headers: body != null ? {'content-type': 'application/json'} : {},
  );
  if (userId != null) {
    return request.change(context: {'userId': userId});
  }
  return request;
}

Future<Map<String, dynamic>> _parseBody(Response response) async {
  return jsonDecode(await response.readAsString()) as Map<String, dynamic>;
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  late FakeSocialAccountTargetsDao fakeTargetsDao;
  late FakeUserSocialAccountsDao fakeAccountsDao;
  late SocialAccountTargetHandler handler;
  final userId = UuidValue.fromString(_userId);

  setUp(() {
    fakeTargetsDao = FakeSocialAccountTargetsDao(List.of(_testTargets));
    fakeAccountsDao = FakeUserSocialAccountsDao();
    handler = SocialAccountTargetHandler(
      socialAccountTargetsDao: fakeTargetsDao,
      accountsDao: fakeAccountsDao,
    );
  });

  group('SocialAccountTargetHandler', () {
    group('getTargets', () {
      test('returns list of targets for owned account', () async {
        fakeAccountsDao.findByIdAndUserResult = _ownedAccount;
        final request = _mockRequest(userId: userId);

        final response = await handler.getTargets(request, _accountId);

        expect(response.statusCode, equals(200));
        final body = await _parseBody(response);
        expect(body['ok'], isTrue);
        expect((body['data'] as List).length, equals(1));
        expect(body['data'][0]['targetType'], equals('channel'));
      });

      test('returns empty list when no targets', () async {
        fakeTargetsDao = FakeSocialAccountTargetsDao();
        handler = SocialAccountTargetHandler(
          socialAccountTargetsDao: fakeTargetsDao,
          accountsDao: fakeAccountsDao,
        );
        fakeAccountsDao.findByIdAndUserResult = _ownedAccount;
        final request = _mockRequest(userId: userId);

        final response = await handler.getTargets(request, _accountId);

        expect(response.statusCode, equals(200));
        final body = await _parseBody(response);
        expect(body['ok'], isTrue);
        expect((body['data'] as List), isEmpty);
      });

      test('returns 404 when account not found', () async {
        fakeAccountsDao.findByIdAndUserResult = null;
        final request = _mockRequest(userId: userId);

        final response = await handler.getTargets(request, _accountId);

        expect(response.statusCode, equals(404));
        final body = await _parseBody(response);
        expect(body['ok'], isFalse);
        expect(body['error']['code'], equals('NOT_FOUND'));
      });

      test('returns 404 for different user\'s account', () async {
        fakeAccountsDao.findByIdAndUserResult = null;
        final request = _mockRequest(userId: userId);

        final response = await handler.getTargets(request, _accountId);

        expect(response.statusCode, equals(404));
        final body = await _parseBody(response);
        expect(body['ok'], isFalse);
      });

      test('returns 400 for invalid accountId UUID', () {
        final request = _mockRequest(userId: userId);

        expect(
          () => handler.getTargets(request, 'not-a-uuid'),
          throwsA(isA<FormatException>()),
        );
      });
    });

    group('create', () {
      test('creates target and returns JSON', () async {
        fakeAccountsDao.findByIdAndUserResult = _ownedAccount;
        final request = _mockRequest(
          userId: userId,
          body: jsonEncode({
            'targetType': 'channel',
            'targetId': '-1001758061942',
            'targetLabel': 'My Channel',
            'shortLink': 't.me/mychannel',
          }),
        );

        final response = await handler.create(request, _accountId);

        expect(response.statusCode, equals(200));
        final body = await _parseBody(response);
        expect(body['ok'], isTrue);
        expect(body['data']['targetType'], equals('channel'));
        expect(body['data']['targetId'], equals('-1001758061942'));
        expect(body['data']['targetLabel'], equals('My Channel'));
        expect(fakeTargetsDao.createdTarget, isNotNull);
      });

      test('returns 404 when account not found', () async {
        fakeAccountsDao.findByIdAndUserResult = null;
        final request = _mockRequest(
          userId: userId,
          body: jsonEncode({
            'targetType': 'channel',
            'targetId': '-1001758061942',
          }),
        );

        final response = await handler.create(request, _accountId);

        expect(response.statusCode, equals(404));
        final body = await _parseBody(response);
        expect(body['ok'], isFalse);
        expect(body['error']['code'], equals('NOT_FOUND'));
      });

      test('returns 400 for missing targetType', () async {
        fakeAccountsDao.findByIdAndUserResult = _ownedAccount;
        final request = _mockRequest(
          userId: userId,
          body: jsonEncode({'targetId': '-1001758061942'}),
        );

        expect(
          () => handler.create(request, _accountId),
          throwsA(isA<ValidationException>()),
        );
      });

      test('returns 400 for invalid targetType', () async {
        fakeAccountsDao.findByIdAndUserResult = _ownedAccount;
        final request = _mockRequest(
          userId: userId,
          body: jsonEncode({
            'targetType': 'invalid',
            'targetId': '-1001758061942',
          }),
        );

        expect(
          () => handler.create(request, _accountId),
          throwsA(isA<ValidationException>()),
        );
      });

      test('returns 400 for missing targetId', () async {
        fakeAccountsDao.findByIdAndUserResult = _ownedAccount;
        final request = _mockRequest(
          userId: userId,
          body: jsonEncode({'targetType': 'channel'}),
        );

        expect(
          () => handler.create(request, _accountId),
          throwsA(isA<ValidationException>()),
        );
      });

      test('returns 400 for invalid accountId UUID', () async {
        fakeAccountsDao.findByIdAndUserResult = _ownedAccount;
        final request = _mockRequest(
          userId: userId,
          body: jsonEncode({
            'targetType': 'channel',
            'targetId': '-1001758061942',
          }),
        );

        expect(
          () => handler.create(request, 'not-a-uuid'),
          throwsA(isA<FormatException>()),
        );
      });

      test('returns 400 for empty body', () async {
        fakeAccountsDao.findByIdAndUserResult = _ownedAccount;
        final request = _mockRequest(userId: userId, body: '');

        expect(
          () => handler.create(request, _accountId),
          throwsA(isA<ValidationException>()),
        );
      });
    });

    group('update', () {
      test('updates target and returns JSON', () async {
        final request = _mockRequest(
          userId: userId,
          body: jsonEncode({'targetLabel': 'Updated Label'}),
        );

        final response = await handler.update(request, _accountId, _targetId);

        expect(response.statusCode, equals(200));
        final body = await _parseBody(response);
        expect(body['ok'], isTrue);
        expect(body['data']['targetLabel'], equals('Updated Label'));
        expect(fakeTargetsDao.updatedTarget, isNotNull);
      });

      test('returns 404 when target not found', () async {
        fakeTargetsDao.setException(NotFoundException('Target not found'));
        final request = _mockRequest(
          userId: userId,
          body: jsonEncode({'targetLabel': 'X'}),
        );

        expect(
          () => handler.update(request, _accountId, _targetId),
          throwsA(isA<NotFoundException>()),
        );
      });

      test('returns 400 for invalid targetId UUID', () async {
        final request = _mockRequest(
          userId: userId,
          body: jsonEncode({'targetLabel': 'X'}),
        );

        expect(
          () => handler.update(request, _accountId, 'bad-uuid'),
          throwsA(isA<FormatException>()),
        );
      });

      test('returns 400 for invalid targetType when provided', () async {
        final request = _mockRequest(
          userId: userId,
          body: jsonEncode({'targetType': 'invalid_type'}),
        );

        expect(
          () => handler.update(request, _accountId, _targetId),
          throwsA(isA<ValidationException>()),
        );
      });
    });

    group('delete', () {
      test('deletes target and returns ok(null)', () async {
        final request = _mockRequest(userId: userId);

        final response = await handler.delete(request, _targetId);

        expect(response.statusCode, equals(200));
        final body = await _parseBody(response);
        expect(body['ok'], isTrue);
        expect(body['data'], isNull);
        expect(fakeTargetsDao.deleteCallCount, equals(1));
        expect(
          fakeTargetsDao.deleteCalledWith?.$1.toString(),
          equals(_targetId),
        );
        expect(fakeTargetsDao.deleteCalledWith?.$2, equals(userId));
      });

      test('returns 404 when target not found', () async {
        fakeTargetsDao.setException(NotFoundException('Target not found'));
        final request = _mockRequest(userId: userId);

        expect(
          () => handler.delete(request, _targetId),
          throwsA(isA<NotFoundException>()),
        );
      });

      test('returns 400 for invalid UUID', () {
        final request = _mockRequest(userId: userId);

        expect(
          () => handler.delete(request, 'bad-uuid'),
          throwsA(isA<FormatException>()),
        );
      });
    });
  });
}
