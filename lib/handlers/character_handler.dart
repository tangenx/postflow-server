import 'dart:convert';

import 'package:drift_postgres/drift_postgres.dart';
import 'package:shelf/shelf.dart';

import '../database/database.dart';
import '../utils/api_response.dart';

class CharacterHandler {
  final CharactersDao _charactersDao;

  CharacterHandler(this._charactersDao);

  /// GET /characters?q=query&limit=10
  /// if q == null, return latest 1000 characters
  Future<Response> search(Request request) async {
    final query = request.url.queryParameters['q'];
    final limit =
        int.tryParse(request.url.queryParameters['limit'] ?? '10') ?? 10;

    final result = query == null
        ? await _charactersDao.getLatest()
        : await _charactersDao.search(query, limit: limit);

    return ApiResponse.ok(
      result.map(((character) => character.toJson())).toList(),
    );
  }

  /// GET /characters/:id
  Future<Response> getById(Request request, String id) async {
    final characterId = UuidValue.withValidation(id);
    final character = await _charactersDao.getById(characterId);

    if (character == null) {
      return ApiResponse.error(404, 'NOT_FOUND', 'Character not found');
    }

    return ApiResponse.ok(character.toJson());
  }

  /// POST /characters
  Future<Response> create(Request request) async {
    final body = await request.readAsString();
    final data = jsonDecode(body);

    final character = await _charactersDao.create(
      franchiseId: UuidValue.withValidation(data['franchise_id']),
      name: data['name'],
      description: data['description'],
    );

    return ApiResponse.ok(character.toJson());
  }

  /// PUT /characters/:id
  Future<Response> update(Request request, String id) async {
    final characterId = UuidValue.withValidation(id);
    final body = await request.readAsString();
    final data = jsonDecode(body);

    final character = await _charactersDao.updateCharacter(
      id: characterId,
      franchiseId: data['franchise_id'] == null
          ? null
          : UuidValue.withValidation(data['franchise_id']),
      name: data['name'],
      description: data['description'],
    );

    return ApiResponse.ok(character.toJson());
  }

  /// DELETE /characters/:id
  Future<Response> delete(Request request, String id) async {
    final characterId = UuidValue.withValidation(id);
    await _charactersDao.deleteCharacter(characterId);

    return ApiResponse.ok(null);
  }
}
