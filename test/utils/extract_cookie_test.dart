import 'package:test/test.dart';
import 'package:postflow_server/utils/extract_cookie.dart';

void main() {
  group('extractCookie', () {
    test('returns null for null header', () {
      expect(extractCookie(null, 'token'), isNull);
    });

    test('extracts cookie value by name', () {
      final result = extractCookie(
        'session=abc123; refresh_token=xyz789',
        'refresh_token',
      );
      expect(result, equals('xyz789'));
    });

    test('extracts first cookie in header', () {
      final result = extractCookie('token=hello; other=world', 'token');
      expect(result, equals('hello'));
    });

    test('extracts last cookie in header', () {
      final result = extractCookie('a=1; b=2; target=value', 'target');
      expect(result, equals('value'));
    });

    test('returns null if cookie not found', () {
      final result = extractCookie('session=abc123', 'token');
      expect(result, isNull);
    });

    test('handles single cookie without trailing semicolon', () {
      final result = extractCookie('token=value', 'token');
      expect(result, equals('value'));
    });

    test('handles empty string header', () {
      final result = extractCookie('', 'token');
      expect(result, isNull);
    });

    test('returns null for cookie with empty value (regex requires 1+ chars)', () {
      final result = extractCookie('token=; other=val', 'token');
      expect(result, isNull);
    });
  });
}
