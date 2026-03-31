import 'dart:math';
import 'dart:typed_data';

import 'package:minio/minio.dart';

import '../../config/app_config.dart';
import '../../core/exceptions.dart';
import 'storage_service.dart';

class S3StorageService implements StorageService {
  late final Minio _client;
  final AppConfig _config;

  S3StorageService(this._config) {
    _client = Minio(
      endPoint: _config.s3Endpoint!,
      accessKey: _config.s3AccessKey!,
      secretKey: _config.s3SecretKey!,
      region: _config.s3Region!,
      useSSL: false,
    );
  }

  @override
  Future<void> delete(String key) {
    return _client.removeObject(_config.s3Bucket!, key);
  }

  @override
  Future<Stream<Uint8List>> download(String key) async {
    try {
      final stream = await _client.getObject(_config.s3Bucket!, key);
      return stream.map(
        (chunk) => chunk is Uint8List ? chunk : Uint8List.fromList(chunk),
      );
    } on MinioError catch (e) {
      final message = e.message ?? '';
      if (message.contains('NoSuchKey') || message.contains('Not Found')) {
        throw NotFoundException('File not found');
      }
      rethrow;
    }
  }

  @override
  Future<String> getUrl(String key) {
    return _client.presignedGetObject(
      _config.s3Bucket!,
      key,
      expires: 60 * 60 * 24 * 7,
    );
  }

  @override
  Future<String> upload({
    required String filename,
    required Stream<Uint8List> data,
    required String contentType,
    required int size,
  }) async {
    final key = _generateKey(filename);
    await _client.putObject(
      _config.s3Bucket!,
      key,
      data,
      size: size,
      metadata: {'Content-Type': contentType},
    );
    return key;
  }

  String _generateKey(String filename) {
    final ext = filename.split('.').last;
    final date = DateTime.now().toIso8601String().substring(0, 10);
    final random = Random.secure().nextInt(0xFFFFFF).toRadixString(16);
    return '$date/$random.$ext';
  }
}
