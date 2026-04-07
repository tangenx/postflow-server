import 'package:drift_postgres/drift_postgres.dart';
import 'package:test/test.dart';
import 'package:postflow_server/core/exceptions.dart';
import 'package:postflow_server/database/database.dart';
import 'package:postflow_server/services/user_social_account_service.dart';
import 'package:postflow_server/adapters/adapter_registry.dart';
import 'package:postflow_server/adapters/social_adapter.dart';
import 'dart:typed_data';

// ---------------------------------------------------------------------------
// Fakes
// ---------------------------------------------------------------------------

class FakeUserSocialAccountsDao implements UserSocialAccountsDao {
  UserSocialAccount? createResult;
  UuidValue? createUserId;
  UuidValue? createSocialNetworkId;
  String? createExternalAccountId;
  String? createScreenName;
  String? createAccessToken;
  String? createRefreshToken;
  DateTime? createTokenExpiresAt;
  int createCallCount = 0;

  List<AccountWithNetwork> findByUserResult = [];
  UserSocialAccount? findByIdAndUserResult;
  UserSocialAccount? updateResult;
  int deleteCallCount = 0;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  Future<UserSocialAccount> create({
    required UuidValue userId,
    required UuidValue socialNetworkId,
    required String externalAccountId,
    String? screenName,
    String? accessToken,
    String? refreshToken,
    DateTime? tokenExpiresAt,
  }) async {
    createCallCount++;
    createUserId = userId;
    createSocialNetworkId = socialNetworkId;
    createExternalAccountId = externalAccountId;
    createScreenName = screenName;
    createAccessToken = accessToken;
    createRefreshToken = refreshToken;
    createTokenExpiresAt = tokenExpiresAt;
    return createResult ??
        UserSocialAccount(
          id: UuidValue.fromString('a10e8400-e29b-41d4-a716-446655440003'),
          userId: userId,
          socialNetworkId: socialNetworkId,
          externalAccountId: externalAccountId,
          screenName: screenName,
          accessToken: accessToken,
          refreshToken: refreshToken,
          tokenExpiresAt: tokenExpiresAt != null
              ? PgDateTime(tokenExpiresAt)
              : null,
          isActive: true,
          createdAt: PgDateTime(DateTime.utc(2025)),
        );
  }

  @override
  Future<List<AccountWithNetwork>> findByUser(UuidValue userId) async =>
      findByUserResult;

  @override
  Future<UserSocialAccount?> findByIdAndUser(
    UuidValue id,
    UuidValue userId,
  ) async => findByIdAndUserResult;

  @override
  Future<UserSocialAccount> updateSocialAccount({
    required UuidValue id,
    required UuidValue userId,
    String? screenName,
    String? accessToken,
    String? refreshToken,
    DateTime? tokenExpiresAt,
    bool? isActive,
  }) async => updateResult ?? (throw NotFoundException('not found'));

  @override
  Future<void> deleteSocialAccount(UuidValue id, UuidValue userId) async {
    deleteCallCount++;
  }
}

class FakeSocialNetworksDao implements SocialNetworksDao {
  SocialNetwork? findByIdResult;
  UuidValue? findByIdArg;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  Future<SocialNetwork?> findById(UuidValue id) async {
    findByIdArg = id;
    return findByIdResult;
  }
}

class FakeSocialAdapter implements SocialAdapter {
  @override
  String get slug => 'test_network';

  String? lastVerifyToken;
  ({String externalAccountId, String screenName})? verifyTokenResult;
  Object? verifyTokenException;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  Future<({String externalAccountId, String screenName})> verifyToken(
    String accessToken,
  ) async {
    lastVerifyToken = accessToken;
    if (verifyTokenException != null) throw verifyTokenException!;
    return verifyTokenResult ?? (externalAccountId: '12345', screenName: 'test');
  }

  @override
  Future<String> publishPost({
    required String accessToken,
    required String targetId,
    required String targetType,
    required List<MediaFileWithMediaType> mediaFiles,
    required List<Uint8List?> mediaBytes,
    required String? caption,
  }) async => 'external-post-id';
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

const _userId = 'a10e8400-e29b-41d4-a716-446655440000';
const _networkId = 'b20e8400-e29b-41d4-a716-446655440001';

final _testNetwork = SocialNetwork(
  id: UuidValue.fromString(_networkId),
  slug: 'test_network',
  displayName: 'Test Network',
  capabilities: '{}',
  isActive: true,
);

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  late FakeUserSocialAccountsDao fakeAccountsDao;
  late FakeSocialNetworksDao fakeNetworksDao;
  late FakeSocialAdapter fakeAdapter;
  late AdapterRegistry registry;
  late UserSocialAccountService service;

