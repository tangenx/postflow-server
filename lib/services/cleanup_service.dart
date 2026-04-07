import '../database/database.dart';
import '../utils/logger.dart';
import 'storage/storage_service.dart';

class CleanupService {
  static const _log = Logger('CleanupService');

  final Duration _cleanupInterval;
  final MediaDao _mediaDao;
  final StorageService _storageService;

  CleanupService({
    required Duration cleanupInterval,
    required MediaDao mediaDao,
    required StorageService storageService,
  }) : _cleanupInterval = cleanupInterval,
       _mediaDao = mediaDao,
       _storageService = storageService;

  Future<void> cleanupOrphanedMedia() async {
    final orphaned = await _mediaDao.findOrphaned(_cleanupInterval);

    for (final media in orphaned) {
      _log.info('Deleting orphaned media file: ${media.sourceUrl}');
      await _storageService.delete(media.storagePath!);
      await _mediaDao.deleteFile(media.id);
    }
  }
}
