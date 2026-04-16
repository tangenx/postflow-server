import 'dart:collection';
import 'dart:io';

import 'package:postflow_server/utils/api_response.dart';
import 'package:shelf/shelf.dart';

class RateLimiter {
  final int maxRequests;
  final Duration timeFrame;
  final _buckets = HashMap<String, _Bucket>();
  int _checksSinceCleanup = 0;

  RateLimiter({required this.maxRequests, required this.timeFrame});

  bool isAllowed(String key) {
    _checksSinceCleanup++;
    if (_checksSinceCleanup >= 200) {
      clear();
      _checksSinceCleanup = 0;
    }

    final bucket = _buckets.putIfAbsent(key, () => _Bucket());
    final now = DateTime.now();

    bucket.timestamps.removeWhere((t) => now.difference(t) > timeFrame);

    if (bucket.timestamps.length >= maxRequests) {
      return false;
    }

    bucket.timestamps.add(now);
    return true;
  }

  void clear() {
    final now = DateTime.now();
    _buckets.removeWhere(
      (_, bucket) =>
          bucket.timestamps.isEmpty ||
          bucket.timestamps.every((t) => now.difference(t) > timeFrame),
    );
  }
}

class _Bucket {
  final timestamps = <DateTime>[];
}

Middleware rateLimitMiddleware(
  Map<Pattern, RateLimiter> routeRules,
  RateLimiter globalRule,
) {
  return (Handler handler) {
    return (Request request) {
      final ip = _extractClientIp(request);

      final path = '/${request.url.path}';

      if (!globalRule.isAllowed(ip)) {
        return ApiResponse.error(
          429,
          'RATE_LIMIT_EXCEEDED',
          'Too many requests',
        );
      }

      for (final rule in routeRules.entries) {
        if (_matches(rule.key, path)) {
          final routeKey = rule.key is RegExp
              ? 're:${(rule.key as RegExp).pattern}'
              : 'path:${_normalizePath(rule.key.toString())}';
          final key = '$ip:${request.method}:$routeKey';

          if (!rule.value.isAllowed(key)) {
            return ApiResponse.error(
              429,
              'RATE_LIMIT_EXCEEDED',
              'Too many requests',
            );
          }

          break;
        }
      }

      return handler(request);
    };
  };
}

String _extractClientIp(Request request) {
  final forwardedFor = request.headers['x-forwarded-for'];
  final realIp = request.headers['x-real-ip'];

  if (forwardedFor != null) {
    final ip = forwardedFor.split(',').first.trim();
    if (ip.isNotEmpty) {
      return ip;
    }
  }

  if (realIp != null && realIp.trim().isNotEmpty) {
    return realIp.trim();
  }

  final connectionInfo = request.context['shelf.io.connection_info'];
  if (connectionInfo is HttpConnectionInfo) {
    final ip = connectionInfo.remoteAddress.address.trim();
    if (ip.isNotEmpty) {
      return ip;
    }
  }

  return 'unknown';
}

bool _matches(Pattern pattern, String path) {
  if (pattern is RegExp) {
    return pattern.hasMatch(path);
  }

  return _normalizePath(pattern.toString()) == _normalizePath(path);
}

String _normalizePath(String path) {
  final normalized = path.startsWith('/') ? path : '/$path';
  return normalized.endsWith('/') && normalized.length > 1
      ? normalized.substring(0, normalized.length - 1)
      : normalized;
}
