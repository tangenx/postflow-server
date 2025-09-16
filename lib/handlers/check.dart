import 'dart:convert';

import 'package:shelf/shelf.dart';

Response checkHandler(Request request) {
  return Response.ok(json.encode({'status': 'ok'}));
}
