import 'dart:convert';

import 'package:shelf/shelf.dart';

class ApiResponse {
  static Response ok(
    Object? data, {
    int status = 200,
    Map<String, String>? headers,
  }) {
    return Response(
      status,
      body: jsonEncode({'ok': true, 'data': data}),
      headers: {'content-type': 'application/json', ...?headers},
    );
  }

  static Response error(int status, String code, String message) {
    return Response(
      status,
      body: jsonEncode({
        'ok': false,
        'error': {'code': code, 'message': message},
      }),
      headers: {'content-type': 'application/json'},
    );
  }
}
