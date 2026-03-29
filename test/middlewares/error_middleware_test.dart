import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:test/test.dart';
import 'package:postflow_server/core/exceptions.dart';
import 'package:postflow_server/middlewares/error_middleware.dart';

Request _testRequest() => Request('GET', Uri.parse('http://localhost/test'));

void main() {
  group('errorMiddleware', () {
    test('passes through normal responses', () async {
      final handler = errorMiddleware()(
        (request) => Future.value(Response.ok('ok')),
      );

      final response = await handler(_testRequest());
      expect(response.statusCode, equals(200));
    });

    test('catches UnauthorizedException and returns 401', () async {
      final handler = errorMiddleware()(
        (request) => throw UnauthorizedException('bad token'),
      );

      final response = await handler(_testRequest());

      expect(response.statusCode, equals(401));
      final body = jsonDecode(await response.readAsString());
      expect(body['ok'], isFalse);
      expect(body['error']['code'], equals('UNAUTHORIZED'));
      expect(body['error']['message'], equals('bad token'));
    });

    test('catches ConflictException and returns 409', () async {
      final handler = errorMiddleware()(
        (request) => throw ConflictException('duplicate'),
      );

      final response = await handler(_testRequest());

      expect(response.statusCode, equals(409));
      final body = jsonDecode(await response.readAsString());
      expect(body['error']['code'], equals('CONFLICT'));
      expect(body['error']['message'], equals('duplicate'));
    });

    test('catches NotFoundException and returns 404', () async {
      final handler = errorMiddleware()(
        (request) => throw NotFoundException('missing'),
      );

      final response = await handler(_testRequest());

      expect(response.statusCode, equals(404));
      final body = jsonDecode(await response.readAsString());
      expect(body['error']['code'], equals('NOT_FOUND'));
      expect(body['error']['message'], equals('missing'));
    });

    test('catches ValidationException and returns 400', () async {
      final handler = errorMiddleware()(
        (request) => throw ValidationException('invalid input'),
      );

      final response = await handler(_testRequest());

      expect(response.statusCode, equals(400));
      final body = jsonDecode(await response.readAsString());
      expect(body['error']['code'], equals('VALIDATION_ERROR'));
      expect(body['error']['message'], equals('invalid input'));
    });

    test('catches unknown exceptions and returns 500', () async {
      final handler = errorMiddleware()(
        (request) => throw Exception('unexpected'),
      );

      final response = await handler(_testRequest());

      expect(response.statusCode, equals(500));
      final body = jsonDecode(await response.readAsString());
      expect(body['error']['code'], equals('INTERNAL_SERVER_ERROR'));
    });

    test('all error responses have content-type application/json', () async {
      final exceptions = [
        UnauthorizedException('a'),
        ConflictException('b'),
        NotFoundException('c'),
        ValidationException('d'),
      ];

      for (final ex in exceptions) {
        final handler = errorMiddleware()((request) => throw ex);
        final response = await handler(_testRequest());
        expect(
          response.headers['content-type'],
          equals('application/json'),
          reason: '${ex.runtimeType} response should be JSON',
        );
      }
    });
  });
}
