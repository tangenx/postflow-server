import 'package:drift_postgres/drift_postgres.dart';
import 'package:shelf/shelf.dart';

import '../database/database.dart';
import '../utils/api_response.dart';
import '../utils/request_validation.dart';

class CharacterHandler {
  final CharactersDao _charactersDao;

  CharacterHandler(this._charactersDao);

  /// GET /characters?q=query&limit=10
  /// if q == null, return latest 1000 characters
  Future<Response> search(Request request) async {
    final query = request.url.queryParameters['q'];
    final limit = RequestValidation.optionalPositiveInt(
      request.url.queryParameters,
      'limit',
      fallback: 10,
      max: 1000,
    );

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
    final data = RequestValidation.parseJsonObject(
      await request.readAsString(),
    );
    final franchiseIdRaw = RequestValidation.requiredString(
      data,
      'franchise_id',
      minLength: 1,
      maxLength: 64,
    );
    final name = RequestValidation.requiredString(
      data,
      'name',
      minLength: 1,
      maxLength: 255,
    );
    final description = RequestValidation.optionalString(
      data,
      'description',
      maxLength: 4000,
    );

    final character = await _charactersDao.create(
      franchiseId: UuidValue.withValidation(franchiseIdRaw),
      name: name,
      description: description,
    );

    return ApiResponse.ok(character.toJson());
  }

  /// PUT /characters/:id
  Future<Response> update(Request request, String id) async {
    final characterId = UuidValue.withValidation(id);
    final data = RequestValidation.parseJsonObject(
      await request.readAsString(),
    );
    final franchiseIdRaw = RequestValidation.optionalString(
      data,
      'franchise_id',
      maxLength: 64,
    );
    final name = RequestValidation.optionalString(data, 'name', maxLength: 255);
    final description = RequestValidation.optionalString(
      data,
      'description',
      maxLength: 4000,
    );

    final character = await _charactersDao.updateCharacter(
      id: characterId,
      franchiseId: franchiseIdRaw == null
          ? null
          : UuidValue.withValidation(franchiseIdRaw),
      name: name,
      description: description,
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
