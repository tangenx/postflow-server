import 'dart:typed_data';

import 'package:test/test.dart';
import 'package:postflow_server/services/storage/remote_storage_service.dart';

Stream<Uint8List> _byteStream(List<int> bytes) =>
    Stream.value(Uint8List.fromList(bytes));

void main() {
  late RemoteStorageService service;

  setUp(() {
    service = RemoteStorageService();
  });

  group('RemoteStorageService', () {
    test('upload throws UnsupportedError', () {
      expect(
        () => service.upload(
          filename: 'test.png',
          data: _byteStream([1, 2, 3]),
          contentType: 'image/png',
          size: 3,
        ),
        throwsA(isA<UnsupportedError>()),
      );
    });

    test('download throws UnsupportedError', () {
      expect(
        () => service.download('some-key'),
        throwsA(isA<UnsupportedError>()),
      );
    });

    test('delete completes without error', () async {
      await service.delete('any-key');
      // no exception = pass
    });

    test('getUrl returns the key as-is', () async {
      final url = await service.getUrl('https://example.com/image.png');
      expect(url, equals('https://example.com/image.png'));
    });
  });
}
