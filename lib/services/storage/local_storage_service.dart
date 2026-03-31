import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:path/path.dart' as path;

import '../../config/app_config.dart';

import '../../core/exceptions.dart';
import 'storage_service.dart';

class LocalStorageService implements StorageService {
  final String _path;

  LocalStorageService(AppConfig config) : _path = config.localStoragePath!;

  @override
  Future<String> upload({
    required String filename,
    required Stream<Uint8List> data,
    required String contentType,
    required int size,
  }) async {
    final key = _generateKey(filename);
    final file = File(path.join(_path, key));
    await file.parent.create(recursive: true);
    await file.openWrite().addStream(data);
    return key;
  }

  @override
  Future<Stream<Uint8List>> download(String key) async {
    final file = File(path.join(_path, key));
    if (!await file.exists()) {
      throw NotFoundException('File not found');
    }
    return file.openRead().map((chunk) => Uint8List.fromList(chunk));
  }

  @override
  Future<void> delete(String key) async {
    final file = File(path.join(_path, key));
    if (await file.exists()) {
      await file.delete();
    }
  }

  @override
  Future<String> getUrl(String key) async {
    return '/api/media/files/$key';
  }

  String _generateKey(String filename) {
    final extension = filename.split('.').last;
    final date = DateTime.now().toIso8601String().substring(0, 10);
    final random = Random.secure().nextInt(0xFFFFFF).toRadixString(16);
    return '$date-$random.$extension';
  }
}
