import 'package:drift_postgres/drift_postgres.dart';

import '../adapters/adapter_registry.dart';
import '../core/exceptions.dart';
import '../database/database.dart';

class UserSocialAccountService {
  final UserSocialAccountsDao _accountsDao;
  final SocialNetworksDao _networksDao;
  final AdapterRegistry _adapterRegistry;

  UserSocialAccountService({
    required UserSocialAccountsDao accountsDao,
    required SocialNetworksDao networksDao,
    required AdapterRegistry adapterRegistry,
  })  : _accountsDao = accountsDao,
        _networksDao = networksDao,
        _adapterRegistry = adapterRegistry;

  Future<UserSocialAccount> create({
    required UuidValue userId,
    required UuidValue socialNetworkId,
    required String accessToken,
    String? refreshToken,
    DateTime? tokenExpiresAt,
  }) async {
    final network = await _networksDao.findById(socialNetworkId);
    if (network == null) {
      throw NotFoundException('Social network not found');
    }

    final adapter = _adapterRegistry.get(network.slug)!;
    final verified = await adapter.verifyToken(accessToken);

    return _accountsDao.create(
      userId: userId,
      socialNetworkId: socialNetworkId,
      externalAccountId: verified.externalAccountId,
      screenName: verified.screenName,
      accessToken: accessToken,
      refreshToken: refreshToken,
      tokenExpiresAt: tokenExpiresAt,
    );
  }

  Future<List<AccountWithNetwork>> getAccounts(UuidValue userId) {
    return _accountsDao.findByUser(userId);
  }

  Future<UserSocialAccount?> getAccount(UuidValue id, UuidValue userId) {
    return _accountsDao.findByIdAndUser(id, userId);
  }

  Future<UserSocialAccount> update({
    required UuidValue id,
    required UuidValue userId,
    String? screenName,
    String? accessToken,
    String? refreshToken,
    DateTime? tokenExpiresAt,
    bool? isActive,
  }) {
    return _accountsDao.updateSocialAccount(
      id: id,
      userId: userId,
      screenName: screenName,
      accessToken: accessToken,
      refreshToken: refreshToken,
      tokenExpiresAt: tokenExpiresAt,
      isActive: isActive,
    );
  }

  Future<void> delete(UuidValue id, UuidValue userId) {
    return _accountsDao.deleteSocialAccount(id, userId);
  }
}
