import 'dart:convert';

import 'package:drift_postgres/drift_postgres.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';
import 'package:postflow_server/core/exceptions.dart';
import 'package:postflow_server/database/database.dart';
import 'package:postflow_server/handlers/user_social_account_handler.dart';
import 'package:postflow_server/services/user_social_account_service.dart';

// ---------------------------------------------------------------------------
// Fake service
// ---------------------------------------------------------------------------

class FakeUserSocialAccountService implements UserSocialAccountService {
  List<AccountWithNetwork> accountsWithNetwork = [];
  UserSocialAccount? findByIdAndUserResult;
  UserSocialAccount? createdAccount;
  UserSocialAccount? updatedAccount;
  int deleteCallCount = 0;
  Object? _exception;

  // Tracking fields for create
  UuidValue? createUserId;
  UuidValue? createSocialNetworkId;
  String? createAccessToken;
  String? createRefreshToken;
  DateTime? createTokenExpiresAt;

  void setException(Object ex) => _exception = ex;

  void _maybeThrow() {
    if (_exception != null) throw _exception!;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  Future<UserSocialAccount> create({
    required UuidValue userId,
    required UuidValue socialNetworkId,
    required String accessToken,
    String? refreshToken,
    DateTime? tokenExpiresAt,
  }) async {
    _maybeThrow();
    createUserId = userId;
    createSocialNetworkId = socialNetworkId;
    createAccessToken = accessToken;
    createRefreshToken = refreshToken;
    createTokenExpiresAt = tokenExpiresAt;
    final account = UserSocialAccount(
      id: UuidValue.fromString('33333333-3333-4333-8333-333333333333'),
      userId: userId,
      socialNetworkId: socialNetworkId,
      externalAccountId: '1234567890',
      screenName: 'testuser',
      accessToken: accessToken,
      refreshToken: refreshToken,
      tokenExpiresAt: tokenExpiresAt != null
          ? PgDateTime(tokenExpiresAt)
          : null,
      isActive: true,
      createdAt: PgDateTime(DateTime.utc(2025)),
    );
    createdAccount = account;
    return account;
  }

  @override
  Future<List<AccountWithNetwork>> getAccounts(UuidValue userId) async {
    _maybeThrow();
    return accountsWithNetwork;
  }

  @override
  Future<UserSocialAccount?> getAccount(
    UuidValue id,
    UuidValue userId,
  ) async {
    _maybeThrow();
    return findByIdAndUserResult;
  }

  @override
  Future<UserSocialAccount> update({
    required UuidValue id,
    required UuidValue userId,
    String? screenName,
    String? accessToken,
    String? refreshToken,
    DateTime? tokenExpiresAt,
    bool? isActive,
  }) async {
    _maybeThrow();
    return updatedAccount ?? (throw NotFoundException('Account not found'));
  }

  @override
  Future<void> delete(UuidValue id, UuidValue userId) async {
    _maybeThrow();
    deleteCallCount++;
  }
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

const _userId = '11111111-1111-4111-8111-111111111111';
const _socialNetworkId = '22222222-2222-4222-8222-222222222222';
const _accountId = '33333333-3333-4333-8333-333333333333';
const _externalAccountId = '1234567890';
const _screenName = 'testuser';

final _testAccount = UserSocialAccount(
  id: UuidValue.fromString(_accountId),
  userId: UuidValue.fromString(_userId),
  socialNetworkId: UuidValue.fromString(_socialNetworkId),
  externalAccountId: _externalAccountId,
  screenName: _screenName,
  accessToken: 'access-token-123',
  refreshToken: 'refresh-token-456',
  tokenExpiresAt: PgDateTime(DateTime.utc(2026, 1, 1)),
  isActive: true,
  createdAt: PgDateTime(DateTime.utc(2025)),
);

final _testNetwork = SocialNetwork(
  id: UuidValue.fromString(_socialNetworkId),
  slug: 'twitter',
  displayName: 'Twitter',
  capabilities: const {},
  isActive: true,
);

final _testAccountWithNetwork = AccountWithNetwork(
  account: _testAccount,
  network: _testNetwork,
);

Request _mockRequest({UuidValue? userId, String? body, String method = 'GET'}) {
  final uri = Uri.parse('http://localhost/api/social-accounts');
  final request = Request(
    method,
    uri,
    body: body,
    headers: body != null ? {'content-type': 'application/json'} : {},
  );
  if (userId != null) {
    return request.change(context: {'userId': userId});
  }
  return request;
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

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  late FakeUserSocialAccountService fakeService;
  late UserSocialAccountHandler handler;

  setUp(() {
    fakeService = FakeUserSocialAccountService();
    handler = UserSocialAccountHandler(fakeService);
  });

  group('UserSocialAccountHandler', () {
    group('getAccounts', () {
      test('returns list of accounts as JSON', () async {
        fakeService.accountsWithNetwork = [_testAccountWithNetwork];
        final request = _mockRequest(userId: UuidValue.fromString(_userId));

        final response = await handler.getAccounts(request);

        expect(response.statusCode, equals(200));
        final body = jsonDecode(await response.readAsString());
        expect(body['ok'], isTrue);
        final data = body['data'] as List;
        expect(data.length, equals(1));
        expect(data[0]['screenName'], equals(_screenName));
        expect(data[0]['network']['slug'], equals('twitter'));
      });

      test('returns empty list when no accounts', () async {
        fakeService.accountsWithNetwork = [];
        final request = _mockRequest(userId: UuidValue.fromString(_userId));

        final response = await handler.getAccounts(request);

        expect(response.statusCode, equals(200));
        final body = jsonDecode(await response.readAsString());
        expect(body['ok'], isTrue);
        expect(body['data'] as List, isEmpty);
      });

      test('throws when service throws', () async {
        fakeService.setException(Exception('DB error'));
        final request = _mockRequest(userId: UuidValue.fromString(_userId));

        expect(() => handler.getAccounts(request), throwsA(isA<Exception>()));
      });
    });

    group('getAccount', () {
      test('returns account when found', () async {
        fakeService.findByIdAndUserResult = _testAccount;
        final request = _mockRequest(userId: UuidValue.fromString(_userId));

        final response = await handler.getAccount(request, _accountId);

        expect(response.statusCode, equals(200));
        final body = jsonDecode(await response.readAsString());
        expect(body['ok'], isTrue);
        expect(body['data']['screenName'], equals(_screenName));
        expect(body['data'], isNot(contains('accessToken')));
        expect(body['data'], isNot(contains('refreshToken')));
      });

      test('returns 404 when not found', () async {
        fakeService.findByIdAndUserResult = null;
        final request = _mockRequest(userId: UuidValue.fromString(_userId));

        final response = await handler.getAccount(request, _accountId);

        expect(response.statusCode, equals(404));
        final body = jsonDecode(await response.readAsString());
        expect(body['ok'], isFalse);
        expect(body['error']['code'], equals('NOT_FOUND'));
      });

      test('returns 404 for different user\'s account', () async {
        fakeService.findByIdAndUserResult = null;
        final otherUserId = '99999999-9999-4999-8999-999999999999';
        final request = _mockRequest(userId: UuidValue.fromString(otherUserId));

        final response = await handler.getAccount(request, _accountId);

        expect(response.statusCode, equals(404));
      });

      test('returns 400 for invalid UUID', () {
        final request = _mockRequest(userId: UuidValue.fromString(_userId));

        expect(
          () => handler.getAccount(request, 'not-a-uuid'),
          throwsA(isA<FormatException>()),
        );
      });
    });

    group('create', () {
      test('creates account and returns safe JSON', () async {
        final request = _jsonPost('api/social-accounts', {
          'socialNetworkId': _socialNetworkId,
          'accessToken': 'access-token-123',
          'refreshToken': 'refresh-token-456',
        }).change(context: {'userId': UuidValue.fromString(_userId)});

        final response = await handler.create(request);

        expect(response.statusCode, equals(200));
        final body = jsonDecode(await response.readAsString());
        expect(body['ok'], isTrue);
        expect(body['data']['screenName'], equals('testuser'));
        expect(body['data']['externalAccountId'], equals('1234567890'));
        expect(body['data'], isNot(contains('accessToken')));
        expect(body['data'], isNot(contains('refreshToken')));
        expect(fakeService.createdAccount, isNotNull);
      });

      test('passes correct params to service', () async {
        final request = _jsonPost('api/social-accounts', {
          'socialNetworkId': _socialNetworkId,
          'accessToken': 'access-token-123',
          'refreshToken': 'refresh-token-456',
          'tokenExpiresAt': '2026-01-01T00:00:00.000Z',
        }).change(context: {'userId': UuidValue.fromString(_userId)});

        await handler.create(request);

        expect(fakeService.createUserId, UuidValue.fromString(_userId));
        expect(
          fakeService.createSocialNetworkId,
          UuidValue.fromString(_socialNetworkId),
        );
        expect(fakeService.createAccessToken, 'access-token-123');
        expect(fakeService.createRefreshToken, 'refresh-token-456');
        expect(
          fakeService.createTokenExpiresAt,
          DateTime.utc(2026, 1, 1),
        );
      });

      test('returns 400 for missing required fields', () async {
        final request = _jsonPost('api/social-accounts', {
          'refreshToken': 'x',
        }).change(context: {'userId': UuidValue.fromString(_userId)});

        expect(() => handler.create(request), throwsA(isA<TypeError>()));
      });

      test('returns 400 for invalid UUID in socialNetworkId', () async {
        final request = _jsonPost('api/social-accounts', {
          'socialNetworkId': 'not-a-uuid',
          'accessToken': 'token',
        }).change(context: {'userId': UuidValue.fromString(_userId)});

        expect(() => handler.create(request), throwsA(isA<FormatException>()));
      });

      test('returns 400 for empty body', () async {
        final request = _mockRequest(
          userId: UuidValue.fromString(_userId),
          method: 'POST',
        );

        expect(
          () => handler.create(request),
          throwsA(isA<ValidationException>()),
        );
      });

      test('returns 400 for invalid JSON', () async {
        final request = Request(
          'POST',
          Uri.parse('http://localhost/api/social-accounts'),
          body: 'not json',
          headers: {'content-type': 'application/json'},
        ).change(context: {'userId': UuidValue.fromString(_userId)});

        expect(
          () => handler.create(request),
          throwsA(isA<ValidationException>()),
        );
      });
    });

    group('update', () {
      test('updates screen name and returns safe JSON', () async {
        fakeService.updatedAccount = UserSocialAccount(
          id: UuidValue.fromString(_accountId),
          userId: UuidValue.fromString(_userId),
          socialNetworkId: UuidValue.fromString(_socialNetworkId),
          externalAccountId: _externalAccountId,
          screenName: 'updated-user',
          accessToken: null,
          refreshToken: null,
          tokenExpiresAt: null,
          isActive: true,
          createdAt: PgDateTime(DateTime.utc(2025)),
        );
        final request = _jsonPut('api/social-accounts/$_accountId', {
          'screenName': 'updated-user',
        }).change(context: {'userId': UuidValue.fromString(_userId)});

        final response = await handler.update(request, _accountId);

        expect(response.statusCode, equals(200));
        final body = jsonDecode(await response.readAsString());
        expect(body['ok'], isTrue);
        expect(body['data']['screenName'], equals('updated-user'));
      });

      test('returns 404 when account not found', () {
        fakeService.updatedAccount = null;
        final request = _jsonPut('api/social-accounts/$_accountId', {
          'screenName': 'updated-user',
        }).change(context: {'userId': UuidValue.fromString(_userId)});

        expect(
          () => handler.update(request, _accountId),
          throwsA(isA<NotFoundException>()),
        );
      });

      test('returns 400 for invalid UUID', () {
        final request = _jsonPut('api/social-accounts/bad-uuid', {
          'screenName': 'x',
        }).change(context: {'userId': UuidValue.fromString(_userId)});

        expect(
          () => handler.update(request, 'bad-uuid'),
          throwsA(isA<FormatException>()),
        );
      });

      test('throws NotFoundException from service', () {
        fakeService.setException(NotFoundException('Account not found'));
        final request = _jsonPut('api/social-accounts/$_accountId', {
          'screenName': 'x',
        }).change(context: {'userId': UuidValue.fromString(_userId)});

        expect(
          () => handler.update(request, _accountId),
          throwsA(isA<NotFoundException>()),
        );
      });
    });

    group('delete', () {
      test('deletes account and returns ok(null)', () async {
        final request = Request(
          'DELETE',
          Uri.parse('http://localhost/api/social-accounts/$_accountId'),
        ).change(context: {'userId': UuidValue.fromString(_userId)});

        final response = await handler.delete(request, _accountId);

        expect(response.statusCode, equals(200));
        final body = jsonDecode(await response.readAsString());
        expect(body['ok'], isTrue);
        expect(body['data'], isNull);
        expect(fakeService.deleteCallCount, equals(1));
      });

      test('returns 400 for invalid UUID', () {
        final request = Request(
          'DELETE',
          Uri.parse('http://localhost/api/social-accounts/bad-uuid'),
        ).change(context: {'userId': UuidValue.fromString(_userId)});

        expect(
          () => handler.delete(request, 'bad-uuid'),
          throwsA(isA<FormatException>()),
        );
      });

      test('service delete is called', () async {
        final request = Request(
          'DELETE',
          Uri.parse('http://localhost/api/social-accounts/$_accountId'),
        ).change(context: {'userId': UuidValue.fromString(_userId)});

        await handler.delete(request, _accountId);

        expect(fakeService.deleteCallCount, equals(1));
      });
    });
  });
}
