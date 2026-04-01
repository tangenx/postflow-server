part of '../database.dart';

@DriftAccessor(tables: [Posts, PostMedia, PostArtists, PostCharacters])
class PostsDao extends DatabaseAccessor<PostflowDatabase> with _$PostsDaoMixin {
  PostsDao(super.attachedDatabase);

  Future<Post> createPost({
    required UuidValue createdBy,
    String? internalNote,
    String? description,
  }) async {
    final post = PostsCompanion.insert(
      createdBy: createdBy,
      internalNote: Value.absentIfNull(internalNote),
      description: Value.absentIfNull(description),
    );

    return into(posts).insertReturning(post);
  }

  Future<void> attachPostMedia({
    required UuidValue postId,
    required List<UuidValue> mediaIds,
  }) async {
    final media = mediaIds
        .mapIndexed(
          (index, id) => PostMediaCompanion.insert(
            postId: postId,
            mediaFileId: id,
            sortOrder: Value(index),
          ),
        )
        .toList();

    batch((b) => b.insertAll(postMedia, media));
  }

  Future<void> attachPostArtists({
    required UuidValue postId,
    required List<UuidValue> artistIds,
  }) async {
    final artists = artistIds
        .mapIndexed(
          (index, id) =>
              PostArtistsCompanion.insert(postId: postId, artistId: id),
        )
        .toList();

    batch((b) => b.insertAll(postArtists, artists));
  }

  Future<void> attachPostCharacters({
    required UuidValue postId,
    required List<PostCharacterRef> refs,
  }) async {
    final characters = refs
        .mapIndexed(
          (index, ref) => PostCharactersCompanion.insert(
            postId: postId,
            characterId: ref.characterId,
            contextFranchiseId: Value.absentIfNull(ref.contextFranchiseId),
          ),
        )
        .toList();

    batch((b) => b.insertAll(postCharacters, characters));
  }

  Future<Post?> findPostById(UuidValue id) async {
    return (select(posts)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  Future<List<Post>> findPostsByUserId(
    UuidValue userId, {
    int page = 1,
    int pageSize = 10,
  }) async {
    final query = select(posts)
      ..where((tbl) => tbl.createdBy.equals(userId))
      ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
      ..limit(pageSize, offset: pageSize * (page - 1));

    return query.get();
  }

  Future<int> countPostsByUserId(UuidValue userId) async {
    final count = countAll();

    final query = selectOnly(posts)
      ..addColumns([count])
      ..where(posts.createdBy.equals(userId));

    final row = await query.getSingle();

    return row.read(count)!;
  }

  Future<PostWithRelations?> findPostWithRelationsById(UuidValue id) async {
    final post = await findPostById(id);

    if (post == null) {
      return null;
    }

    return _loadRelations(post);
  }

  Future<Post> updatePost({
    required UuidValue id,
    String? internalNote,
    String? description,
    PostStatus? status,
  }) async {
    final post = PostsCompanion(
      internalNote: Value.absentIfNull(internalNote),
      description: Value.absentIfNull(description),
      status: Value.absentIfNull(status),
    );

    final updated = await (update(
      posts,
    )..where((tbl) => tbl.id.equals(id))).writeReturning(post);

    if (updated.isEmpty) {
      throw NotFoundException('Post not found');
    }

    return updated.single;
  }

  Future<void> detachArtists(UuidValue postId) {
    return (delete(postArtists)..where((a) => a.postId.equals(postId))).go();
  }

  Future<void> detachCharacters(UuidValue postId) {
    return (delete(postCharacters)..where((c) => c.postId.equals(postId))).go();
  }

  Future<void> detachMedia(UuidValue postId) {
    return (delete(postMedia)..where((m) => m.postId.equals(postId))).go();
  }

  Future<void> detachArtistItem(UuidValue postId, UuidValue artistId) {
    return (delete(postArtists)
          ..where((a) => a.postId.equals(postId) & a.artistId.equals(artistId)))
        .go();
  }

  Future<void> detachCharacterItem(UuidValue postId, UuidValue characterId) =>
      (delete(postCharacters)..where(
            (c) => c.postId.equals(postId) & c.characterId.equals(characterId),
          ))
          .go();

  Future<void> detachMediaItem(UuidValue postId, UuidValue mediaId) =>
      (delete(postMedia)..where(
            (m) => m.postId.equals(postId) & m.mediaFileId.equals(mediaId),
          ))
          .go();

  Future<void> deletePost(UuidValue postId) =>
      (delete(posts)..where((p) => p.id.equals(postId))).go();

  Future<PostWithRelations> _loadRelations(Post post) async {
    final media =
        await (select(postMedia)
              ..where((tbl) => tbl.postId.equals(post.id))
              ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
            .join([
              innerJoin(
                mediaFiles,
                mediaFiles.id.equalsExp(postMedia.mediaFileId),
              ),
            ])
            .map((row) => row.readTable(mediaFiles))
            .get();

    final artistsFromPost =
        await (select(postArtists)..where((tbl) => tbl.postId.equals(post.id)))
            .join([
              innerJoin(artists, artists.id.equalsExp(postArtists.artistId)),
            ])
            .map((row) => row.readTable(artists))
            .get();

    final charactersFromPost =
        await (select(postCharacters)
              ..where((tbl) => tbl.postId.equals(post.id)))
            .join([
              innerJoin(
                characters,
                characters.id.equalsExp(postCharacters.characterId),
              ),
            ])
            .map((row) => row.readTable(characters))
            .get();

    return PostWithRelations(
      post: post,
      media: media,
      artists: artistsFromPost,
      characters: charactersFromPost,
    );
  }
}

class PostWithRelations {
  final Post post;
  final List<MediaFile> media;
  final List<Artist> artists;
  final List<Character> characters;

  const PostWithRelations({
    required this.post,
    required this.media,
    required this.artists,
    required this.characters,
  });
}

class PostCharacterRef {
  final UuidValue characterId;
  final UuidValue? contextFranchiseId;

  const PostCharacterRef({required this.characterId, this.contextFranchiseId});
}
