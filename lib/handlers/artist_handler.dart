import 'dart:convert';

import 'package:drift_postgres/drift_postgres.dart';
import 'package:shelf/shelf.dart';

import '../database/database.dart';
import '../utils/api_response.dart';

class ArtistHandler {
  final ArtistsDao _artistsDao;

  ArtistHandler(this._artistsDao);

  /// GET /artists?q=query&limit=10
  /// if q == null, return latest 1000 artists
  Future<Response> search(Request request) async {
    final query = request.url.queryParameters['q'];
    final limit =
        int.tryParse(request.url.queryParameters['limit'] ?? '10') ?? 10;

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
    final body = await request.readAsString();
    final data = jsonDecode(body);

    final artist = await _artistsDao.create(
      name: data['name'],
      sourceUrl: data['source_url'],
      notes: data['notes'],
    );

    return ApiResponse.ok(artist.toJson());
  }

  /// PUT /artists/:id
  Future<Response> update(Request request, String id) async {
    final artistId = UuidValue.withValidation(id);
    final body = await request.readAsString();
    final data = jsonDecode(body);

    final artist = await _artistsDao.updateArtist(
      id: artistId,
      name: data['name'],
      sourceUrl: data['source_url'],
      notes: data['notes'],
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
