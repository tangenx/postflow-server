// epic isolate fail
import 'dart:async';
import 'dart:isolate';

import 'package:drift/drift.dart';
import 'package:drift_postgres/drift_postgres.dart';

import '../adapters/adapter_registry.dart';
import '../adapters/telegram_adapter.dart';
import '../config/app_config.dart';
import '../core/constants.dart';
import '../database/database.dart';
import '../database/tables/post_schedules.dart';
import '../database/tables/posts.dart';
import '../utils/logger.dart';
import 'cleanup_service.dart';
import 'storage/local_storage_service.dart';
import 'storage/remote_storage_service.dart';
import 'storage/s3_storage_service.dart';
import 'storage/storage_service.dart';

class PublisherService {
  static final _log = Logger('PublisherService');

  static Future<void> spawn(AppConfig config) async {
    await Isolate.spawn(_start, config);
  }

  static void _start(AppConfig config) {
    final database = PostflowDatabase(config);
    final scheduleDao = ScheduleDao(database);
    final mediaDao = MediaDao(database);
    final postsDao = PostsDao(database);
    final storageService = _buildStorageService(config);
    final adapterRegistry = _buildAdapterRegistry(config);
    final cleanupService = CleanupService(
      cleanupInterval: config.mediaOrphanTtl,
      mediaDao: mediaDao,
      storageService: storageService,
    );

    final service = PublisherService._(
      scheduleDao: scheduleDao,
      mediaDao: mediaDao,
      postsDao: postsDao,
      storageService: storageService,
      adapterRegistry: adapterRegistry,
    );
    final tickInterval = config.schedulerCheckInterval;

    _log.info('Publisher service started');
    runZonedGuarded(() async {
      while (true) {
        try {
          await service._processPending();

          if (DateTime.now().minute == 0) {
            await cleanupService.cleanupOrphanedMedia();
          }
        } catch (e, s) {
          _log.error('Publisher service crashed', e, s);
        }
        await Future.delayed(tickInterval);
      }
    }, (error, stackTrace) => _log.error('Publisher service crashed', error));
  }

  final ScheduleDao _scheduleDao;
  final MediaDao _mediaDao;
  final PostsDao _postsDao;
  final StorageService _storageService;
  final AdapterRegistry _adapterRegistry;

  PublisherService._({
    required ScheduleDao scheduleDao,
    required MediaDao mediaDao,
    required PostsDao postsDao,
    required StorageService storageService,
    required AdapterRegistry adapterRegistry,
  }) : _scheduleDao = scheduleDao,
       _mediaDao = mediaDao,
       _postsDao = postsDao,
       _storageService = storageService,
       _adapterRegistry = adapterRegistry;

  Future<void> _processPending() async {
    final pending = await _scheduleDao.findPending();

    final chunks = _chunk(pending, 5);
    for (final chunk in chunks) {
      await Future.wait(chunk.map(_publish));
    }
  }

  Future<void> _publish(ScheduleWithDetails details) async {
    final scheduleId = details.schedule.id;

    await _scheduleDao.setStatus(scheduleId, ScheduleStatus.publishing);

    try {
      final adapter = _adapterRegistry.get(details.network.slug)!;

      final media = await _mediaDao.findByPostIdWithType(
        details.schedule.postId,
      );

      final mediaBytes = await Future.wait(
        media.map((m) async {
          if (m.mediaFile.storageType != StorageType.remote) {
            return null;
          }

          final stream = await _storageService.download(
            m.mediaFile.storagePath!,
          );
          final bytes = await stream.expand((chunk) => chunk).toList();

          return Uint8List.fromList(bytes);
        }),
      );

      final externalPostId = await adapter.publishPost(
        accessToken: details.account.accessToken!,
        targetId: details.target.targetId,
        targetType: details.target.targetType,
        mediaFiles: media,
        mediaBytes: mediaBytes,
        caption: details.caption?.renderedBody,
      );

      await _scheduleDao.setStatus(
        scheduleId,
        ScheduleStatus.published,
        externalPostId: externalPostId,
        publishedAt: DateTime.now().toUtc(),
      );

      _log.info(
        'Published schedule $scheduleId -> $externalPostId (${details.network.displayName}, ${details.target.targetLabel})',
      );
    } catch (e, s) {
      _log.error('Failed to publish schedule $scheduleId', e, s);

      await _scheduleDao.setStatus(
        scheduleId,
        ScheduleStatus.failed,
        errorMessage: e.toString(),
      );

      await _maybeMarkPostAsFailed(details.schedule.postId);
    }
  }

  Future<void> _maybeMarkPostAsFailed(UuidValue postId) async {
    final schedules = await _scheduleDao.findSchedulesForPostInternal(postId);

    final allFailed = schedules.every(
      (s) =>
          s.schedule.status == ScheduleStatus.failed ||
          s.schedule.status == ScheduleStatus.cancelled,
    );

    if (allFailed) {
      await _postsDao.updatePostStatusInternal(postId, PostStatus.partial);
    }
  }

  static List<List<T>> _chunk<T>(List<T> list, int chunkSize) {
    final result = <List<T>>[];
    for (var i = 0; i < list.length; i += chunkSize) {
      result.add(list.sublist(i, i + chunkSize));
    }
    return result;
  }

  static StorageService _buildStorageService(AppConfig config) {
    return switch (config.storageType) {
      StorageType.local => LocalStorageService(config),
      StorageType.s3 => S3StorageService(config),
      StorageType.remote => RemoteStorageService(),
    };
  }

  static AdapterRegistry _buildAdapterRegistry(AppConfig config) {
    return AdapterRegistry()..register(TelegramAdapter());
  }
}
