import 'package:shelf/shelf.dart';

import '../utils/logger.dart';

final _logger = Logger('Shelf');

Middleware loggingMiddleware() {
  return (Handler handler) {
    return (Request request) async {
      final sw = Stopwatch()..start();
      final from =
          request.headers['x-forwarded-for'] ??
          request.headers['x-real-ip'] ??
          request.requestedUri.host;
      final colorFrom = '${AnsiColor.green}$from${AnsiColor.reset}';
      _logger.info(
        '$colorFrom --> ${request.method} ${request.requestedUri.path}',
      );

      final response = await handler(request);

      sw.stop();
      _logger.info(
        '$colorFrom <-- ${request.method} ${request.requestedUri.path} '
        '${response.statusCode} ${sw.elapsedMilliseconds}ms',
      );

      return response;
    };
  };
}
