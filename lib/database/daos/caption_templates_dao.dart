part of '../database.dart';

@DriftAccessor(tables: [CaptionTemplates])
class CaptionTemplatesDao extends DatabaseAccessor<PostflowDatabase>
    with _$CaptionTemplatesDaoMixin {
  CaptionTemplatesDao(super.attachedDatabase);

  Future<CaptionTemplate> create({
    required UuidValue ownerId,
    required String name,
    required String body,
  }) {
    return into(captionTemplates).insertReturning(
      CaptionTemplatesCompanion.insert(
        ownerId: Value(ownerId),
        name: name,
        body: body,
        variables: Value(_parseVariables(body)),
      ),
    );
  }

  /// Finds all templates for a given user + global templates
  Future<List<CaptionTemplate>> findForUser(UuidValue userId) {
    return (select(captionTemplates)
          ..where(
            (tbl) => tbl.ownerId.equals(userId) | tbl.isGlobal.equals(true),
          )
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.name)]))
        .get();
  }

  Future<CaptionTemplate?> findById(UuidValue id) {
    return (select(
      captionTemplates,
    )..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  Future<CaptionTemplate> updateTemplate({
    required UuidValue id,
    required UuidValue ownerId,
    String? name,
    String? body,
  }) async {
    final updated =
        await (update(captionTemplates)
              ..where((tbl) => tbl.id.equals(id) & tbl.ownerId.equals(ownerId)))
            .writeReturning(
              CaptionTemplatesCompanion(
                name: Value.absentIfNull(name),
                body: Value.absentIfNull(body),
                variables: body != null
                    ? Value(_parseVariables(body))
                    : Value.absent(),
              ),
            );

    if (updated.isEmpty) {
      throw NotFoundException('Template not found');
    }

    return updated.single;
  }

  Future<void> deleteTemplate(UuidValue id) {
    return (delete(captionTemplates)..where((tbl) => tbl.id.equals(id))).go();
  }

  // parse variables from a template body - e.g. #{{character}} from #{{fandom}} by #{{artist}}
  List<String> _parseVariables(String body) {
    final matches = RegExp(r'\{\{(\w+)\}\}').allMatches(body);
    return matches.map((m) => m.group(1)!).toSet().toList();
  }
}
