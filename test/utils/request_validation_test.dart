import 'package:test/test.dart';
import 'package:postflow_server/utils/request_validation.dart';
import 'package:postflow_server/core/exceptions.dart';

void main() {
  group('RequestValidation', () {
    group('parseJsonObject', () {
      test('parses valid JSON object', () {
        final result = RequestValidation.parseJsonObject('{"key": "value"}');
        expect(result, equals({'key': 'value'}));
      });

      test('throws on empty body', () {
        expect(
          () => RequestValidation.parseJsonObject(''),
          throwsA(isA<ValidationException>()),
        );
      });

      test('throws on whitespace-only body', () {
        expect(
          () => RequestValidation.parseJsonObject('   '),
          throwsA(isA<ValidationException>()),
        );
      });

      test('throws on JSON array', () {
        expect(
          () => RequestValidation.parseJsonObject('[1, 2, 3]'),
          throwsA(isA<ValidationException>()),
        );
      });

      test('throws on JSON primitive', () {
        expect(
          () => RequestValidation.parseJsonObject('"hello"'),
          throwsA(isA<ValidationException>()),
        );
      });

      test('throws ValidationException on invalid JSON', () {
        expect(
          () => RequestValidation.parseJsonObject('not json'),
          throwsA(
            isA<ValidationException>().having(
              (e) => e.message,
              'message',
              contains('valid JSON'),
            ),
          ),
        );
      });
    });

    group('requiredString', () {
      test('returns trimmed string', () {
        final result = RequestValidation.requiredString({
          'k': '  hello  ',
        }, 'k');
        expect(result, equals('hello'));
      });

      test('throws when key is missing', () {
        expect(
          () => RequestValidation.requiredString({}, 'name'),
          throwsA(isA<ValidationException>()),
        );
      });

      test('throws when value is not a string', () {
        expect(
          () => RequestValidation.requiredString({'k': 123}, 'k'),
          throwsA(isA<ValidationException>()),
        );
      });

      test('throws on empty string after trim', () {
        expect(
          () => RequestValidation.requiredString({'k': '   '}, 'k'),
          throwsA(isA<ValidationException>()),
        );
      });

      test('throws when shorter than minLength', () {
        expect(
          () =>
              RequestValidation.requiredString({'k': 'ab'}, 'k', minLength: 3),
          throwsA(isA<ValidationException>()),
        );
      });

      test('passes at exact minLength', () {
        final result = RequestValidation.requiredString(
          {'k': 'abc'},
          'k',
          minLength: 3,
        );
        expect(result, equals('abc'));
      });

      test('throws when longer than maxLength', () {
        expect(
          () => RequestValidation.requiredString(
            {'k': 'abcde'},
            'k',
            maxLength: 4,
          ),
          throwsA(isA<ValidationException>()),
        );
      });

      test('passes at exact maxLength', () {
        final result = RequestValidation.requiredString(
          {'k': 'abcd'},
          'k',
          maxLength: 4,
        );
        expect(result, equals('abcd'));
      });
    });

    group('optionalString', () {
      test('returns null when key is missing', () {
        final result = RequestValidation.optionalString({}, 'k');
        expect(result, isNull);
      });

      test('returns null when value is null', () {
        final result = RequestValidation.optionalString({'k': null}, 'k');
        expect(result, isNull);
      });

      test('returns null when value is empty after trim', () {
        final result = RequestValidation.optionalString({'k': '   '}, 'k');
        expect(result, isNull);
      });

      test('returns trimmed string for valid value', () {
        final result = RequestValidation.optionalString({'k': '  hi  '}, 'k');
        expect(result, equals('hi'));
      });

      test('throws when value is not a string', () {
        expect(
          () => RequestValidation.optionalString({'k': 42}, 'k'),
          throwsA(isA<ValidationException>()),
        );
      });

      test('throws when longer than maxLength', () {
        expect(
          () => RequestValidation.optionalString(
            {'k': 'abcde'},
            'k',
            maxLength: 4,
          ),
          throwsA(isA<ValidationException>()),
        );
      });

      test('passes at exact maxLength', () {
        final result = RequestValidation.optionalString(
          {'k': 'abcd'},
          'k',
          maxLength: 4,
        );
        expect(result, equals('abcd'));
      });
    });

    group('optionalPositiveInt', () {
      test('returns fallback when key is missing', () {
        final result = RequestValidation.optionalPositiveInt({}, 'limit');
        expect(result, equals(10));
      });

      test('returns parsed value for valid integer', () {
        final result = RequestValidation.optionalPositiveInt({
          'limit': '25',
        }, 'limit');
        expect(result, equals(25));
      });

      test('throws on non-integer value', () {
        expect(
          () => RequestValidation.optionalPositiveInt({'k': 'abc'}, 'k'),
          throwsA(isA<ValidationException>()),
        );
      });

      test('throws when below min', () {
        expect(
          () => RequestValidation.optionalPositiveInt({'k': '0'}, 'k', min: 1),
          throwsA(isA<ValidationException>()),
        );
      });

      test('throws when above max', () {
        expect(
          () => RequestValidation.optionalPositiveInt(
            {'k': '1001'},
            'k',
            max: 1000,
          ),
          throwsA(isA<ValidationException>()),
        );
      });

      test('passes at exact min boundary', () {
        final result = RequestValidation.optionalPositiveInt(
          {'k': '1'},
          'k',
          min: 1,
        );
        expect(result, equals(1));
      });

      test('passes at exact max boundary', () {
        final result = RequestValidation.optionalPositiveInt(
          {'k': '1000'},
          'k',
          max: 1000,
        );
        expect(result, equals(1000));
      });

      test('uses custom fallback', () {
        final result = RequestValidation.optionalPositiveInt(
          {},
          'limit',
          fallback: 50,
        );
        expect(result, equals(50));
      });
    });
  });
}
