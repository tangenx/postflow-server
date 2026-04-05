import 'dart:io';
import 'dart:typed_data';

import 'package:drift_postgres/drift_postgres.dart';
import 'package:mime/mime.dart';
import 'package:shelf/shelf.dart';

import '../config/app_config.dart';
import '../core/constants.dart';
import '../core/exceptions.dart';
import '../database/database.dart';
import '../services/media_service.dart';
import '../services/storage/storage_service.dart';
import '../utils/api_response.dart';
import '../utils/request_validation.dart';

class MediaHandler {
  final MediaService _mediaService;
  final MediaDao _mediaDao;
  final AppConfig _config;
  final StorageService _storageService;

  MediaHandler({
    required MediaService mediaService,
    required MediaDao mediaDao,
    required AppConfig config,
    required StorageService storageService,
  }) : _mediaService = mediaService,
       _mediaDao = mediaDao,
       _config = config,
       _storageService = storageService;

  /// POST /api/media/upload
  /// multipart/form-data with file field
  Future<Response> upload(Request request) async {
    final userId = request.context['userId'] as UuidValue;
    final contentType = request.headers['content-type'] ?? '';

    if (!contentType.contains('multipart/form-data')) {
      throw ValidationException('Expected multipart/form-data');
    }

    final boundary = contentType.split('boundary=').last;
    final parts = await MimeMultipartTransformer(
      boundary,
    ).bind(request.read()).toList();

    if (parts.isEmpty) {
      throw ValidationException('No file provided');
    }

    final part = parts.first;
    final headers = part.headers;
    final mimeType = headers['content-type'] ?? 'application/octet-stream';
    final disposition = headers['content-disposition'] ?? '';
    final filename =
        RegExp('filename="([^"]+)"').firstMatch(disposition)?.group(1) ??
        'upload';

    final bytes = await part.expand((chunk) => chunk).toList();
    final data = Uint8List.fromList(bytes);
    final size = data.length;

    final file = await _mediaService.uploadFile(
      userId: userId,
      filename: filename,
      data: Stream.value(data),
      contentType: mimeType,
      size: size,
    );

    return ApiResponse.ok(file.toJson(), status: 201);
  }

  /// POST /api/media/remote
  /// { source_url: string, content_type: string }
  Future<Response> saveRemote(Request request) async {
    final userId = request.context['userId'] as UuidValue;
    final data = RequestValidation.parseJsonObject(
      await request.readAsString(),
    );

    final sourceUrl = RequestValidation.requiredString(data, 'sourceUrl');
    String? contentType = RequestValidation.optionalString(
      data,
      'contentType',
    );

    contentType ??= await _detectContentType(sourceUrl);

    if (contentType == null) {
      throw ValidationException('Cannot detect content type');
    }

    final file = await _mediaService.saveRemoteFile(
      userId: userId,
      sourceUrl: sourceUrl,
      contentType: contentType,
    );

    return ApiResponse.ok(file.toJson(), status: 201);
  }

  /// GET /api/media/:id
  Future<Response> getById(Request request, String id) async {
    final mediaFileId = UuidValue.withValidation(id);
    final mediaFile = await _mediaDao.getById(mediaFileId);

    if (mediaFile == null) {
      throw NotFoundException('Media file not found');
    }

    final url = await _mediaService.getUrl(mediaFile);
    return ApiResponse.ok({'url': url, ...mediaFile.toJson()});
  }

  /// GET /api/media/files/\<path>
  /// only for local storage - returns file contents
  Future<Response> serveFile(Request request, String path) async {
    if (_config.storageType != StorageType.local) {
      throw NotFoundException('Not available for this storage type');
    }

    final file = await _mediaDao.getByStoragePath(path);
    if (file == null) {
      throw NotFoundException('File not found');
    }

    final stream = await _storageService.download(file.storagePath!);
    final contentType = await _mediaDao.findTypeById(file.mediaTypeId);

    return Response.ok(
      stream,
      headers: {
        'content-type':
            contentType?.mimeTypes.first ?? 'application/octet-stream',
        'content-disposition': 'inline',
        'cache-control': 'public, max-age=31536000',
        'content-length': file.fileSizeBytes.toString(),
      },
    );
  }

  /// DELETE /api/media/:id
  Future<Response> delete(Request request, String id) async {
    final mediaFileId = UuidValue.withValidation(id);
    final file = await _mediaDao.getById(mediaFileId);

    if (file == null) {
      throw NotFoundException('Media file not found');
    }

    await _mediaService.delete(file);

    return ApiResponse.ok(null);
  }

  // TODO: /api/media/sauce - find sauce

  Future<String?> _detectContentType(String url) async {
    try {
      final client = HttpClient();
      final request = await client.headUrl(Uri.parse(url));
      final response = await request.close();
      return response.headers.contentType?.mimeType;
    } catch (_) {
      return null;
    }
  }
}
