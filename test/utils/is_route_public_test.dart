import 'package:test/test.dart';
import 'package:postflow_server/utils/is_route_public.dart';

void main() {
  group('isRoutePublic', () {
    test('returns true for health', () {
      expect(isRoutePublic('health'), isTrue);
    });

    test('returns true for api/auth/login', () {
      expect(isRoutePublic('api/auth/login'), isTrue);
    });

    test('returns true for api/auth/register', () {
      expect(isRoutePublic('api/auth/register'), isTrue);
    });

    test('returns true for api/auth/refresh', () {
      expect(isRoutePublic('api/auth/refresh'), isTrue);
    });

    test('returns false for api/posts', () {
      expect(isRoutePublic('api/posts'), isFalse);
    });

    test('returns false for api/auth/logout', () {
      expect(isRoutePublic('api/auth/logout'), isFalse);
    });

    test('returns false for empty string', () {
      expect(isRoutePublic(''), isFalse);
    });

    test('returns false for unknown route', () {
      expect(isRoutePublic('api/unknown'), isFalse);
    });
  });
}
