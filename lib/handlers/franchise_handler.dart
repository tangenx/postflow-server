import 'dart:convert';

import 'package:drift_postgres/drift_postgres.dart';
import 'package:shelf/shelf.dart';

import '../database/database.dart';
import '../utils/api_response.dart';

class FranchiseHandler {
  final FranchisesDao _franchisesDao;

  FranchiseHandler(this._franchisesDao);

  /// GET /franchises?q=query&limit=10
  /// if q == null, return latest 1000 franchises
  Future<Response> search(Request request) async {
    final query = request.url.queryParameters['q'];
    final limit =
        int.tryParse(request.url.queryParameters['limit'] ?? '10') ?? 10;

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
    final body = await request.readAsString();
    final data = jsonDecode(body);

    final franchise = await _franchisesDao.create(
      name: data['name'],
      description: data['description'],
    );

    return ApiResponse.ok(franchise.toJson());
  }

  /// PUT /franchises/:id
  Future<Response> update(Request request, String id) async {
    final franchiseId = UuidValue.withValidation(id);
    final body = await request.readAsString();
    final data = jsonDecode(body);

    final franchise = await _franchisesDao.updateFranchise(
      id: franchiseId,
      name: data['name'],
      description: data['description'],
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
