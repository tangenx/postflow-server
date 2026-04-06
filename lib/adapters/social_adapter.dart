import '../database/database.dart';

abstract class SocialAdapter {
  String get slug;

  Future<String> publishPost({
    required String accessToken,
    required String targetId,
    required String targetType,
    required List<MediaFile> mediaFiles,
  });

  Future<({String externalAccountId, String screenName})> verifyToken(
    String accessToken,
  );
}
