import 'package:drift_postgres/drift_postgres.dart';

import '../core/exceptions.dart';
import '../database/database.dart';
import '../database/tables/posts.dart';

class PostsService {
  final PostsDao _postsDao;
  final ArtistsDao _artistsDao;
  final CharactersDao _charactersDao;
  final FranchisesDao _franchisesDao;
  final PostflowDatabase _db;

  PostsService({
    required PostsDao postsDao,
    required ArtistsDao artistsDao,
    required CharactersDao charactersDao,
    required FranchisesDao franchisesDao,
    required PostflowDatabase db,
  }) : _postsDao = postsDao,
       _artistsDao = artistsDao,
       _charactersDao = charactersDao,
       _franchisesDao = franchisesDao,
       _db = db;

  Future<PostWithRelations> createPost({
    required UuidValue userId,
    required CreatePostRequest request,
  }) async {
    return _db.transaction(() async {
      final post = await _postsDao.createPost(
        createdBy: userId,
        internalNote: request.internalNote,
        description: request.description,
      );

      final characterRefs = await _resolveCharacters(request.characters);
      final artistRefs = await _resolveArtists(request.artists);
      final franchiseRefs = await _resolveFranchises(request.franchises);

      await _postsDao.attachPostMedia(postId: post.id, mediaIds: request.media);
      await _postsDao.attachPostArtists(postId: post.id, artistIds: artistRefs);
      await _postsDao.attachPostCharacters(
        postId: post.id,
        characterIds: characterRefs,
      );
      await _postsDao.attachPostFranchises(
        postId: post.id,
        franchiseIds: franchiseRefs,
      );

      return (await _postsDao.findPostWithRelationsById(post.id, userId))!;
    });
  }

  Future<PostWithRelations> updatePost({
    required UuidValue postId,
    required UuidValue userId,
    required UpdatePostRequest request,
  }) async {
    return _db.transaction(() async {
      await _postsDao.updatePost(
        id: postId,
        userId: userId,
        internalNote: request.internalNote,
        description: request.description,
        status: request.status,
      );

      if (request.mediaIds != null) {
        await _postsDao.detachMedia(postId);
        await _postsDao.attachPostMedia(
          postId: postId,
          mediaIds: request.mediaIds!,
        );
      }

      if (request.artists != null) {
        await _postsDao.detachArtists(postId);
        final artistRefs = await _resolveArtists(request.artists!);
        await _postsDao.attachPostArtists(
          postId: postId,
          artistIds: artistRefs,
        );
      }

      if (request.characters != null) {
        await _postsDao.detachCharacters(postId);
        final characterRefs = await _resolveCharacters(request.characters!);
        await _postsDao.attachPostCharacters(
          postId: postId,
          characterIds: characterRefs,
        );
      }

      if (request.franchises != null) {
        await _postsDao.detachFranchises(postId);
        final franchiseRefs = await _resolveFranchises(request.franchises!);
        await _postsDao.attachPostFranchises(
          postId: postId,
          franchiseIds: franchiseRefs,
        );
      }

      return (await _postsDao.findPostWithRelationsById(postId, userId))!;
    });
  }

  Future<(List<PostWithRelations>, int)> getPostsByUserId(
    UuidValue userId, {
    int page = 1,
    int pageSize = 10,
  }) async {
    final posts = await _postsDao.findPostsWithRelationsById(
      userId,
      page: page,
      pageSize: pageSize,
    );
    final count = await _postsDao.countPostsByUserId(userId);

    return (posts, count);
  }

  Future<PostWithRelations> getPost(UuidValue postId, UuidValue userId) async {
    final post = await _postsDao.findPostWithRelationsById(postId, userId);

    if (post == null) {
      throw NotFoundException('Post not found');
    }

    return post;
  }

  Future<void> deletePost(UuidValue postId, UuidValue userId) async {
    await _postsDao.deletePost(postId, userId);
  }

  Future<List<UuidValue>> _resolveArtists(List<ArtistRef> refs) async {
    final ids = List<UuidValue>.empty(growable: true);

    for (final ref in refs) {
      if (ref.id != null) {
        ids.add(ref.id!);
      } else {
        final artist = await _artistsDao.create(
          name: ref.name!,
          sourceUrl: ref.sourceUrl,
        );

        ids.add(artist.id);
      }
    }

    return ids;
  }

  Future<List<UuidValue>> _resolveCharacters(List<CharacterRef> refs) async {
    final ids = List<UuidValue>.empty(growable: true);

    for (final ref in refs) {
      if (ref.id != null) {
        ids.add(ref.id!);
      } else {
        final character = await _charactersDao.create(
          name: ref.name!,
          franchiseId: ref.franchiseId,
        );
        ids.add(character.id);
      }
    }

    return ids;
  }

