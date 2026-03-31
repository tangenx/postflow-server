import 'dart:typed_data';

import 'package:drift_postgres/drift_postgres.dart';

import '../config/app_config.dart';
import '../core/constants.dart';
import '../core/exceptions.dart';
import '../database/database.dart';
import 'storage/storage_service.dart';

class MediaService {
  final MediaDao _mediaDao;
  final StorageService _storageService;
  final StorageType _storageConfig;

  MediaService({
    required MediaDao mediaDao,
    required StorageService storageService,
    required AppConfig config,
  }) : _mediaDao = mediaDao,
       _storageService = storageService,
       _storageConfig = config.storageType;

  Future<MediaFile> uploadFile({
    required UuidValue userId,
    required String filename,
    required Stream<Uint8List> data,
    required String contentType,
    required int size,
  }) async {
    final mediaType = await _mediaDao.findTypeByContentType(contentType);
    if (mediaType == null) {
      throw ValidationException('Unsupported media type: $contentType');
    }

    final key = await _storageService.upload(
      filename: filename,
      data: data,
      contentType: contentType,
      size: size,
    );

    return _mediaDao.createFile(
      userId: userId,
      mediaTypeId: mediaType.id,
      storageType: _storageConfig,
      storagePath: key,
      sourceUrl: null,
      originalFilename: filename,
      fileSizeBytes: size,
    );
  }

  Future<MediaFile> saveRemoteFile({
    required UuidValue userId,
    required String sourceUrl,
    required String contentType,
  }) async {
    final mediaType = await _mediaDao.findTypeByContentType(contentType);
    if (mediaType == null) {
      throw ValidationException('Unsupported media type: $contentType');
    }

    return _mediaDao.createFile(
      userId: userId,
      mediaTypeId: mediaType.id,
      storageType: StorageType.remote,
      storagePath: null,
      sourceUrl: sourceUrl,
    );
  }

  Future<String> getUrl(MediaFile mediaFile) async {
    return switch (mediaFile.storageType) {
      StorageType.remote => mediaFile.sourceUrl!,
      _ => await _storageService.getUrl(mediaFile.storagePath!),
    };
  }

  Future<void> delete(MediaFile mediaFile) async {
    if (mediaFile.storageType != StorageType.remote) {
      await _storageService.delete(mediaFile.storagePath!);
    }

    await _mediaDao.deleteFile(mediaFile.id);
  }
}
