import 'package:test/test.dart';
import 'package:postflow_server/utils/hash_utils.dart';

void main() {
  group('HashUtils', () {
    test('sha256hash returns correct hash for known input', () {
      // SHA-256 of empty string is well-known
      final hash = HashUtils.sha256hash('');
      expect(
        hash,
        equals(
          'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855',
        ),
      );
    });

    test('sha256hash returns consistent results', () {
      final hash1 = HashUtils.sha256hash('hello');
      final hash2 = HashUtils.sha256hash('hello');
      expect(hash1, equals(hash2));
    });

    test('sha256hash different inputs produce different hashes', () {
      final hash1 = HashUtils.sha256hash('hello');
      final hash2 = HashUtils.sha256hash('world');
      expect(hash1, isNot(equals(hash2)));
    });

    test('sha256hash produces 64-character hex string', () {
      final hash = HashUtils.sha256hash('test');
      expect(hash.length, equals(64));
      expect(RegExp(r'^[a-f0-9]+$').hasMatch(hash), isTrue);
    });

    test('sha256hash handles unicode input', () {
      final hash = HashUtils.sha256hash('привет');
      expect(hash.length, equals(64));
      expect(RegExp(r'^[a-f0-9]+$').hasMatch(hash), isTrue);
    });

    test('sha256hash of "hello" matches known value', () {
      final hash = HashUtils.sha256hash('hello');
      expect(
        hash,
        equals(
          '2cf24dba5fb0a30e26e83b2ac5b9e29e1b161e5c1fa7425e73043362938b9824',
        ),
      );
    });
  });
}
