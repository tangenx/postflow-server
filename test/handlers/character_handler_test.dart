import 'dart:convert';

import 'package:drift_postgres/drift_postgres.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';
import 'package:postflow_server/core/exceptions.dart';
import 'package:postflow_server/database/database.dart';
import 'package:postflow_server/handlers/character_handler.dart';

// ---------------------------------------------------------------------------
// Fake DAO
// ---------------------------------------------------------------------------

class FakeCharactersDao implements CharactersDao {
  final List<Character> _characters;
  Object? _exception;

  FakeCharactersDao([this._characters = const []]);

  void setException(Object ex) => _exception = ex;

  void _maybeThrow() {
    if (_exception != null) throw _exception!;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  Future<List<Character>> getLatest() async {
    _maybeThrow();
    return _characters;
  }

  @override
  Future<List<Character>> search(String query, {int limit = 10}) async {
    _maybeThrow();
    return _characters
        .where((c) => c.name.contains(query))
        .take(limit)
        .toList();
  }

  @override
  Future<Character?> getById(UuidValue id) async {
    _maybeThrow();
    return _characters.where((c) => c.id == id).firstOrNull;
  }

  @override
  Future<Character> create({
    required UuidValue franchiseId,
    required String name,
    String? description,
  }) async {
    _maybeThrow();
    return Character(
      id: UuidValue.fromString('11111111-1111-1111-1111-111111111111'),
      franchiseId: franchiseId,
      name: name,
      description: description,
      createdAt: PgDateTime(DateTime.utc(2024)),
    );
  }

  @override
  Future<Character> updateCharacter({
    required UuidValue id,
    UuidValue? franchiseId,
    String? name,
    String? description,
  }) async {
    _maybeThrow();
    final existing = _characters.firstWhere(
      (c) => c.id == id,
      orElse: () => throw NotFoundException('Character not found'),
    );
    return Character(
      id: existing.id,
      franchiseId: franchiseId ?? existing.franchiseId,
      name: name ?? existing.name,
      description: description ?? existing.description,
      createdAt: existing.createdAt,
    );
  }

  @override
  Future<int> deleteCharacter(UuidValue id) async {
    _maybeThrow();
    return _characters.where((c) => c.id == id).length;
  }
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

const _franchiseId = 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11';
const _charId1 = '550e8400-e29b-41d4-a716-446655440000';
const _charId2 = '660e8400-e29b-41d4-a716-446655440001';

final _testCharacters = [
  Character(
    id: UuidValue.fromString(_charId1),
    franchiseId: UuidValue.fromString(_franchiseId),
    name: 'Miku',
    description: 'Vocaloid',
    createdAt: PgDateTime(DateTime.utc(2024)),
  ),
  Character(
    id: UuidValue.fromString(_charId2),
    franchiseId: UuidValue.fromString(_franchiseId),
    name: 'Rin',
    description: null,
    createdAt: PgDateTime(DateTime.utc(2024)),
  ),
];

Request _jsonPost(String path, Map<String, dynamic> body) {
  return Request(
    'POST',
    Uri.parse('http://localhost/$path'),
    body: jsonEncode(body),
    headers: {'content-type': 'application/json'},
  );
}

Request _jsonPut(String path, Map<String, dynamic> body) {
  return Request(
    'PUT',
    Uri.parse('http://localhost/$path'),
    body: jsonEncode(body),
    headers: {'content-type': 'application/json'},
  );
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  late FakeCharactersDao fakeDao;
  late CharacterHandler handler;

  setUp(() {
    fakeDao = FakeCharactersDao(List.of(_testCharacters));
    handler = CharacterHandler(fakeDao);
  });

  group('CharacterHandler', () {
    group('search', () {
      test('returns all characters when no query param', () async {
        final request = Request(
          'GET',
          Uri.parse('http://localhost/characters'),
        );

        final response = await handler.search(request);

        expect(response.statusCode, equals(200));
        final body = jsonDecode(await response.readAsString());
        expect(body['ok'], isTrue);
        expect((body['data'] as List).length, equals(2));
      });

      test('filters characters by query', () async {
        final request = Request(
          'GET',
          Uri.parse('http://localhost/characters?q=Miku'),
        );

        final response = await handler.search(request);

        expect(response.statusCode, equals(200));
        final body = jsonDecode(await response.readAsString());
        expect(body['ok'], isTrue);
        expect((body['data'] as List).length, equals(1));
        expect(body['data'][0]['name'], equals('Miku'));
      });

      test('respects limit query param', () async {
        final request = Request(
          'GET',
          Uri.parse('http://localhost/characters?q=i&limit=1'),
        );

        final response = await handler.search(request);

        final body = jsonDecode(await response.readAsString());
        expect((body['data'] as List).length, equals(1));
      });

      test('throws on invalid limit', () async {
        final request = Request(
          'GET',
          Uri.parse('http://localhost/characters?q=i&limit=abc'),
        );

        expect(
          () => handler.search(request),
          throwsA(isA<ValidationException>()),
        );
      });

      test('returns empty list when nothing matches', () async {
        final request = Request(
          'GET',
          Uri.parse('http://localhost/characters?q=nonexistent'),
        );

        final response = await handler.search(request);

        final body = jsonDecode(await response.readAsString());
        expect((body['data'] as List), isEmpty);
      });
    });

    group('getById', () {
      test('returns character when found', () async {
        final request = Request(
          'GET',
          Uri.parse('http://localhost/characters/$_charId1'),
        );

        final response = await handler.getById(request, _charId1);

        expect(response.statusCode, equals(200));
        final body = jsonDecode(await response.readAsString());
        expect(body['ok'], isTrue);
        expect(body['data']['name'], equals('Miku'));
      });

      test('returns 404 when not found', () async {
        const missingId = '00000000-0000-0000-0000-000000000000';
        final request = Request(
          'GET',
          Uri.parse('http://localhost/characters/$missingId'),
        );

        final response = await handler.getById(request, missingId);

        expect(response.statusCode, equals(404));
        final body = jsonDecode(await response.readAsString());
        expect(body['ok'], isFalse);
        expect(body['error']['code'], equals('NOT_FOUND'));
      });

      test('throws FormatException for invalid UUID', () {
        final request = Request(
          'GET',
          Uri.parse('http://localhost/characters/not-a-uuid'),
        );

        expect(
          () => handler.getById(request, 'not-a-uuid'),
          throwsA(isA<FormatException>()),
        );
      });
    });

    group('create', () {
      test('returns 200 with created character', () async {
        final request = _jsonPost('characters', {
          'franchise_id': _franchiseId,
          'name': 'Luka',
          'description': 'Vocaloid',
        });

        final response = await handler.create(request);

        expect(response.statusCode, equals(200));
        final body = jsonDecode(await response.readAsString());
        expect(body['ok'], isTrue);
        expect(body['data']['name'], equals('Luka'));
      });

      test('works with null description', () async {
        final request = _jsonPost('characters', {
          'franchise_id': _franchiseId,
          'name': 'Kaito',
        });

        final response = await handler.create(request);

        expect(response.statusCode, equals(200));
        final body = jsonDecode(await response.readAsString());
        expect(body['data']['name'], equals('Kaito'));
      });

      test('throws FormatException for invalid franchise_id', () {
        final request = _jsonPost('characters', {
          'franchise_id': 'not-a-uuid',
          'name': 'Broken',
        });

        expect(
          () => handler.create(request),
          throwsA(isA<FormatException>()),
        );
      });
    });

    group('update', () {
      test('returns 200 with updated character', () async {
        final request = _jsonPut('characters/$_charId1', {
          'name': 'Miku Updated',
        });

        final response = await handler.update(request, _charId1);

        expect(response.statusCode, equals(200));
        final body = jsonDecode(await response.readAsString());
        expect(body['ok'], isTrue);
        expect(body['data']['name'], equals('Miku Updated'));
      });

      test('allows updating franchise_id', () async {
        const newFranchise = 'b0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11';
        final request = _jsonPut('characters/$_charId1', {
          'franchise_id': newFranchise,
          'name': 'Miku',
        });

        final response = await handler.update(request, _charId1);

        expect(response.statusCode, equals(200));
      });

      test('handles null franchise_id in body', () async {
        final request = _jsonPut('characters/$_charId1', {
          'name': 'Miku',
        });

        final response = await handler.update(request, _charId1);

        expect(response.statusCode, equals(200));
      });

      test('throws when character not found', () {
        const missingId = '00000000-0000-0000-0000-000000000000';
        final request = _jsonPut('characters/$missingId', {'name': 'Ghost'});

        expect(
          () => handler.update(request, missingId),
          throwsA(isA<NotFoundException>()),
        );
      });

      test('throws FormatException for invalid UUID', () {
        final request = _jsonPut('characters/bad-uuid', {'name': 'X'});

        expect(
          () => handler.update(request, 'bad-uuid'),
          throwsA(isA<FormatException>()),
        );
      });
    });

    group('delete', () {
      test('returns 200', () async {
        final request = Request(
          'DELETE',
          Uri.parse('http://localhost/characters/$_charId1'),
        );

        final response = await handler.delete(request, _charId1);

        expect(response.statusCode, equals(200));
        final body = jsonDecode(await response.readAsString());
        expect(body['ok'], isTrue);
      });

      test('throws FormatException for invalid UUID', () {
        final request = Request(
          'DELETE',
          Uri.parse('http://localhost/characters/bad-uuid'),
        );

        expect(
          () => handler.delete(request, 'bad-uuid'),
          throwsA(isA<FormatException>()),
        );
      });
    });
  });
}
