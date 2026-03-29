import 'package:drift/drift.dart';
import 'package:drift_postgres/drift_postgres.dart';

import '../types/pg_enum_type.dart';
import 'media_types.dart';
import 'users.dart';

enum StorageType { local, remote }

const storageTypeType = PgEnumType<StorageType>(
  pgTypeName: 'storage_type',
  values: StorageType.values,
);

class MediaFiles extends Table {
  UuidColumn get id => customType(PgTypes.uuid).withDefault(genRandomUuid())();
  UuidColumn get uploadedBy =>
      customType(PgTypes.uuid).references(Users, #id)();
  UuidColumn get mediaTypeId =>
      customType(PgTypes.uuid).references(MediaTypes, #id)();
  Column<StorageType> get storageType => customType(
    storageTypeType,
  ).withDefault(Constant(StorageType.local, storageTypeType))();
  TextColumn get storagePath => text().nullable()();
  TextColumn get sourceUrl => text().nullable()();
  TextColumn get originalFilename => text().nullable()();
  Int64Column get fileSizeBytes => int64().nullable()();
  JsonColumn get metadata => customType(
    PgTypes.jsonb,
  ).withDefault(const Constant('{}', PgTypes.jsonb))();
  Column<PgDateTime> get uploadedAt =>
      customType(PgTypes.timestampWithTimezone).withDefault(now())();

  @override
  Set<Column<Object>>? get primaryKey => {id};
}
