part of '../database.dart';

@DriftAccessor(tables: [MediaTypes, MediaFiles, PostMedia])
class MediaDao extends DatabaseAccessor<PostflowDatabase> with _$MediaDaoMixin {
  MediaDao(super.attachedDatabase);

  Future<MediaType?> findTypeByContentType(String contentType) async {
    return (select(mediaTypes)..where(
          (t) => CustomExpression('mime_types @> ARRAY[$contentType::text]'),
        ))
        .getSingleOrNull();
  }

  Future<MediaType?> findTypeById(UuidValue id) async {
    return (select(
      mediaTypes,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  /// get all media files attached to a post with their types
  /// used for scheduler
  Future<List<MediaFileWithMediaType>> findByPostIdWithType(
    UuidValue postId,
  ) async {
    final query =
        await (select(postMedia).join([
                innerJoin(
                  mediaFiles,
                  mediaFiles.id.equalsExp(postMedia.mediaFileId),
                ),
                innerJoin(
                  mediaTypes,
                  mediaTypes.id.equalsExp(mediaFiles.mediaTypeId),
                ),
              ])
              ..where(postMedia.postId.equals(postId))
              ..orderBy([OrderingTerm.desc(postMedia.sortOrder)]))
            .get();

    return query
        .map(
          (row) => MediaFileWithMediaType(
            mediaFile: row.readTable(mediaFiles),
            mediaType: row.readTable(mediaTypes),
          ),
        )
        .toList();
  }

  Future<List<MediaFile>> findOrphaned(Duration ttl) async {
    final cutoff = DateTime.now().subtract(ttl);
    return (select(mediaFiles)..where(
          (tbl) =>
              tbl.uploadedAt.isSmallerThanValue(PgDateTime(cutoff)) &
              notExistsQuery(
                select(postMedia)
                  ..where((pm) => pm.mediaFileId.equalsExp(tbl.id)),
              ),
        ))
        .get();
  }

  Future<MediaFile> createFile({
    required UuidValue userId,
    required UuidValue mediaTypeId,
    required StorageType storageType,
    String? storagePath,
    String? sourceUrl,
    String? originalFilename,
    int? fileSizeBytes,
  }) async {
    final mediaFile = MediaFilesCompanion.insert(
      uploadedBy: userId,
      mediaTypeId: mediaTypeId,
      storageType: Value(storageType),
      storagePath: Value(storagePath),
      sourceUrl: Value(sourceUrl),
      originalFilename: Value(originalFilename),
      fileSizeBytes: fileSizeBytes != null
          ? Value(BigInt.from(fileSizeBytes))
          : Value.absent(),
    );

    return into(mediaFiles).insertReturning(mediaFile);
  }

  Future<MediaFile?> getById(UuidValue id) {
    return (select(
      mediaFiles,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<MediaFile?> getByStoragePath(String storagePath) {
    return (select(
      mediaFiles,
    )..where((t) => t.storagePath.equals(storagePath))).getSingleOrNull();
  }

  Future<int> deleteFile(UuidValue id) {
    return (delete(mediaFiles)..where((t) => t.id.equals(id))).go();
  }
}

class MediaFileWithMediaType {
  final MediaFile mediaFile;
  final MediaType mediaType;

  const MediaFileWithMediaType({
    required this.mediaFile,
    required this.mediaType,
  });

  factory MediaFileWithMediaType.fromJson(Map<String, dynamic> json) {
    return MediaFileWithMediaType(
      mediaFile: MediaFile.fromJson(json['mediaFile'] as Map<String, dynamic>),
      mediaType: MediaType.fromJson(json['mediaType'] as Map<String, dynamic>),
    );
  }
}
