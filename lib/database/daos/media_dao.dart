part of '../database.dart';

@DriftAccessor(tables: [MediaTypes, MediaFiles])
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
