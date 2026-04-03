part of '../database.dart';

@DriftAccessor(
  tables: [Posts, PostMedia, PostArtists, PostCharacters, PostFranchises],
)
class PostsDao extends DatabaseAccessor<PostflowDatabase> with _$PostsDaoMixin {
  PostsDao(super.attachedDatabase);

  Future<Post> createPost({
    required UuidValue createdBy,
    String? internalNote,
    String? description,
  }) async {
    final post = PostsCompanion.insert(
      createdBy: createdBy,
      internalNote: Value(internalNote),
      description: Value(description),
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
        .map((id) => PostArtistsCompanion.insert(postId: postId, artistId: id))
        .toList();

    batch((b) => b.insertAll(postArtists, artists));
  }

  Future<void> attachPostCharacters({
    required UuidValue postId,
    required List<UuidValue> characterIds,
  }) async {
    final characters = characterIds
        .map(
          (id) =>
              PostCharactersCompanion.insert(postId: postId, characterId: id),
        )
        .toList();

    batch((b) => b.insertAll(postCharacters, characters));
  }

  Future<void> attachPostFranchises({
    required UuidValue postId,
    required List<UuidValue> franchiseIds,
  }) async {
    final franchises = franchiseIds
        .map(
          (id) =>
              PostFranchisesCompanion.insert(postId: postId, franchiseId: id),
        )
        .toList();

    batch((b) => b.insertAll(postFranchises, franchises));
  }

  Future<Post?> findPostById(UuidValue id, UuidValue userId) async {
    return (select(posts)
          ..where((tbl) => tbl.id.equals(id) & tbl.createdBy.equals(userId)))
        .getSingleOrNull();
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

  Future<PostWithRelations?> findPostWithRelationsById(
    UuidValue id,
    UuidValue userId,
  ) async {
    final post = await findPostById(id, userId);

    if (post == null) {
      return null;
    }

    return _loadRelations(post);
  }

  Future<List<PostWithRelations>> findPostsWithRelationsById(
    UuidValue userId, {
    int page = 1,
    int pageSize = 10,
  }) async {
    final posts = await findPostsByUserId(
      userId,
      page: page,
      pageSize: pageSize,
    );

    return Future.wait(posts.map(_loadRelations));
  }

  Future<Post> updatePost({
    required UuidValue id,
    required UuidValue userId,
    String? internalNote,
    String? description,
    PostStatus? status,
  }) async {
    final post = PostsCompanion(
      internalNote: Value.absentIfNull(internalNote),
      description: Value.absentIfNull(description),
      status: Value.absentIfNull(status),
    );

    final updated =
        await (update(
              posts,
            )..where((tbl) => tbl.id.equals(id) & tbl.createdBy.equals(userId)))
            .writeReturning(post);

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

  Future<void> detachFranchises(UuidValue postId) {
    return (delete(postFranchises)..where((f) => f.postId.equals(postId))).go();
  }

  Future<void> detachMedia(UuidValue postId) {
    return (delete(postMedia)..where((m) => m.postId.equals(postId))).go();
  }

  Future<void> detachArtistItem(UuidValue postId, UuidValue artistId) {
    return (delete(postArtists)
          ..where((a) => a.postId.equals(postId) & a.artistId.equals(artistId)))
        .go();
  }

  Future<void> detachCharacterItem(UuidValue postId, UuidValue characterId) {
    return (delete(postCharacters)..where(
          (c) => c.postId.equals(postId) & c.characterId.equals(characterId),
        ))
        .go();
  }

  Future<void> detachFranchiseItem(UuidValue postId, UuidValue franchiseId) {
    return (delete(postFranchises)..where(
          (f) => f.postId.equals(postId) & f.franchiseId.equals(franchiseId),
        ))
        .go();
  }

  Future<void> detachMediaItem(UuidValue postId, UuidValue mediaId) {
    return (delete(postMedia)..where(
          (m) => m.postId.equals(postId) & m.mediaFileId.equals(mediaId),
        ))
        .go();
  }

  Future<void> deletePost(UuidValue postId, UuidValue userId) {
    return (delete(
      posts,
    )..where((p) => p.id.equals(postId) & p.createdBy.equals(userId))).go();
  }

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

    final franchisesFromPost =
        await (select(postFranchises)
              ..where((tbl) => tbl.postId.equals(post.id)))
            .join([
              innerJoin(
                franchises,
                franchises.id.equalsExp(postFranchises.franchiseId),
              ),
            ])
            .map((row) => row.readTable(franchises))
            .get();

    return PostWithRelations(
      post: post,
      media: media,
      artists: artistsFromPost,
      characters: charactersFromPost,
      franchises: franchisesFromPost,
    );
  }
}

class PostWithRelations {
  final Post post;
  final List<MediaFile> media;
  final List<Artist> artists;
  final List<Character> characters;
  final List<Franchise> franchises;

  const PostWithRelations({
    required this.post,
    required this.media,
    required this.artists,
    required this.characters,
    required this.franchises,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': post.id.toString(),
      'internal_note': post.internalNote,
      'description': post.description,
      'status': post.status.name,
      'created_at': post.createdAt.dateTime.toIso8601String(),
      'updated_at': post.updatedAt.dateTime.toIso8601String(),
      'media': media.map((m) => m.toJson()).toList(),
      'artists': artists.map((a) => a.toJson()).toList(),
      'characters': characters.map((c) => c.toJson()).toList(),
      'franchises': franchises.map((f) => f.toJson()).toList(),
    };
  }
}