  Future<List<UuidValue>> _resolveFranchises(List<FranchiseRef> refs) async {
    final ids = List<UuidValue>.empty(growable: true);

    for (final ref in refs) {
      if (ref.id != null) {
        ids.add(ref.id!);
      } else {
        final franchise = await _franchisesDao.create(
          name: ref.name!,
          description: ref.description,
        );
        ids.add(franchise.id);
      }
    }

    return ids;
  }
}

class CreatePostRequest {
  final String? internalNote;
  final String? description;
  final List<UuidValue> media;
  final List<ArtistRef> artists;
  final List<CharacterRef> characters;
  final List<FranchiseRef> franchises;

  const CreatePostRequest({
    this.internalNote,
    this.description,
    required this.media,
    required this.artists,
    required this.characters,
    required this.franchises,
  });

  factory CreatePostRequest.fromJson(Map<String, dynamic> json) {
    return CreatePostRequest(
      internalNote: json['internal_note'] as String?,
      description: json['description'] as String?,
      media: (json['media'] as List<dynamic>)
          .map((m) => UuidValue.withValidation(m as String))
          .toList(),
      artists: (json['artists'] as List<dynamic>)
          .map((a) => ArtistRef.fromJson(a as Map<String, dynamic>))
          .toList(),
      characters: (json['characters'] as List<dynamic>)
          .map((c) => CharacterRef.fromJson(c as Map<String, dynamic>))
          .toList(),
      franchises: (json['franchises'] as List<dynamic>)
          .map((f) => FranchiseRef.fromJson(f as Map<String, dynamic>))
          .toList(),
    );
  }
}

class UpdatePostRequest {
  final String? internalNote;
  final String? description;
  final PostStatus? status;
  final List<UuidValue>? mediaIds;
  final List<ArtistRef>? artists;
  final List<CharacterRef>? characters;
  final List<FranchiseRef>? franchises;

  const UpdatePostRequest({
    this.internalNote,
    this.description,
    this.status,
    this.mediaIds,
    this.artists,
    this.characters,
    this.franchises,
  });

  factory UpdatePostRequest.fromJson(Map<String, dynamic> json) {
    return UpdatePostRequest(
      internalNote: json['internal_note'] as String?,
      description: json['description'] as String?,
      status: json['status'] != null
          ? PostStatus.values.byName(json['status'] as String)
          : null,
      mediaIds: json['media_ids'] != null
          ? (json['media_ids'] as List)
                .map((id) => UuidValue.withValidation(id as String))
                .toList()
          : null,
      artists: json['artists'] != null
          ? (json['artists'] as List)
                .map((a) => ArtistRef.fromJson(a as Map<String, dynamic>))
                .toList()
          : null,
      characters: json['characters'] != null
          ? (json['characters'] as List)
                .map((c) => CharacterRef.fromJson(c as Map<String, dynamic>))
                .toList()
          : null,
      franchises: json['franchises'] != null
          ? (json['franchises'] as List)
                .map((f) => FranchiseRef.fromJson(f as Map<String, dynamic>))
                .toList()
          : null,
    );
  }
}

class ArtistRef {
  final UuidValue? id; // if exists
  final String? name; // if new
  final String? sourceUrl; // if new

  const ArtistRef({this.id, this.name, this.sourceUrl});

  factory ArtistRef.fromJson(Map<String, dynamic> json) {
    return ArtistRef(
      id: json['id'] != null
          ? UuidValue.withValidation(json['id'] as String)
          : null,
      name: json['name'] as String?,
      sourceUrl: json['source_url'] as String?,
    );
  }
}

class CharacterRef {
  final UuidValue? id; // if exists
  final String? name; // if new
  final UuidValue? franchiseId; // optional if new (character can be original)

  const CharacterRef({this.id, this.name, this.franchiseId});

  factory CharacterRef.fromJson(Map<String, dynamic> json) {
    return CharacterRef(
      id: json['id'] != null
          ? UuidValue.withValidation(json['id'] as String)
          : null,
      name: json['name'] as String?,
      franchiseId: json['franchise_id'] != null
          ? UuidValue.withValidation(json['franchise_id'] as String)
          : null,
    );
  }
}

class FranchiseRef {
  final UuidValue? id; // if exists
  final String? name; // if new
  final String? description; // if new

  const FranchiseRef({this.id, this.name, this.description});

  factory FranchiseRef.fromJson(Map<String, dynamic> json) {
    return FranchiseRef(
      id: json['id'] != null
          ? UuidValue.withValidation(json['id'] as String)
          : null,
      name: json['name'] as String?,
      description: json['description'] as String?,
    );
  }
}
