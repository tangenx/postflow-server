import 'dart:convert';

import 'package:drift_postgres/drift_postgres.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';
import 'package:postflow_server/core/exceptions.dart';
import 'package:postflow_server/database/database.dart';
import 'package:postflow_server/handlers/franchise_handler.dart';

// ---------------------------------------------------------------------------
// Fake DAO
// ---------------------------------------------------------------------------

class FakeFranchisesDao implements FranchisesDao {
  final List<Franchise> _franchises;
  Object? _exception;

  FakeFranchisesDao([this._franchises = const []]);

  void setException(Object ex) => _exception = ex;

  void _maybeThrow() {
    if (_exception != null) throw _exception!;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  Future<List<Franchise>> getLatest() async {
    _maybeThrow();
    return _franchises;
  }

  @override
  Future<List<Franchise>> search(String query, {int limit = 10}) async {
    _maybeThrow();
    return _franchises
        .where((f) => f.name.contains(query))
        .take(limit)
        .toList();
  }

  @override
  Future<Franchise?> getById(UuidValue id) async {
    _maybeThrow();
    return _franchises.where((f) => f.id == id).firstOrNull;
  }

  @override
  Future<Franchise> create({
    required String name,
    String? description,
  }) async {
    _maybeThrow();
    return Franchise(
      id: UuidValue.fromString('11111111-1111-1111-1111-111111111111'),
      name: name,
      description: description,
      createdAt: PgDateTime(DateTime.utc(2024)),
    );
  }

  @override
  Future<Franchise> updateFranchise({
    required UuidValue id,
    String? name,
    String? description,
  }) async {
    _maybeThrow();
    final existing = _franchises.firstWhere(
      (f) => f.id == id,
      orElse: () => throw NotFoundException('Franchise not found'),
    );
    return Franchise(
      id: existing.id,
      name: name ?? existing.name,
      description: description ?? existing.description,
      createdAt: existing.createdAt,
    );
  }

  @override
  Future<int> deleteFranchise(UuidValue id) async {
    _maybeThrow();
    return _franchises.where((f) => f.id == id).length;
  }
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

const _franchiseId1 = '550e8400-e29b-41d4-a716-446655440000';
const _franchiseId2 = '660e8400-e29b-41d4-a716-446655440001';

final _testFranchises = [
  Franchise(
    id: UuidValue.fromString(_franchiseId1),
    name: 'Vocaloid',
    description: 'Singing synthesizer',
    createdAt: PgDateTime(DateTime.utc(2024)),
  ),
  Franchise(
    id: UuidValue.fromString(_franchiseId2),
    name: 'Touhou Project',
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
  late FakeFranchisesDao fakeDao;
  late FranchiseHandler handler;

  setUp(() {
    fakeDao = FakeFranchisesDao(List.of(_testFranchises));
    handler = FranchiseHandler(fakeDao);
  });

  group('FranchiseHandler', () {
    group('search', () {
      test('returns all franchises when no query param', () async {
        final request = Request(
          'GET',
          Uri.parse('http://localhost/franchises'),
        );

        final response = await handler.search(request);

        expect(response.statusCode, equals(200));
        final body = jsonDecode(await response.readAsString());
        expect(body['ok'], isTrue);
        expect((body['data'] as List).length, equals(2));
      });

      test('filters franchises by query', () async {
        final request = Request(
          'GET',
          Uri.parse('http://localhost/franchises?q=Vocal'),
        );

        final response = await handler.search(request);

        expect(response.statusCode, equals(200));
        final body = jsonDecode(await response.readAsString());
        expect(body['ok'], isTrue);
        expect((body['data'] as List).length, equals(1));
        expect(body['data'][0]['name'], equals('Vocaloid'));
      });

      test('respects limit query param', () async {
        final request = Request(
          'GET',
          Uri.parse('http://localhost/franchises?q=o&limit=1'),
        );

        final response = await handler.search(request);

        final body = jsonDecode(await response.readAsString());
        expect((body['data'] as List).length, equals(1));
      });

      test('throws on invalid limit', () async {
        final request = Request(
          'GET',
          Uri.parse('http://localhost/franchises?q=o&limit=abc'),
        );

        expect(
          () => handler.search(request),
          throwsA(isA<ValidationException>()),
        );
      });

      test('returns empty list when nothing matches', () async {
        final request = Request(
          'GET',
          Uri.parse('http://localhost/franchises?q=nonexistent'),
        );

        final response = await handler.search(request);

        final body = jsonDecode(await response.readAsString());
        expect((body['data'] as List), isEmpty);
      });
    });

    group('getById', () {
      test('returns franchise when found', () async {
        final request = Request(
          'GET',
          Uri.parse('http://localhost/franchises/$_franchiseId1'),
        );

        final response = await handler.getById(request, _franchiseId1);

        expect(response.statusCode, equals(200));
        final body = jsonDecode(await response.readAsString());
        expect(body['ok'], isTrue);
        expect(body['data']['name'], equals('Vocaloid'));
      });

      test('returns 404 when not found', () async {
        const missingId = '00000000-0000-0000-0000-000000000000';
        final request = Request(
          'GET',
          Uri.parse('http://localhost/franchises/$missingId'),
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
          Uri.parse('http://localhost/franchises/not-a-uuid'),
        );

        expect(
          () => handler.getById(request, 'not-a-uuid'),
          throwsA(isA<FormatException>()),
        );
      });
    });

    group('create', () {
      test('returns 200 with created franchise', () async {
        final request = _jsonPost('franchises', {
          'name': 'Hatsune Miku',
          'description': 'A vocaloid franchise',
        });

        final response = await handler.create(request);

        expect(response.statusCode, equals(200));
        final body = jsonDecode(await response.readAsString());
        expect(body['ok'], isTrue);
        expect(body['data']['name'], equals('Hatsune Miku'));
      });

      test('works with null description', () async {
        final request = _jsonPost('franchises', {
          'name': 'Name Only',
        });

        final response = await handler.create(request);

        expect(response.statusCode, equals(200));
        final body = jsonDecode(await response.readAsString());
        expect(body['data']['name'], equals('Name Only'));
      });
    });

    group('update', () {
      test('returns 200 with updated franchise', () async {
        final request = _jsonPut('franchises/$_franchiseId1', {
          'name': 'Vocaloid Updated',
        });

        final response = await handler.update(request, _franchiseId1);

        expect(response.statusCode, equals(200));
        final body = jsonDecode(await response.readAsString());
        expect(body['ok'], isTrue);
        expect(body['data']['name'], equals('Vocaloid Updated'));
      });

      test('throws when franchise not found', () {
        const missingId = '00000000-0000-0000-0000-000000000000';
        final request = _jsonPut('franchises/$missingId', {
          'name': 'Ghost',
        });

        expect(
          () => handler.update(request, missingId),
          throwsA(isA<NotFoundException>()),
        );
      });

      test('throws FormatException for invalid UUID', () {
        final request = _jsonPut('franchises/bad-uuid', {'name': 'X'});

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
          Uri.parse('http://localhost/franchises/$_franchiseId1'),
        );

        final response = await handler.delete(request, _franchiseId1);

        expect(response.statusCode, equals(200));
        final body = jsonDecode(await response.readAsString());
        expect(body['ok'], isTrue);
      });

      test('throws FormatException for invalid UUID', () {
        final request = Request(
          'DELETE',
          Uri.parse('http://localhost/franchises/bad-uuid'),
        );

        expect(
          () => handler.delete(request, 'bad-uuid'),
          throwsA(isA<FormatException>()),
        );
      });
    });
  });
}
