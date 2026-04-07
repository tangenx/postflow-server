import 'dart:io';
import 'dart:typed_data';

import 'package:test/test.dart';
import 'package:postflow_server/config/app_config.dart';
import 'package:postflow_server/core/constants.dart';
import 'package:postflow_server/core/exceptions.dart';
import 'package:postflow_server/services/storage/local_storage_service.dart';

AppConfig _testConfig(String storagePath) {
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
    storageType: StorageType.local,
    localStoragePath: storagePath,
    schedulerCheckInterval: const Duration(seconds: 30),
    mediaOrphanTtl: const Duration(hours: 24),
  );
}

Stream<Uint8List> _byteStream(List<int> bytes) =>
    Stream.value(Uint8List.fromList(bytes));

void main() {
  late Directory tempDir;
  late LocalStorageService service;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('postflow_storage_test_');
    service = LocalStorageService(_testConfig(tempDir.path));
  });

  tearDown(() async {
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  group('LocalStorageService', () {
    group('upload', () {
      test('writes file to disk and returns key', () async {
        final key = await service.upload(
          filename: 'photo.png',
          data: _byteStream([1, 2, 3]),
          contentType: 'image/png',
          size: 3,
        );

        expect(key, matches(r'^\d{4}-\d{2}-\d{2}-[0-9a-f]+\.png$'));

        final file = File('${tempDir.path}/$key');
        expect(await file.exists(), isTrue);
        expect(await file.readAsBytes(), equals([1, 2, 3]));
      });

      test('creates parent directories if missing', () async {
        final nestedDir =
            await Directory.systemTemp.createTemp('postflow_nested_');
        final nestedPath = '${nestedDir.path}/a/b/c';
        try {
          final svc = LocalStorageService(_testConfig(nestedPath));
          final key = await svc.upload(
            filename: 'doc.pdf',
            data: _byteStream([4, 5]),
            contentType: 'application/pdf',
            size: 2,
          );

          final file = File('$nestedPath/$key');
          expect(await file.exists(), isTrue);
        } finally {
          await nestedDir.delete(recursive: true);
        }
      });

      test('generates different keys for consecutive uploads', () async {
        final key1 = await service.upload(
          filename: 'a.txt',
          data: _byteStream([1]),
          contentType: 'text/plain',
          size: 1,
        );
        final key2 = await service.upload(
          filename: 'a.txt',
          data: _byteStream([2]),
          contentType: 'text/plain',
          size: 1,
        );

        expect(key1, isNot(equals(key2)));
      });
    });

    group('download', () {
      test('returns file content as stream', () async {
        final key = await service.upload(
          filename: 'data.bin',
          data: _byteStream([10, 20, 30]),
          contentType: 'application/octet-stream',
          size: 3,
        );

        final stream = await service.download(key);
        final bytes = await stream.expand((c) => c).toList();

        expect(bytes, equals([10, 20, 30]));
      });

      test('throws NotFoundException for missing file', () {
        expect(
          () => service.download('nonexistent-file.dat'),
          throwsA(isA<NotFoundException>()),
        );
      });
    });

    group('delete', () {
      test('removes file from disk', () async {
        final key = await service.upload(
          filename: 'temp.txt',
          data: _byteStream([1]),
          contentType: 'text/plain',
          size: 1,
        );

        expect(await File('${tempDir.path}/$key').exists(), isTrue);

        await service.delete(key);

        expect(await File('${tempDir.path}/$key').exists(), isFalse);
      });

      test('does nothing when file does not exist', () async {
        // Should not throw
        await service.delete('no-such-file.txt');
      });
    });

    group('getUrl', () {
      test('returns local API path for key', () async {
        final url = await service.getUrl('2024-01-15-abc123.png');
        expect(url, equals('/api/media/files/2024-01-15-abc123.png'));
      });
    });
  });
}