  setUp(() {
    fakeAccountsDao = FakeUserSocialAccountsDao();
    fakeNetworksDao = FakeSocialNetworksDao();
    fakeAdapter = FakeSocialAdapter();
    registry = AdapterRegistry()..register(fakeAdapter);
    service = UserSocialAccountService(
      accountsDao: fakeAccountsDao,
      networksDao: fakeNetworksDao,
      adapterRegistry: registry,
    );
  });

  group('UserSocialAccountService', () {
    group('create', () {
      test('verifies token and creates account with returned data', () async {
        fakeNetworksDao.findByIdResult = _testNetwork;
        fakeAdapter.verifyTokenResult = (
          externalAccountId: '9876543210',
          screenName: 'verified_user',
        );

        final result = await service.create(
          userId: UuidValue.fromString(_userId),
          socialNetworkId: UuidValue.fromString(_networkId),
          accessToken: 'my-token',
        );

        expect(fakeAccountsDao.createCallCount, 1);
        expect(fakeAccountsDao.createExternalAccountId, '9876543210');
        expect(fakeAccountsDao.createScreenName, 'verified_user');
        expect(fakeAccountsDao.createAccessToken, 'my-token');
        expect(result, isNotNull);
      });

      test('throws NotFoundException when network not found', () {
        fakeNetworksDao.findByIdResult = null;

        expect(
          () => service.create(
            userId: UuidValue.fromString(_userId),
            socialNetworkId: UuidValue.fromString(_networkId),
            accessToken: 'my-token',
          ),
          throwsA(
            isA<NotFoundException>().having(
              (e) => e.message,
              'message',
              contains('Social network not found'),
            ),
          ),
        );
      });

      test('throws ValidationException when adapter verifyToken fails', () {
        fakeNetworksDao.findByIdResult = _testNetwork;
        fakeAdapter.verifyTokenException =
            ValidationException('Invalid token');

        expect(
          () => service.create(
            userId: UuidValue.fromString(_userId),
            socialNetworkId: UuidValue.fromString(_networkId),
            accessToken: 'bad-token',
          ),
          throwsA(isA<ValidationException>()),
        );
      });

      test('passes refreshToken and tokenExpiresAt to DAO', () async {
        fakeNetworksDao.findByIdResult = _testNetwork;
        final expiresAt = DateTime.utc(2026, 6, 1);

        await service.create(
          userId: UuidValue.fromString(_userId),
          socialNetworkId: UuidValue.fromString(_networkId),
          accessToken: 'my-token',
          refreshToken: 'my-refresh',
          tokenExpiresAt: expiresAt,
        );

        expect(fakeAccountsDao.createRefreshToken, 'my-refresh');
        expect(fakeAccountsDao.createTokenExpiresAt, expiresAt);
      });
    });

    group('getAccounts', () {
      test('delegates to DAO', () async {
        fakeAccountsDao.findByUserResult = [];

        final result = await service.getAccounts(
          UuidValue.fromString(_userId),
        );

        expect(result, isEmpty);
      });
    });

    group('getAccount', () {
      test('delegates to DAO', () async {
        fakeAccountsDao.findByIdAndUserResult = null;

        final result = await service.getAccount(
          UuidValue.fromString(_networkId),
          UuidValue.fromString(_userId),
        );

        expect(result, isNull);
      });
    });

    group('update', () {
      test('delegates to DAO', () async {
        final updated = UserSocialAccount(
          id: UuidValue.fromString(_networkId),
          userId: UuidValue.fromString(_userId),
          socialNetworkId: UuidValue.fromString(_networkId),
          externalAccountId: '123',
          screenName: 'updated',
          isActive: true,
          createdAt: PgDateTime(DateTime.utc(2025)),
        );
        fakeAccountsDao.updateResult = updated;

        final result = await service.update(
          id: UuidValue.fromString(_networkId),
          userId: UuidValue.fromString(_userId),
          screenName: 'updated',
        );

        expect(result.screenName, 'updated');
      });
    });

    group('delete', () {
      test('delegates to DAO', () async {
        await service.delete(
          UuidValue.fromString(_networkId),
          UuidValue.fromString(_userId),
        );

        expect(fakeAccountsDao.deleteCallCount, 1);
      });
    });
  });
}
