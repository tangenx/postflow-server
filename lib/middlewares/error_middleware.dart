import 'package:shelf/shelf.dart';

import '../core/exceptions.dart';

Middleware errorMiddleware() {
  return (Handler handler) {
    return (Request request) {
      try {
        return handler(request);
      } on UnauthorizedException catch (e) {
        return Response.unauthorized(e.toJson());
      } on ConflictException catch (e) {
        return Response(409, body: e.toJson());
      } on NotFoundException catch (e) {
        return Response.notFound(e.toJson());
      } on ValidationException catch (e) {
        return Response.badRequest(body: e.toJson());
      } catch (e, s) {
        print('Unhandled error: $e\n$s');

        return Response.internalServerError(body: e.toString());
      }
    };
  };
}
