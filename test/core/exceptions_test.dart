import 'package:test/test.dart';
import 'package:postflow_server/core/exceptions.dart';

void main() {
  group('AppException', () {
    test('stores message', () {
      final ex = AppException('test message');
      expect(ex.message, equals('test message'));
    });

    test('toString includes message', () {
      final ex = AppException('test message');
      expect(ex.toString(), equals('AppException: test message'));
    });

    test('toJson returns correct structure', () {
      final ex = AppException('test message');
      expect(
        ex.toJson(),
        equals({'status': 'error', 'message': 'test message'}),
      );
    });

    test('is an Exception', () {
      final ex = AppException('msg');
      expect(ex, isA<Exception>());
    });
  });

  group('UnauthorizedException', () {
    test('is an AppException', () {
      final ex = UnauthorizedException('unauthorized');
      expect(ex, isA<AppException>());
    });

    test('preserves message', () {
      final ex = UnauthorizedException('bad token');
      expect(ex.message, equals('bad token'));
    });

    test('can be caught as AppException', () {
      try {
        throw UnauthorizedException('test');
      } on AppException catch (e) {
        expect(e.message, equals('test'));
        expect(e, isA<UnauthorizedException>());
      }
    });

    test('toJson inherited from AppException', () {
      final ex = UnauthorizedException('bad');
      expect(
        ex.toJson(),
        equals({'status': 'error', 'message': 'bad'}),
      );
    });
  });

  group('ConflictException', () {
    test('is an AppException', () {
      final ex = ConflictException('conflict');
      expect(ex, isA<AppException>());
    });

    test('preserves message', () {
      final ex = ConflictException('duplicate');
      expect(ex.message, equals('duplicate'));
    });
  });

  group('NotFoundException', () {
    test('is an AppException', () {
      final ex = NotFoundException('not found');
      expect(ex, isA<AppException>());
    });

    test('preserves message', () {
      final ex = NotFoundException('missing');
      expect(ex.message, equals('missing'));
    });
  });

  group('ValidationException', () {
    test('is an AppException', () {
      final ex = ValidationException('invalid');
      expect(ex, isA<AppException>());
    });

    test('preserves message', () {
      final ex = ValidationException('bad input');
      expect(ex.message, equals('bad input'));
    });
  });
}
