import 'dart:convert';

import 'package:shelf/shelf.dart';

import '../database/database.dart';
import '../di.dart';
import '../utils/logger.dart';

const _log = Logger('Health');

Future<Response> healthHandler(Request request) async {
  try {
    await sl.get<PostflowDatabase>().customSelect('SELECT 1').get();
    return Response.ok(
      jsonEncode({'status': 'ok', 'database': 'ok'}),
      headers: {'content-type': 'application/json'},
    );
  } catch (e) {
    _log.error('Database unreachable', e);
    return Response.internalServerError(
      body: jsonEncode({'status': 'error', 'database': 'unreachable'}),
      headers: {'content-type': 'application/json'},
    );
  }
}
