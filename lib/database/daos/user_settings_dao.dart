part of '../database.dart';

@DriftAccessor(tables: [UserSettings])
class UserSettingsDao extends DatabaseAccessor<PostflowDatabase>
    with _$UserSettingsDaoMixin {
  UserSettingsDao(super.attachedDatabase);

  Future<UserSetting?> getByUserId(UuidValue userId) {
    return (select(
      userSettings,
    )..where((t) => t.userId.equals(userId))).getSingleOrNull();
  }

  Future<UserSetting> create(UuidValue userId) {
    final companion = UserSettingsCompanion.insert(userId: userId);

    return into(userSettings).insertReturning(companion);
  }

  Future<UserSetting> updateSettings({
    required UuidValue userId,
    String? saucenaoApiKey,
  }) async {
    final companion = UserSettingsCompanion(
      saucenaoApiKey: Value.absentIfNull(saucenaoApiKey),
    );

    final updated = await (update(
      userSettings,
    )..where((t) => t.userId.equals(userId))).writeReturning(companion);

    if (updated.isEmpty) {
      throw NotFoundException('User settings not found');
    }

    return updated.single;
  }
}
