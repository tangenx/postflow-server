import 'dart:typed_data';

import 'package:drift_postgres/drift_postgres.dart';
import 'package:test/test.dart';
import 'package:postflow_server/config/app_config.dart';
import 'package:postflow_server/core/constants.dart';
import 'package:postflow_server/core/exceptions.dart';
import 'package:postflow_server/database/database.dart';
import 'package:postflow_server/services/media_service.dart';
import 'package:postflow_server/services/storage/storage_service.dart';

// ---------------------------------------------------------------------------
// Fakes
// ---------------------------------------------------------------------------

class FakeStorageService implements StorageService {
  final Map<String, Uint8List> _files = {};
  bool uploadShouldFail = false;

  @override
  Future<String> upload({
    required String filename,
    required Stream<Uint8List> data,
    required String contentType,
    required int size,
  }) async {
    if (uploadShouldFail) throw Exception('upload failed');
    final bytes = await data.expand((c) => c).toList();
    final key = '2024-01-01-${_files.length}.$filename';
    _files[key] = Uint8List.fromList(bytes);
    return key;
  }

  @override
  Future<Stream<Uint8List>> download(String key) async {
    final bytes = _files[key];
    if (bytes == null) throw NotFoundException('File not found');
    return Stream.value(bytes);
  }

  @override
  Future<void> delete(String key) async {
    _files.remove(key);
  }

  @override
  Future<String> getUrl(String key) async => '/api/media/files/$key';
}

class FakeMediaDao implements MediaDao {
  MediaType? typeToReturn;
  MediaFile? fileToReturn;
  MediaFile? getByStoragePathResult;
  final List<MediaFile> _deleted = [];
  String? findTypeByContentTypeArg;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  Future<MediaType?> findTypeByContentType(String contentType) async {
    findTypeByContentTypeArg = contentType;
    return typeToReturn;
  }

  @override
  Future<MediaType?> findTypeById(UuidValue id) async => typeToReturn;

  @override
  Future<MediaFile> createFile({
    required UuidValue userId,
    required UuidValue mediaTypeId,
    required StorageType storageType,
    String? storagePath,
    String? sourceUrl,
    String? originalFilename,
    int? fileSizeBytes,
  }) async {
    return fileToReturn!;
  }

  @override
  Future<MediaFile?> getById(UuidValue id) async => fileToReturn;

  @override
  Future<MediaFile?> getByStoragePath(String storagePath) async =>
      getByStoragePathResult;

  @override
  Future<int> deleteFile(UuidValue id) async {
    _deleted.add(fileToReturn!);
    return 1;
  }

  List<MediaFile> get deleted => _deleted;
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

const _userId = '550e8400-e29b-41d4-a716-446655440000';
const _mediaTypeId = '660e8400-e29b-41d4-a716-446655440001';
const _mediaFileId = '770e8400-e29b-41d4-a716-446655440002';

final _testMediaType = MediaType(
  id: UuidValue.fromString(_mediaTypeId),
  slug: 'image',
  displayName: 'Image',
  allowedExtensions: ['png', 'jpg'],
  mimeTypes: ['image/png', 'image/jpeg'],
  maxSizeMb: 20,
);

MediaFile _testMediaFile({
  StorageType storageType = StorageType.local,
  String? storagePath = '2024-01-01-abc.png',
  String? sourceUrl,
}) {
  return MediaFile(
    id: UuidValue.fromString(_mediaFileId),
    uploadedBy: UuidValue.fromString(_userId),
    mediaTypeId: UuidValue.fromString(_mediaTypeId),
    storageType: storageType,
    storagePath: storagePath,
    sourceUrl: sourceUrl,
    originalFilename: 'photo.png',
    fileSizeBytes: BigInt.from(1024),
    metadata: {},
    uploadedAt: PgDateTime(DateTime.utc(2024)),
  );
}

AppConfig _testConfig({StorageType storageType = StorageType.local}) {
  return AppConfig(
    dbName: 'test',
    dbHost: 'localhost',
    dbPort: 5432,
    dbUser: 'test',
    dbPassword: 'test',
    authenticationEnabled: false,
    jwtSecret: 'test',
    jwtAccessTtl: const Duration(minutes: 15),
    jwtRefreshTtl: const Duration(days: 7),
    storageType: storageType,
    schedulerCheckInterval: const Duration(seconds: 30),
    mediaOrphanTtl: const Duration(hours: 24),
  );
}

Stream<Uint8List> _byteStream(List<int> bytes) =>
    Stream.value(Uint8List.fromList(bytes));

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  late FakeMediaDao fakeDao;
  late FakeStorageService fakeStorage;
  late MediaService service;

