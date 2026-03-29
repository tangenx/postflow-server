import 'dart:collection';

import 'package:postflow_server/utils/api_response.dart';
import 'package:shelf/shelf.dart';

class RateLimiter {
  final int maxRequests;
  final Duration timeFrame;
  final _buckets = HashMap<String, _Bucket>();

  RateLimiter({required this.maxRequests, required this.timeFrame});

  bool isAllowed(String key) {
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
  final timestamps = List<DateTime>.empty();
}

Middleware rateLimitMiddleware(
  Map<Pattern, RateLimiter> rules,
  RateLimiter defaultRule,
) {
  return (Handler handler) {
    return (Request request) {
      final ip =
          request.headers['x-forwarded-for'] ??
          request.headers['x-real-ip'] ??
          request.requestedUri.host;

      final path = '/${request.requestedUri.path}';

      final limiter = rules.entries
          .firstWhere(
            (e) => e.key.allMatches(path).isNotEmpty,
            orElse: () => MapEntry(RegExp('.*'), defaultRule),
          )
          .value;

      if (!limiter.isAllowed('$ip:$path')) {
        return ApiResponse.error(
          429,
          'RATE_LIMIT_EXCEEDED',
          'Too many requests',
        );
      }

      return handler(request);
    };
  };
}
