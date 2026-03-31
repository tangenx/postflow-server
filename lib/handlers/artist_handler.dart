import 'package:drift_postgres/drift_postgres.dart';
import 'package:shelf/shelf.dart';

import '../database/database.dart';
import '../utils/api_response.dart';
import '../utils/request_validation.dart';

class ArtistHandler {
  final ArtistsDao _artistsDao;

  ArtistHandler(this._artistsDao);

  /// GET /artists?q=query&limit=10
  /// if q == null, return latest 1000 artists
  Future<Response> search(Request request) async {
    final query = request.url.queryParameters['q'];
    final limit = RequestValidation.optionalPositiveInt(
      request.url.queryParameters,
      'limit',
      fallback: 10,
      max: 1000,
    );

    final result = query == null
        ? await _artistsDao.getLatest()
        : await _artistsDao.search(query, limit: limit);

    return ApiResponse.ok(result.map(((artist) => artist.toJson())).toList());
  }

  /// GET /artists/:id
  Future<Response> getById(Request request, String id) async {
    final artistId = UuidValue.withValidation(id);
    final artist = await _artistsDao.getById(artistId);

    if (artist == null) {
      return ApiResponse.error(404, 'NOT_FOUND', 'Artist not found');
    }

    return ApiResponse.ok(artist.toJson());
  }

  /// POST /artists
  Future<Response> create(Request request) async {
    final data = RequestValidation.parseJsonObject(
      await request.readAsString(),
    );
    final name = RequestValidation.requiredString(
      data,
      'name',
      minLength: 1,
      maxLength: 255,
    );
    final sourceUrl = RequestValidation.optionalString(
      data,
      'source_url',
      maxLength: 2048,
    );
    final notes = RequestValidation.optionalString(
      data,
      'notes',
      maxLength: 4000,
    );

    final artist = await _artistsDao.create(
      name: name,
      sourceUrl: sourceUrl,
      notes: notes,
    );

    return ApiResponse.ok(artist.toJson());
  }

  /// PUT /artists/:id
  Future<Response> update(Request request, String id) async {
    final artistId = UuidValue.withValidation(id);
    final data = RequestValidation.parseJsonObject(
      await request.readAsString(),
    );
    final name = RequestValidation.optionalString(data, 'name', maxLength: 255);
    final sourceUrl = RequestValidation.optionalString(
      data,
      'source_url',
      maxLength: 2048,
    );
    final notes = RequestValidation.optionalString(
      data,
      'notes',
      maxLength: 4000,
    );

    final artist = await _artistsDao.updateArtist(
      id: artistId,
      name: name,
      sourceUrl: sourceUrl,
      notes: notes,
    );

    return ApiResponse.ok(artist.toJson());
  }

  /// DELETE /artists/:id
  Future<Response> delete(Request request, String id) async {
    final artistId = UuidValue.withValidation(id);
    await _artistsDao.deleteArtist(artistId);

    return ApiResponse.ok(null);
  }
}
