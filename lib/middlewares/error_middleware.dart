import 'package:shelf/shelf.dart';

import '../core/exceptions.dart';
import '../utils/api_response.dart';
import '../utils/logger.dart';

final _logger = Logger('errorMiddleware');

Middleware errorMiddleware() {
  return (Handler handler) {
    return (Request request) async {
      try {
        return await handler(request);
      } on UnauthorizedException catch (e) {
        return ApiResponse.error(401, 'UNAUTHORIZED', e.message);
      } on ConflictException catch (e) {
        return ApiResponse.error(409, 'CONFLICT', e.message);
      } on NotFoundException catch (e) {
        return ApiResponse.error(404, 'NOT_FOUND', e.message);
      } on ValidationException catch (e) {
        return ApiResponse.error(400, 'VALIDATION_ERROR', e.message);
      } on FormatException catch (e) {
        return ApiResponse.error(400, 'VALIDATION_ERROR', e.message);
      } catch (e, s) {
        _logger.error('Unhandled error', e, s);
        return ApiResponse.error(500, 'INTERNAL_SERVER_ERROR', e.toString());
      }
    };
  };
}
