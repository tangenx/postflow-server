import 'dart:convert';
import 'dart:math';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

import '../config/app_config.dart';

class JwtService {
  final SecretKey _accessKey;
  final Duration _accessTtl;

  JwtService(AppConfig config)
    : _accessKey = SecretKey(config.jwtSecret),
      _accessTtl = config.jwtAccessTtl;

  /// generates a short-lived access token for the given [userId]
  String generateAccessToken(String userId) {
    final jwt = JWT({'type': 'access'}, subject: userId);

    return jwt.sign(_accessKey, expiresIn: _accessTtl);
  }

  /// generates a long-lived refresh token for the given [userId]
  String generateRefreshToken(String userId) {
    final random = Random.secure();
    final bytes = List<int>.generate(32, (_) => random.nextInt(256));
    return base64Encode(bytes);
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
}
