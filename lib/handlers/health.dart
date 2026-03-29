import 'package:shelf/shelf.dart';

import '../database/database.dart';
import '../di.dart';
import '../utils/api_response.dart';
import '../utils/logger.dart';

const _log = Logger('Health');

Future<Response> healthHandler(Request request) async {
  try {
    await sl.get<PostflowDatabase>().customSelect('SELECT 1').get();
    return ApiResponse.ok({'backend': 'ok', 'database': 'ok'});
  } catch (e) {
    _log.error('Database unreachable', e);
    return ApiResponse.error(
      500,
      'INTERNAL_SERVER_ERROR',
      'Database unreachable',
    );
  }
}
