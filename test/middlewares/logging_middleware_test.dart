import 'package:shelf/shelf.dart';
import 'package:test/test.dart';
import 'package:postflow_server/middlewares/logging_middleware.dart';

void main() {
  group('loggingMiddleware', () {
    test('passes through request and returns response unchanged', () async {
      final handler = loggingMiddleware()(
        (request) => Future.value(Response.ok('test-body')),
      );

      final request = Request('GET', Uri.parse('http://localhost/test'));
      final response = await handler(request);

      expect(response.statusCode, equals(200));
      expect(await response.readAsString(), equals('test-body'));
    });

    test('returns correct status code from inner handler', () async {
      final handler = loggingMiddleware()(
        (request) => Future.value(Response.notFound('nope')),
      );

      final request = Request('GET', Uri.parse('http://localhost/test'));
      final response = await handler(request);

      expect(response.statusCode, equals(404));
    });

    test('preserves response headers', () async {
      final handler = loggingMiddleware()(
        (request) => Future.value(
          Response.ok('ok', headers: {'x-custom': 'value'}),
        ),
      );

      final request = Request('GET', Uri.parse('http://localhost/test'));
      final response = await handler(request);

      expect(response.headers['x-custom'], equals('value'));
    });
  });
}
