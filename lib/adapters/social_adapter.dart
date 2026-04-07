import 'dart:typed_data';

import '../database/database.dart';

abstract class SocialAdapter {
  /// avaiable values: "user", "post"
  String get slug;

  Future<String> publishPost({
    required String accessToken,
    required String targetId,
    required String targetType,
    required List<MediaFileWithMediaType> mediaFiles,

    /// null if media is remote
    required List<Uint8List?> mediaBytes,
    required String? caption,
  });

  Future<({String externalAccountId, String screenName})> verifyToken(
    String accessToken,
  );
}
