import 'package:bcrypt/bcrypt.dart';

class PasswordUtils {
  static bool verify(String password, String hash) {
    return BCrypt.checkpw(password, hash);
  }

  static String hash(String password) {
    return BCrypt.hashpw(password, BCrypt.gensalt());
  }
}
