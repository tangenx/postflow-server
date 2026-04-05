import 'package:test/test.dart';
import 'package:postflow_server/services/caption_service.dart';

void main() {
  late CaptionService service;

  setUp(() {
    service = CaptionService();
  });

  group('CaptionService', () {
    group('render', () {
      test('replaces plain variables', () {
        final result = service.render(
          templateBody: 'Hello {{name}}, welcome!',
          variables: {'name': 'Alice'},
        );

        expect(result, equals('Hello Alice, welcome!'));
      });

      test('replaces multiple variables', () {
        final result = service.render(
          templateBody: '{{artist}} - {{franchise}}',
          variables: {'artist': 'Miku', 'franchise': 'Vocaloid'},
        );

        expect(result, equals('Miku - Vocaloid'));
      });

      test('replaces hashtag variables', () {
        final result = service.render(
          templateBody: '{{#franchise}}',
          variables: {'franchise': 'Vocaloid'},
        );

        expect(result, equals('#vocaloid'));
      });

      test('hashtag lowercases and replaces non-word chars with underscore', () {
        final result = service.render(
          templateBody: '{{#franchise}}',
          variables: {'franchise': 'Touhou Project'},
        );

        expect(result, equals('#touhou_project'));
      });

      test('missing variable is not replaced (left as placeholder)', () {
        final result = service.render(
          templateBody: '{{franchise}} by {{artist}}',
          variables: {'franchise': 'Vocaloid'},
        );

        expect(result, equals('Vocaloid by {{artist}}'));
      });

      test('missing hashtag variable is not replaced', () {
        final result = service.render(
          templateBody: '{{#franchise}}',
          variables: {},
        );

        expect(result, equals('{{#franchise}}'));
      });

      test('removes dangling "from by" when middle variable is empty', () {
        final result = service.render(
          templateBody: 'from {{franchise}} by {{artist}}',
          variables: {'franchise': '', 'artist': 'Miku'},
        );

        expect(result, equals('by Miku'));
      });

      test('removes leading "from" when variable is empty', () {
        final result = service.render(
          templateBody: 'from {{franchise}} {{artist}}',
          variables: {'franchise': '', 'artist': 'Miku'},
        );

        expect(result, equals('Miku'));
      });

      test('removes trailing "from" when variable is empty', () {
        final result = service.render(
          templateBody: '{{artist}} from {{franchise}}',
          variables: {'artist': 'Miku', 'franchise': ''},
        );

        expect(result, equals('Miku'));
      });

      test('removes trailing "by" when variable is empty', () {
        final result = service.render(
          templateBody: '{{artist}} by {{franchise}}',
          variables: {'artist': 'Miku', 'franchise': ''},
        );

        expect(result, equals('Miku'));
      });

      test('collapses multiple spaces', () {
        final result = service.render(
          templateBody: '{{a}}   {{b}}',
          variables: {'a': 'x', 'b': 'y'},
        );

        expect(result, equals('x y'));
      });

      test('trims leading and trailing whitespace', () {
        final result = service.render(
          templateBody: '  {{name}}  ',
          variables: {'name': 'Alice'},
        );

        expect(result, equals('Alice'));
      });

      test('handles empty template body', () {
        final result = service.render(
          templateBody: '',
          variables: {'name': 'Alice'},
        );

        expect(result, equals(''));
      });

      test('handles template with no variables', () {
        final result = service.render(
          templateBody: 'Static text here',
          variables: {'name': 'Alice'},
        );

        expect(result, equals('Static text here'));
      });

      test('trims variable values', () {
        final result = service.render(
          templateBody: '{{name}}',
          variables: {'name': '  Alice  '},
        );

        expect(result, equals('Alice'));
      });
    });

    group('systemVariables', () {
      test('contains all expected system variable names', () {
        expect(CaptionService.systemVariables, containsAll([
          'character', 'artist', 'franchise', 'fandom',
          'description', 'source_url', 'account_shortlink',
          'target_label', 'date', 'date_short', 'media_count',
        ]));
      });
    });
  });
}