  setUp(() {
    fakeDao = FakeMediaDao();
    fakeStorage = FakeStorageService();
    service = MediaService(
      mediaDao: fakeDao,
      storageService: fakeStorage,
      config: _testConfig(),
    );
  });

  group('MediaService', () {
    group('uploadFile', () {
      test('throws ValidationException for unsupported content type', () {
        fakeDao.typeToReturn = null;

        expect(
          () => service.uploadFile(
            userId: UuidValue.fromString(_userId),
            filename: 'test.pdf',
            data: _byteStream([1, 2, 3]),
            contentType: 'application/pdf',
            size: 3,
          ),
          throwsA(
            isA<ValidationException>().having(
              (e) => e.message,
              'message',
              contains('Unsupported media type'),
            ),
          ),
        );
      });

      test('delegates to storage service and dao on success', () async {
        fakeDao.typeToReturn = _testMediaType;
        fakeDao.fileToReturn = _testMediaFile();

        final result = await service.uploadFile(
          userId: UuidValue.fromString(_userId),
          filename: 'photo.png',
          data: _byteStream([1, 2, 3, 4]),
          contentType: 'image/png',
          size: 4,
        );

        expect(result, isNotNull);
        expect(fakeDao.findTypeByContentTypeArg, 'image/png');
      });
    });

    group('saveRemoteFile', () {
      test('throws ValidationException for unsupported content type', () {
        fakeDao.typeToReturn = null;

        expect(
          () => service.saveRemoteFile(
            userId: UuidValue.fromString(_userId),
            sourceUrl: 'https://example.com/image.png',
            contentType: 'text/html',
          ),
          throwsA(isA<ValidationException>()),
        );
      });

      test('creates file with remote storage type', () async {
        fakeDao.typeToReturn = _testMediaType;
        fakeDao.fileToReturn = _testMediaFile(
          storageType: StorageType.remote,
          storagePath: null,
          sourceUrl: 'https://example.com/image.png',
        );

        final result = await service.saveRemoteFile(
          userId: UuidValue.fromString(_userId),
          sourceUrl: 'https://example.com/image.png',
          contentType: 'image/png',
        );

        expect(result.storageType, StorageType.remote);
        expect(result.sourceUrl, 'https://example.com/image.png');
      });
    });

    group('getUrl', () {
      test('returns sourceUrl for remote storage', () async {
        final file = _testMediaFile(
          storageType: StorageType.remote,
          storagePath: null,
          sourceUrl: 'https://cdn.example.com/img.png',
        );

        final url = await service.getUrl(file);
        expect(url, 'https://cdn.example.com/img.png');
      });

      test('delegates to storage service for local storage', () async {
        final file = _testMediaFile();

        final url = await service.getUrl(file);
        expect(url, contains('/api/media/files/'));
      });

      test('delegates to storage service for s3 storage', () async {
        final s3Service = MediaService(
          mediaDao: fakeDao,
          storageService: fakeStorage,
          config: _testConfig(storageType: StorageType.s3),
        );
        final file = _testMediaFile();

        final url = await s3Service.getUrl(file);
        expect(url, contains('/api/media/files/'));
      });
    });

    group('delete', () {
      test('deletes from storage and dao for local file', () async {
        fakeDao.fileToReturn = _testMediaFile();

        await service.delete(fakeDao.fileToReturn!);

        expect(fakeDao.deleted.length, 1);
      });

      test('skips storage delete for remote files', () async {
        fakeDao.fileToReturn = _testMediaFile(
          storageType: StorageType.remote,
          storagePath: null,
          sourceUrl: 'https://example.com/img.png',
        );

        await service.delete(fakeDao.fileToReturn!);

        // dao should still be called
        expect(fakeDao.deleted.length, 1);
      });
    });
  });
}
