import 'dart:convert';
import 'dart:typed_data';

import 'package:drift_postgres/drift_postgres.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';
import 'package:postflow_server/config/app_config.dart';
import 'package:postflow_server/core/constants.dart';
import 'package:postflow_server/core/exceptions.dart';
import 'package:postflow_server/database/database.dart';
import 'package:postflow_server/handlers/media_handler.dart';
import 'package:postflow_server/services/media_service.dart';
import 'package:postflow_server/services/storage/storage_service.dart';

// ---------------------------------------------------------------------------
// Fakes
// ---------------------------------------------------------------------------

class FakeStorageService implements StorageService {
  final Map<String, Uint8List> _files = {};

  @override
  Future<String> upload({
    required String filename,
    required Stream<Uint8List> data,
    required String contentType,
    required int size,
  }) async {
    final bytes = await data.expand((c) => c).toList();
    final key = '2024-01-01-abc.$filename';
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
  MediaType? typeLookup;
  MediaFile? fileById;
  MediaFile? fileByStoragePath;
  MediaFile? createdFile;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  Future<MediaType?> findTypeByContentType(String contentType) async =>
      typeLookup;

  @override
  Future<MediaType?> findTypeById(UuidValue id) async => typeLookup;

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
    return createdFile!;
  }

  @override
  Future<MediaFile?> getById(UuidValue id) async => fileById;

  @override
  Future<MediaFile?> getByStoragePath(String path) async =>
      fileByStoragePath;

