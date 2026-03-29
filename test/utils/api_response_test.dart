import 'dart:convert';

import 'package:test/test.dart';
import 'package:postflow_server/utils/api_response.dart';

void main() {
  group('ApiResponse', () {
    group('ok', () {
      test('returns 200 with correct JSON structure', () async {
        final response = ApiResponse.ok({'key': 'value'});

        expect(response.statusCode, equals(200));

        final body = jsonDecode(await response.readAsString());
        expect(body, equals({'ok': true, 'data': {'key': 'value'}}));
      });

      test('respects custom status code', () async {
        final response = ApiResponse.ok({'created': true}, status: 201);

        expect(response.statusCode, equals(201));

        final body = jsonDecode(await response.readAsString());
        expect(body['ok'], isTrue);
      });

      test('handles null data by omitting data key', () async {
        final response = ApiResponse.ok(null);

        final body = jsonDecode(await response.readAsString());
        // ?data omits the key when null (Dart 3 null-aware map syntax)
        expect(body, equals({'ok': true}));
      });

      test('handles string data', () async {
        final response = ApiResponse.ok('hello');

        final body = jsonDecode(await response.readAsString());
        expect(body, equals({'ok': true, 'data': 'hello'}));
      });

      test('handles list data', () async {
        final response = ApiResponse.ok([1, 2, 3]);

        final body = jsonDecode(await response.readAsString());
        expect(body, equals({'ok': true, 'data': [1, 2, 3]}));
      });

      test('sets content-type header to application/json', () {
        final response = ApiResponse.ok('test');

        expect(response.headers['content-type'], equals('application/json'));
      });

      test('merges custom headers', () {
        final response = ApiResponse.ok(
          'test',
          headers: {'x-custom': 'value'},
        );

        expect(response.headers['content-type'], equals('application/json'));
        expect(response.headers['x-custom'], equals('value'));
      });
    });

    group('error', () {
      test('returns correct status and JSON structure', () async {
        final response = ApiResponse.error(400, 'BAD_REQUEST', 'Invalid input');

        expect(response.statusCode, equals(400));

        final body = jsonDecode(await response.readAsString());
        expect(
          body,
          equals({
            'ok': false,
            'error': {'code': 'BAD_REQUEST', 'message': 'Invalid input'},
          }),
        );
      });

      test('sets content-type header to application/json', () {
        final response = ApiResponse.error(500, 'ERROR', 'msg');

        expect(response.headers['content-type'], equals('application/json'));
      });

      test('returns 500 for server error', () async {
        final response = ApiResponse.error(
          500,
          'INTERNAL_SERVER_ERROR',
          'Database unreachable',
        );

        expect(response.statusCode, equals(500));

        final body = jsonDecode(await response.readAsString());
        expect(body['ok'], isFalse);
        expect(body['error']['code'], equals('INTERNAL_SERVER_ERROR'));
      });

      test('returns 401 for unauthorized', () async {
        final response = ApiResponse.error(401, 'UNAUTHORIZED', 'Bad token');

        expect(response.statusCode, equals(401));

        final body = jsonDecode(await response.readAsString());
        expect(body['ok'], isFalse);
        expect(body['error']['message'], equals('Bad token'));
      });
    });
  });
}
