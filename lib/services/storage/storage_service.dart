import 'dart:typed_data';

abstract class StorageService {
  /// Uploads file to storage and returns path to it
  Future<String> upload({
    required String filename,
    required Stream<Uint8List> data,
    required String contentType,
    required int size,
  });

  Future<Stream<Uint8List>> download(String key);

  Future<void> delete(String key);

  Future<String> getUrl(String key);
}
