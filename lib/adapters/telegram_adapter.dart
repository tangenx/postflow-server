import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:postflow_server/adapters/social_adapter.dart';
import 'package:postflow_server/core/constants.dart';
import 'package:postflow_server/database/database.dart';
import 'package:televerse/telegram.dart';
import 'package:televerse/televerse.dart';

import '../core/exceptions.dart';

class TelegramAdapter implements SocialAdapter {
  late final Bot telegram;

  @override
  String get slug => 'telegram';

  @override
  Future<String> publishPost({
    required String accessToken,
    required String targetId,
    // 'user', 'group', 'channel', 'chat'
    required String targetType,
    required List<MediaFileWithMediaType> mediaFiles,
    required List<Uint8List?> mediaBytes,
    required String? caption,
  }) async {
    final ID targetToPostId = switch (targetType) {
      'user' => ChatID.create(int.parse(targetId)),
      'group' || 'chat' => ChatID.create(int.parse(targetId)),
      'channel' => ChannelID.create(targetId),
      _ => throw UnsupportedError('Unsupported target type $targetType'),
    };

    final media = _getInputMedia(mediaFiles, mediaBytes, caption);

    final messages = await telegram.api.sendMediaGroup(targetToPostId, media);

    return messages.first.messageId.toString();
  }

  /// we are putting caption in the first media because thats telegram
  List<InputMedia> _getInputMedia(
    List<MediaFileWithMediaType> mediaFiles,
    List<Uint8List?> mediaBytes,
    String? caption,
  ) {
    return mediaFiles.mapIndexed((index, m) {
      final media = switch (m.mediaFile.storageType) {
        StorageType.remote => InputFile.fromUrl(m.mediaFile.sourceUrl!),
        StorageType.local ||
        StorageType.s3 => InputFile.fromBytes(mediaBytes[index]!),
      };

      final isFirstMedia = index == 0;

      return switch (m.mediaType.slug) {
        'image' => InputMedia.photo(
          media: media,
          caption: isFirstMedia ? caption : null,
        ),
        'gif' => InputMedia.document(
          media: media,
          caption: isFirstMedia ? caption : null,
        ),
        'video' => InputMedia.video(
          media: media,
          caption: isFirstMedia ? caption : null,
        ),
        _ => throw UnsupportedError('Unsupported media type ${m.mediaType}'),
      };
    }).toList();
  }

  @override
  Future<({String externalAccountId, String screenName})> verifyToken(
    String accessToken,
  ) async {
    telegram = Bot(accessToken);

    try {
      final user = await telegram.getMe();

      return (
        externalAccountId: user.id.toString(),
        screenName: user.username?.toString() ?? '',
      );
    } catch (e) {
      throw ValidationException('Invalid Telegram token');
    }
  }
}
