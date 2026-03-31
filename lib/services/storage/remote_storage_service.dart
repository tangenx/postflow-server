// basically this is a fallback storage
// beacuse media files with storage type 'remote' are not stored anywhere
// so we cannot manipulate with them

import 'dart:typed_data';

import 'storage_service.dart';

class RemoteStorageService implements StorageService {
  @override
  Future<void> delete(String key) {
    // doing nothing
    return Future.value();
  }

  @override
  Future<Stream<Uint8List>> download(String key) {
    throw UnsupportedError('use source_url directly');
  }

  @override
  Future<String> getUrl(String key) async {
    // key is an url
    return key;
  }

  @override
  Future<String> upload({
    required String filename,
    required Stream<Uint8List> data,
    required String contentType,
    required int size,
  }) {
    throw UnsupportedError('remote storage is read-only');
  }
}
