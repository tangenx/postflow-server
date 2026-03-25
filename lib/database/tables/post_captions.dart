import 'package:drift/drift.dart';
import 'package:drift_postgres/drift_postgres.dart';

import 'caption_templates.dart';
import 'post_schedules.dart';

class PostCaptions extends Table {
  UuidColumn get id => customType(PgTypes.uuid).withDefault(genRandomUuid())();
  UuidColumn get postScheduleId =>
      customType(PgTypes.uuid).references(PostSchedules, #id)();
  UuidColumn get templateId =>
      customType(PgTypes.uuid).nullable().references(CaptionTemplates, #id)();
  TextColumn get renderedBody => text()();
  JsonColumn get variableOverrides => customType(
    PgTypes.jsonb,
  ).withDefault(const Constant('{}', PgTypes.jsonb))();

  @override
  Set<Column<Object>>? get primaryKey => {id};

  @override
  List<Set<Column<Object>>>? get uniqueKeys => [
    {postScheduleId},
  ];
}
