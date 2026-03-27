import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

import '../config/app_config.dart';

class JwtService {
  final SecretKey _accessKey;
  final SecretKey _refreshKey;
  final Duration _accessTtl;
  final Duration _refreshTtl;

  JwtService(AppConfig config)
    : _accessKey = SecretKey(config.jwtSecret),
      _refreshKey = SecretKey(config.jwtRefreshSecret),
      _accessTtl = config.jwtAccessTtl,
      _refreshTtl = config.jwtRefreshTtl;

  /// generates a short-lived access token for the given [userId]
  String generateAccessToken(String userId) {
    final jwt = JWT({'type': 'access'}, subject: userId);

    return jwt.sign(_accessKey, expiresIn: _accessTtl);
  }

  /// generates a long-lived refresh token for the given [userId]
  String generateRefreshToken(String userId) {
    final jwt = JWT({'type': 'refresh'}, subject: userId);

    return jwt.sign(_refreshKey, expiresIn: _refreshTtl);
  }

  /// verifies an access token and returns the user ID on success
  /// returns `null` if the token is invalid or expired
  String? verifyAccessToken(String token) {
    final jwt = JWT.tryVerify(token, _accessKey);

    if (jwt == null || jwt.subject == null) return null;

    final payload = jwt.payload;
    if (payload is Map && payload['type'] != 'access') return null;

    return jwt.subject;
  }

  /// verifies a refresh token and returns the user ID on success
  /// returns `null` if the token is invalid or expired
  String? verifyRefreshToken(String token) {
    final jwt = JWT.tryVerify(token, _refreshKey);

    if (jwt == null || jwt.subject == null) return null;

    final payload = jwt.payload;
    if (payload is Map && payload['type'] != 'refresh') return null;

    return jwt.subject;
  }
}
