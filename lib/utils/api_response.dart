import 'dart:convert';

import 'package:drift_postgres/drift_postgres.dart';
import 'package:shelf/shelf.dart';

class ApiResponse {
  static Response ok(
    Object? data, {
    int status = 200,
    Map<String, String>? headers,
  }) {
    return Response(
      status,
      body: jsonEncode({'ok': true, 'data': ?data}, toEncodable: _toEncodable),
      headers: {'content-type': 'application/json', ...?headers},
    );
  }

  static Response error(int status, String code, String message) {
    return Response(
      status,
      body: jsonEncode({
        'ok': false,
        'error': {'code': code, 'message': message},
      }, toEncodable: _toEncodable),
      headers: {'content-type': 'application/json'},
    );
  }

  static Response paginated(
    List<Object?> data, {
    required int page,
    required int pageSize,
    required int total,
    int status = 200,
  }) {
    return Response(
      status,
      body: jsonEncode({
        'ok': true,
        'data': data,
        'meta': {
          'page': page,
          'pageSize': pageSize,
          'total': total,
          'totalPages': (total / pageSize).ceil(),
        },
      }, toEncodable: _toEncodable),
      headers: {'content-type': 'application/json'},
    );
  }

  static Object? _toEncodable(Object? value) {
    if (value is UuidValue) {
      return value.toString();
    }
    if (value is PgDateTime) {
      return value.toDateTime().toIso8601String();
    }
    if (value is DateTime) {
      return value.toIso8601String();
    }
    if (value is BigInt) {
      return value.toString();
    }
    if (value is Enum) {
      return value.name;
    }

    throw UnsupportedError('Cannot convert ${value.runtimeType} to JSON');
  }
}
