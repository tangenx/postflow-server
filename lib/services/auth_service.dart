import 'package:drift_postgres/drift_postgres.dart';

import '../core/exceptions.dart';
import '../database/database.dart';
import '../utils/password_utils.dart';
import 'jwt_service.dart';

class AuthService {
  final UsersDao _usersDao;
  final UserIdentitiesDao _userIdentitiesDao;
  final RefreshTokensDao _refreshTokensDao;
  final JwtService _jwtService;

  AuthService({
    required UserIdentitiesDao userIdentitiesDao,
    required JwtService jwtService,
    required UsersDao usersDao,
    required RefreshTokensDao refreshTokensDao,
  }) : _refreshTokensDao = refreshTokensDao,
       _usersDao = usersDao,
       _jwtService = jwtService,
       _userIdentitiesDao = userIdentitiesDao;

  // registration using username and password
  Future<AuthData> register(
    String username,
    String password, {
    String? email,
  }) async {
    final existingUsername = await _usersDao.findByUsername(username);

    if (existingUsername != null) {
      throw ConflictException('Username already taken');
    }

    if (email != null) {
      final existingEmail = await _usersDao.findByEmail(email);

      if (existingEmail != null) {
        throw ConflictException('Email already taken');
      }
    }

    final user = await _usersDao.createUser(username: username, email: email);

    await _userIdentitiesDao.createLocalUserIdentity(
      userId: user.id,
      passwordHash: PasswordUtils.hash(password),
    );

    return _issueTokens(user.id);
  }

  // login using username (or email) and password
  Future<AuthData> login(String usernameOrEmail, String password) async {
    final user = await _usersDao.findByUsernameOrEmail(usernameOrEmail);

    if (user == null) {
      throw UnauthorizedException('Invalid username or email');
    }

    final userIdentity = await _userIdentitiesDao.findLocalByUserId(user.id);
    if (userIdentity == null) {
      throw UnauthorizedException('Invalid username or email');
    }

    // because this is a LOCAL identity, we 100% sure that passwordHash is not null
    if (!PasswordUtils.verify(password, userIdentity.passwordHash!)) {
      throw UnauthorizedException('Invalid username or password');
    }

    return _issueTokens(user.id);
  }

  // TODO: login using social account (oauth)

  // refresh the access token
  Future<AuthData> refresh(String refreshToken) async {
    final userId = _jwtService.verifyRefreshToken(refreshToken);

    if (userId == null) {
      throw UnauthorizedException('Invalid refresh token');
    }

    final storedRefreshToken = await _refreshTokensDao.findByHash(refreshToken);
    if (storedRefreshToken == null) {
      throw UnauthorizedException('Invalid refresh token');
    }
    if (storedRefreshToken.expiresAt.toDateTime().isBefore(.now())) {
      throw UnauthorizedException('Refresh token expired');
    }

    // revoke the old refresh token
    await _refreshTokensDao.revoke(storedRefreshToken.id);

    return _issueTokens(storedRefreshToken.userId);
  }

  // generate an access token and a refresh token for the given user ID
  Future<AuthData> _issueTokens(UuidValue userId) async {
    final accessToken = _jwtService.generateAccessToken(userId.toString());
    final refrestToken = _jwtService.generateRefreshToken(userId.toString());

    await _refreshTokensDao.store(
      userId,
      refrestToken,
      DateTime.now().add(Duration(days: 30)),
    );

    return AuthData(accessToken: accessToken, refreshToken: refrestToken);
  }
}

class AuthData {
  final String accessToken;
  final String refreshToken;

  AuthData({required this.accessToken, required this.refreshToken});
}
