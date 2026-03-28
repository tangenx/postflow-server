import 'package:shelf/shelf.dart';

import '../utils/logger.dart';

final _logger = Logger('Shelf');

Middleware loggingMiddleware() {
  return (Handler handler) {
    return (Request request) async {
      final sw = Stopwatch()..start();
      _logger.info('--> ${request.method} ${request.requestedUri.path}');

      final response = await handler(request);

      sw.stop();
      _logger.info(
        '<-- ${request.method} ${request.requestedUri.path} '
        '${response.statusCode} ${sw.elapsedMilliseconds}ms',
      );

      return response;
    };
  };
}
