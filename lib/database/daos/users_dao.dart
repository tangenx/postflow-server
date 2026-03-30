part of '../database.dart';

@DriftAccessor(tables: [Users])
class UsersDao extends DatabaseAccessor<PostflowDatabase> with _$UsersDaoMixin {
  UsersDao(super.attachedDatabase);

  Future<User?> findByUsername(String username) {
    return (select(
      users,
    )..where((u) => u.username.equals(username))).getSingleOrNull();
  }

  Future<User?> findByEmail(String email) {
    return (select(
      users,
    )..where((u) => u.email.equals(email))).getSingleOrNull();
  }

  Future<User?> findByUsernameOrEmail(String usernameOrEmail) {
    return (select(users)..where(
          (u) =>
              u.email.equals(usernameOrEmail) |
              u.username.equals(usernameOrEmail),
        ))
        .getSingleOrNull();
  }

  Future<User> create({required String username, String? email}) async {
    final user = UsersCompanion.insert(
      username: username,
      email: Value.absentIfNull(email),
    );

    await into(users).insert(user);

    return (select(
      users,
    )..where((u) => u.username.equals(username))).getSingle();
  }
}
