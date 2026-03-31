import 'package:drift_postgres/drift_postgres.dart';
import 'package:shelf/shelf.dart';

import '../database/database.dart';
import '../utils/api_response.dart';
import '../utils/request_validation.dart';

class FranchiseHandler {
  final FranchisesDao _franchisesDao;

  FranchiseHandler(this._franchisesDao);

  /// GET /franchises?q=query&limit=10
  /// if q == null, return latest 1000 franchises
  Future<Response> search(Request request) async {
    final query = request.url.queryParameters['q'];
    final limit = RequestValidation.optionalPositiveInt(
      request.url.queryParameters,
      'limit',
      fallback: 10,
      max: 1000,
    );

    final result = query == null
        ? await _franchisesDao.getLatest()
        : await _franchisesDao.search(query, limit: limit);

    return ApiResponse.ok(
      result.map(((franchise) => franchise.toJson())).toList(),
    );
  }

  /// GET /franchises/:id
  Future<Response> getById(Request request, String id) async {
    final franchiseId = UuidValue.withValidation(id);
    final franchise = await _franchisesDao.getById(franchiseId);

    if (franchise == null) {
      return ApiResponse.error(404, 'NOT_FOUND', 'Franchise not found');
    }

    return ApiResponse.ok(franchise.toJson());
  }

  /// POST /franchises
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
    final description = RequestValidation.optionalString(
      data,
      'description',
      maxLength: 4000,
    );

    final franchise = await _franchisesDao.create(
      name: name,
      description: description,
    );

    return ApiResponse.ok(franchise.toJson());
  }

  /// PUT /franchises/:id
  Future<Response> update(Request request, String id) async {
    final franchiseId = UuidValue.withValidation(id);
    final data = RequestValidation.parseJsonObject(
      await request.readAsString(),
    );
    final name = RequestValidation.optionalString(data, 'name', maxLength: 255);
    final description = RequestValidation.optionalString(
      data,
      'description',
      maxLength: 4000,
    );

    final franchise = await _franchisesDao.updateFranchise(
      id: franchiseId,
      name: name,
      description: description,
    );

    return ApiResponse.ok(franchise.toJson());
  }

  /// DELETE /franchises/:id
  Future<Response> delete(Request request, String id) async {
    final franchiseId = UuidValue.withValidation(id);
    await _franchisesDao.deleteFranchise(franchiseId);

    return ApiResponse.ok(null);
  }
}
