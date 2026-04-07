import 'package:drift_postgres/drift_postgres.dart';
import 'package:test/test.dart';
import 'package:postflow_server/core/constants.dart';
import 'package:postflow_server/database/database.dart';
import 'package:postflow_server/services/cleanup_service.dart';
import 'package:postflow_server/services/storage/storage_service.dart';

// ---------------------------------------------------------------------------
// Fakes
// ---------------------------------------------------------------------------

class FakeMediaDao implements MediaDao {
  Duration? findOrphanedTtl;
  List<MediaFile> findOrphanedResult = [];

  int deleteFileCallCount = 0;
  List<UuidValue> deleteFileIds = [];

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  Future<List<MediaFile>> findOrphaned(Duration ttl) async {
    findOrphanedTtl = ttl;
    return findOrphanedResult;
  }

  @override
  Future<int> deleteFile(UuidValue id) async {
    deleteFileCallCount++;
    deleteFileIds.add(id);
    return 1;
  }
}

class FakeStorageService implements StorageService {
  int deleteCallCount = 0;
  List<String> deletedKeys = [];

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  Future<void> delete(String key) async {
    deleteCallCount++;
    deletedKeys.add(key);
  }
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

const _mediaId1 = 'a10e8400-e29b-41d4-a716-446655440000';
const _mediaId2 = 'b20e8400-e29b-41d4-a716-446655440001';
const _mediaId3 = 'c30e8400-e29b-41d4-a716-446655440002';

final _orphanedMedia1 = MediaFile(
  id: UuidValue.fromString(_mediaId1),
  uploadedBy: UuidValue.fromString(_mediaId1),
  mediaTypeId: UuidValue.fromString(_mediaId2),
  storageType: StorageType.local,
  storagePath: 'uploads/orphan1.png',
  originalFilename: 'orphan1.png',
  fileSizeBytes: BigInt.from(1024),
  metadata: const {},
  uploadedAt: PgDateTime(DateTime.utc(2024, 1, 1)),
  sourceUrl: 'https://example.com/orphan1.png',
);

final _orphanedMedia2 = MediaFile(
  id: UuidValue.fromString(_mediaId2),
  uploadedBy: UuidValue.fromString(_mediaId1),
  mediaTypeId: UuidValue.fromString(_mediaId2),
  storageType: StorageType.s3,
  storagePath: 'uploads/orphan2.jpg',
  originalFilename: 'orphan2.jpg',
  fileSizeBytes: BigInt.from(2048),
  metadata: const {},
  uploadedAt: PgDateTime(DateTime.utc(2024, 1, 2)),
  sourceUrl: 'https://example.com/orphan2.jpg',
);

final _mediaWithoutStoragePath = MediaFile(
  id: UuidValue.fromString(_mediaId3),
  uploadedBy: UuidValue.fromString(_mediaId1),
  mediaTypeId: UuidValue.fromString(_mediaId2),
  storageType: StorageType.local,
  storagePath: null,
  originalFilename: 'remote.png',
  fileSizeBytes: BigInt.from(512),
  metadata: const {},
  uploadedAt: PgDateTime(DateTime.utc(2024, 1, 3)),
  sourceUrl: 'https://example.com/remote.png',
);

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  late FakeMediaDao fakeMediaDao;
  late FakeStorageService fakeStorageService;
  late CleanupService service;

  setUp(() {
    fakeMediaDao = FakeMediaDao();
    fakeStorageService = FakeStorageService();
    service = CleanupService(
      cleanupInterval: const Duration(hours: 1),
      mediaDao: fakeMediaDao,
      storageService: fakeStorageService,
    );
  });

  group('CleanupService', () {
    group('cleanupOrphanedMedia', () {
      test('deletes all orphaned media files from storage and database', () async {
        fakeMediaDao.findOrphanedResult = [_orphanedMedia1, _orphanedMedia2];

        await service.cleanupOrphanedMedia();

        expect(fakeStorageService.deleteCallCount, 2);
        expect(fakeMediaDao.deleteFileCallCount, 2);
      });

      test('passes correct storage paths to storage service', () async {
        fakeMediaDao.findOrphanedResult = [_orphanedMedia1, _orphanedMedia2];

        await service.cleanupOrphanedMedia();

        expect(fakeStorageService.deletedKeys, contains('uploads/orphan1.png'));
        expect(fakeStorageService.deletedKeys, contains('uploads/orphan2.jpg'));
      });

      test('passes correct media ids to deleteFile', () async {
        fakeMediaDao.findOrphanedResult = [_orphanedMedia1, _orphanedMedia2];

        await service.cleanupOrphanedMedia();

        expect(fakeMediaDao.deleteFileIds, contains(UuidValue.fromString(_mediaId1)));
        expect(fakeMediaDao.deleteFileIds, contains(UuidValue.fromString(_mediaId2)));
      });

      test('does nothing when no orphaned media found', () async {
        fakeMediaDao.findOrphanedResult = [];

        await service.cleanupOrphanedMedia();

        expect(fakeStorageService.deleteCallCount, 0);
        expect(fakeMediaDao.deleteFileCallCount, 0);
      });

      test('passes cleanup interval to findOrphaned', () async {
        const interval = Duration(hours: 24);
        service = CleanupService(
          cleanupInterval: interval,
          mediaDao: fakeMediaDao,
          storageService: fakeStorageService,
        );

        await service.cleanupOrphanedMedia();

        expect(fakeMediaDao.findOrphanedTtl, interval);
      });

      test('throws on null storagePath (media with only sourceUrl)', () async {
        fakeMediaDao.findOrphanedResult = [_mediaWithoutStoragePath];

        expect(
          () => service.cleanupOrphanedMedia(),
          throwsA(isA<TypeError>()),
        );
      });
    });
  });
}