  @override
  Future<int> deleteFile(UuidValue id) async => 1;
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

const _userId = '550e8400-e29b-41d4-a716-446655440000';
const _mediaTypeId = '660e8400-e29b-41d4-a716-446655440001';
const _mediaFileId = '770e8400-e29b-41d4-a716-446655440002';
const _storagePath = '2024-01-01-abc.png';

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
  String? storagePath = _storagePath,
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

Request _jsonPost(String path, Map<String, dynamic> body) {
  return Request(
    'POST',
    Uri.parse('http://localhost/$path'),
    body: jsonEncode(body),
    headers: {'content-type': 'application/json'},
  );
}

Request _withUserId(Request request) {
  return request.change(
    context: {'userId': UuidValue.fromString(_userId)},
  );
}

/// Build a multipart/form-data body as bytes.
Uint8List _multipartBody({
  required String filename,
  required List<int> fileBytes,
  required String boundary,
  String mimeType = 'image/png',
}) {
  final header = <int>[
    ...utf8.encode('--$boundary\r\n'),
    ...utf8.encode('Content-Type: $mimeType\r\n'),
    ...utf8.encode(
      'Content-Disposition: form-data; name="file"; filename="$filename"\r\n',
    ),
    ...utf8.encode('\r\n'),
  ];
  final footer = utf8.encode('\r\n--$boundary--\r\n');
  return Uint8List.fromList([...header, ...fileBytes, ...footer]);
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  late FakeMediaDao fakeDao;
  late FakeStorageService fakeStorage;
  late AppConfig config;
  late MediaService mediaService;
  late MediaHandler handler;

  setUp(() {
    fakeDao = FakeMediaDao();
    fakeStorage = FakeStorageService();
    config = _testConfig();
    mediaService = MediaService(
      mediaDao: fakeDao,
      storageService: fakeStorage,
      config: config,
    );
    handler = MediaHandler(
      mediaService: mediaService,
      mediaDao: fakeDao,
      config: config,
      storageService: fakeStorage,
    );
  });

  group('MediaHandler', () {
    group('getById', () {
      test('returns media file with url', () async {
        fakeDao.fileById = _testMediaFile();

        final request = Request(
          'GET',
          Uri.parse('http://localhost/api/media/$_mediaFileId'),
        );

        final response = await handler.getById(request, _mediaFileId);

        expect(response.statusCode, equals(200));
        final body = jsonDecode(await response.readAsString());
        expect(body['ok'], isTrue);
        expect(body['data']['url'], isNotNull);
        expect(body['data']['storageType'], equals('local'));
      });

      test('throws NotFoundException when not found', () {
        fakeDao.fileById = null;

        final request = Request(
          'GET',
          Uri.parse('http://localhost/api/media/$_mediaFileId'),
        );

        expect(
          () => handler.getById(request, _mediaFileId),
          throwsA(isA<NotFoundException>()),
        );
      });

      test('throws FormatException for invalid UUID', () {
        final request = Request(
          'GET',
          Uri.parse('http://localhost/api/media/not-a-uuid'),
        );

        expect(
          () => handler.getById(request, 'not-a-uuid'),
          throwsA(isA<FormatException>()),
        );
      });
    });

    group('delete', () {
      test('deletes existing file and returns ok', () async {
        fakeDao.fileById = _testMediaFile();

        final request = Request(
          'DELETE',
          Uri.parse('http://localhost/api/media/$_mediaFileId'),
        );

        final response = await handler.delete(request, _mediaFileId);

        expect(response.statusCode, equals(200));
        final body = jsonDecode(await response.readAsString());
        expect(body['ok'], isTrue);
      });

      test('throws NotFoundException when file not found', () {
        fakeDao.fileById = null;

        final request = Request(
          'DELETE',
          Uri.parse('http://localhost/api/media/$_mediaFileId'),
        );

        expect(
          () => handler.delete(request, _mediaFileId),
          throwsA(isA<NotFoundException>()),
        );
      });

      test('throws FormatException for invalid UUID', () {
        final request = Request(
          'DELETE',
          Uri.parse('http://localhost/api/media/bad-uuid'),
        );

        expect(
          () => handler.delete(request, 'bad-uuid'),
          throwsA(isA<FormatException>()),
        );
      });
    });

    group('saveRemote', () {
      test('returns 201 with created file', () async {
        fakeDao.typeLookup = _testMediaType;
        fakeDao.createdFile = _testMediaFile(
          storageType: StorageType.remote,
          storagePath: null,
          sourceUrl: 'https://example.com/img.png',
        );

        final request = _withUserId(_jsonPost('api/media/remote', {
          'sourceUrl': 'https://example.com/img.png',
          'contentType': 'image/png',
        }));

        final response = await handler.saveRemote(request);

        expect(response.statusCode, equals(201));
        final body = jsonDecode(await response.readAsString());
        expect(body['ok'], isTrue);
        expect(body['data'], isNotNull);
      });

      test('throws ValidationException when sourceUrl missing', () async {
        final request = _withUserId(_jsonPost('api/media/remote', {
          'contentType': 'image/png',
        }));

        expect(
          () => handler.saveRemote(request),
          throwsA(isA<ValidationException>()),
        );
      });
    });

    group('serveFile', () {
      test('throws NotFoundException when not local storage', () {
        final s3Config = _testConfig(storageType: StorageType.s3);
        final s3Handler = MediaHandler(
          mediaService: mediaService,
          mediaDao: fakeDao,
          config: s3Config,
          storageService: fakeStorage,
        );

        expect(
          () => s3Handler.serveFile(
            Request('GET', Uri.parse('http://localhost/api/media/files/x')),
            'x',
          ),
          throwsA(isA<NotFoundException>()),
        );
      });

      test('throws NotFoundException when file not in db', () {
        fakeDao.fileByStoragePath = null;

        expect(
          () => handler.serveFile(
            Request(
              'GET',
              Uri.parse('http://localhost/api/media/files/missing.png'),
            ),
            'missing.png',
          ),
          throwsA(isA<NotFoundException>()),
        );
      });

      test('returns file stream when found', () async {
        fakeDao.fileByStoragePath = _testMediaFile();
        fakeDao.typeLookup = _testMediaType;
        fakeStorage._files[_storagePath] = Uint8List.fromList([1, 2, 3, 4]);

        final response = await handler.serveFile(
          Request(
            'GET',
            Uri.parse('http://localhost/api/media/files/$_storagePath'),
          ),
          _storagePath,
        );

        expect(response.statusCode, equals(200));
        expect(
          response.headers['content-type'],
          equals('image/png'),
        );
        expect(
          response.headers['cache-control'],
          equals('public, max-age=31536000'),
        );
      });
    });

    group('upload', () {
      test('throws ValidationException for non-multipart request', () {
        final request = _withUserId(
          Request(
            'POST',
            Uri.parse('http://localhost/api/media/upload'),
            body: 'not multipart',
            headers: {'content-type': 'application/json'},
          ),
        );

        expect(
          () => handler.upload(request),
          throwsA(isA<ValidationException>()),
        );
      });

      test('uploads file and returns 201', () async {
        fakeDao.typeLookup = _testMediaType;
        fakeDao.createdFile = _testMediaFile();

        const boundary = '----TestBoundary12345';
        final bodyBytes = _multipartBody(
          filename: 'photo.png',
          fileBytes: [137, 80, 78, 71],
          boundary: boundary,
        );

        final request = _withUserId(Request(
          'POST',
          Uri.parse('http://localhost/api/media/upload'),
          body: bodyBytes,
          headers: {
            'content-type': 'multipart/form-data; boundary=$boundary',
          },
        ));

        final response = await handler.upload(request);

        expect(response.statusCode, equals(201));
        final responseBody = jsonDecode(await response.readAsString());
        expect(responseBody['ok'], isTrue);
        expect(responseBody['data'], isNotNull);
      });
    });
  });
}
