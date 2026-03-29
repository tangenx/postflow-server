import 'package:test/test.dart';
import 'package:postflow_server/utils/password_utils.dart';

void main() {
  group('PasswordUtils', () {
    test('hash produces a bcrypt string', () {
      final hash = PasswordUtils.hash('password123');
      expect(hash, startsWith(r'$2'));
    });

    test('verify returns true for correct password', () {
      final hash = PasswordUtils.hash('mypassword');
      expect(PasswordUtils.verify('mypassword', hash), isTrue);
    });

    test('verify returns false for incorrect password', () {
      final hash = PasswordUtils.hash('mypassword');
      expect(PasswordUtils.verify('wrongpassword', hash), isFalse);
    });

    test('different calls to hash produce different hashes (random salt)', () {
      final hash1 = PasswordUtils.hash('samepassword');
      final hash2 = PasswordUtils.hash('samepassword');
      expect(hash1, isNot(equals(hash2)));
    });

    test('different hashes for same password still verify correctly', () {
      final hash1 = PasswordUtils.hash('samepassword');
      final hash2 = PasswordUtils.hash('samepassword');
      expect(PasswordUtils.verify('samepassword', hash1), isTrue);
      expect(PasswordUtils.verify('samepassword', hash2), isTrue);
    });

    test('handles empty password', () {
      final hash = PasswordUtils.hash('');
      expect(PasswordUtils.verify('', hash), isTrue);
      expect(PasswordUtils.verify('notempty', hash), isFalse);
    });
  });
}
