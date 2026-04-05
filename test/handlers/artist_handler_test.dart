import 'dart:convert';

import 'package:drift_postgres/drift_postgres.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';
import 'package:postflow_server/core/exceptions.dart';
import 'package:postflow_server/database/database.dart';
import 'package:postflow_server/handlers/artist_handler.dart';

// ---------------------------------------------------------------------------
// Fake DAO
// ---------------------------------------------------------------------------

class FakeArtistsDao implements ArtistsDao {
  final List<Artist> _artists;
  Object? _exception;

  FakeArtistsDao([this._artists = const []]);

  void setException(Object ex) => _exception = ex;

  void _maybeThrow() {
    if (_exception != null) throw _exception!;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  Future<List<Artist>> getLatest() async {
    _maybeThrow();
    return _artists;
  }

  @override
  Future<List<Artist>> search(String query, {int limit = 10}) async {
    _maybeThrow();
    return _artists.where((a) => a.name.contains(query)).take(limit).toList();
  }

  @override
  Future<Artist?> getById(UuidValue id) async {
    _maybeThrow();
    return _artists.where((a) => a.id == id).firstOrNull;
  }

  @override
  Future<Artist> create({
    required String name,
    String? sourceUrl,
    String? notes,
  }) async {
    _maybeThrow();
    return Artist(
      id: UuidValue.fromString('11111111-1111-1111-1111-111111111111'),
      name: name,
      sourceUrl: sourceUrl,
      notes: notes,
      createdAt: PgDateTime(DateTime.utc(2024)),
    );
  }

  @override
  Future<Artist> updateArtist({
    required UuidValue id,
    String? name,
    String? sourceUrl,
    String? notes,
  }) async {
    _maybeThrow();
    final existing = _artists.firstWhere(
      (a) => a.id == id,
      orElse: () => throw NotFoundException('Artist not found'),
    );
    return Artist(
      id: existing.id,
      name: name ?? existing.name,
      sourceUrl: sourceUrl ?? existing.sourceUrl,
      notes: notes ?? existing.notes,
      createdAt: existing.createdAt,
    );
  }

  @override
  Future<int> deleteArtist(UuidValue id) async {
    _maybeThrow();
    final count = _artists.where((a) => a.id == id).length;
    return count;
  }
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

const _artistId1 = '550e8400-e29b-41d4-a716-446655440000';
const _artistId2 = '660e8400-e29b-41d4-a716-446655440001';

final _testArtists = [
  Artist(
    id: UuidValue.fromString(_artistId1),
    name: 'Alice',
    sourceUrl: 'https://example.com/alice',
    notes: 'Digital artist',
    createdAt: PgDateTime(DateTime.utc(2024)),
  ),
  Artist(
    id: UuidValue.fromString(_artistId2),
    name: 'Bob',
    sourceUrl: null,
    notes: null,
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
  late FakeArtistsDao fakeDao;
  late ArtistHandler handler;

  setUp(() {
    fakeDao = FakeArtistsDao(List.of(_testArtists));
    handler = ArtistHandler(fakeDao);
  });

  group('ArtistHandler', () {
    group('search', () {
      test('returns all artists when no query param', () async {
        final request = Request(
          'GET',
          Uri.parse('http://localhost/artists'),
        );

        final response = await handler.search(request);

        expect(response.statusCode, equals(200));
        final body = jsonDecode(await response.readAsString());
        expect(body['ok'], isTrue);
        expect((body['data'] as List).length, equals(2));
      });

      test('filters artists by query', () async {
        final request = Request(
          'GET',
          Uri.parse('http://localhost/artists?q=Alice'),
        );

        final response = await handler.search(request);

        expect(response.statusCode, equals(200));
        final body = jsonDecode(await response.readAsString());
        expect(body['ok'], isTrue);
        expect((body['data'] as List).length, equals(1));
        expect(body['data'][0]['name'], equals('Alice'));
      });

      test('respects limit query param', () async {
        final request = Request(
          'GET',
          Uri.parse('http://localhost/artists?q=i&limit=1'),
        );

        final response = await handler.search(request);

        expect(response.statusCode, equals(200));
        final body = jsonDecode(await response.readAsString());
        expect((body['data'] as List).length, equals(1));
      });

      test('throws on invalid limit', () async {
        final request = Request(
          'GET',
          Uri.parse('http://localhost/artists?q=i&limit=abc'),
        );

        expect(
          () => handler.search(request),
          throwsA(isA<ValidationException>()),
        );
      });

      test('returns empty list when nothing matches', () async {
        final request = Request(
          'GET',
          Uri.parse('http://localhost/artists?q=nonexistent'),
        );

        final response = await handler.search(request);

        expect(response.statusCode, equals(200));
        final body = jsonDecode(await response.readAsString());
        expect((body['data'] as List), isEmpty);
      });
    });

    group('getById', () {
      test('returns artist when found', () async {
        final request = Request(
          'GET',
          Uri.parse('http://localhost/artists/$_artistId1'),
        );

        final response = await handler.getById(request, _artistId1);

        expect(response.statusCode, equals(200));
        final body = jsonDecode(await response.readAsString());
        expect(body['ok'], isTrue);
        expect(body['data']['name'], equals('Alice'));
      });

      test('returns 404 when not found', () async {
        const missingId = '00000000-0000-0000-0000-000000000000';
        final request = Request(
          'GET',
          Uri.parse('http://localhost/artists/$missingId'),
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
          Uri.parse('http://localhost/artists/not-a-uuid'),
        );

        expect(
          () => handler.getById(request, 'not-a-uuid'),
          throwsA(isA<FormatException>()),
        );
      });
    });

    group('create', () {
      test('returns 200 with created artist', () async {
        final request = _jsonPost('artists', {
          'name': 'Charlie',
          'sourceUrl': 'https://example.com/charlie',
          'notes': 'New artist',
        });

        final response = await handler.create(request);

        expect(response.statusCode, equals(200));
        final body = jsonDecode(await response.readAsString());
        expect(body['ok'], isTrue);
        expect(body['data']['name'], equals('Charlie'));
      });

      test('works with nullable fields as null', () async {
        final request = _jsonPost('artists', {
          'name': 'Dave',
        });

        final response = await handler.create(request);

        expect(response.statusCode, equals(200));
        final body = jsonDecode(await response.readAsString());
        expect(body['data']['name'], equals('Dave'));
      });
    });

    group('update', () {
      test('returns 200 with updated artist', () async {
        final request = _jsonPut('artists/$_artistId1', {
          'name': 'Alice Updated',
        });

        final response = await handler.update(request, _artistId1);

        expect(response.statusCode, equals(200));
        final body = jsonDecode(await response.readAsString());
        expect(body['ok'], isTrue);
        expect(body['data']['name'], equals('Alice Updated'));
      });

      test('throws when artist not found', () {
        const missingId = '00000000-0000-0000-0000-000000000000';
        final request = _jsonPut('artists/$missingId', {
          'name': 'Ghost',
        });

        expect(
          () => handler.update(request, missingId),
          throwsA(isA<NotFoundException>()),
        );
      });

      test('throws FormatException for invalid UUID', () {
        final request = _jsonPut('artists/bad-uuid', {'name': 'X'});

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
          Uri.parse('http://localhost/artists/$_artistId1'),
        );

        final response = await handler.delete(request, _artistId1);

        expect(response.statusCode, equals(200));
        final body = jsonDecode(await response.readAsString());
        expect(body['ok'], isTrue);
      });

      test('throws FormatException for invalid UUID', () {
        final request = Request(
          'DELETE',
          Uri.parse('http://localhost/artists/bad-uuid'),
        );

        expect(
          () => handler.delete(request, 'bad-uuid'),
          throwsA(isA<FormatException>()),
        );
      });
    });
  });
}
