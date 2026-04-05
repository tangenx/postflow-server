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
        variables: Value(_parseVariables(body).map((e) => e.toJson()).toList()),
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

  Future<void> deleteTemplate(UuidValue id, UuidValue ownerId) {
    return (delete(
      captionTemplates,
    )..where((tbl) => tbl.id.equals(id) & tbl.ownerId.equals(ownerId))).go();
  }

  /// parse variables from a template body
  ///
  /// formats:
  ///   {{variable}} —> { name: 'variable', hastag: false }
  ///   {{#variable}} —> { name: 'variable', hastag: true }
  ///   {{source_url:link}} —> { name: 'source_url', hastag: false, display: 'link' }
  ///   {{#source_url:link:display}} —> { name: 'source_url', hastag: true, display: 'link' }
  List<TemplateVariable> _parseVariables(String body) {
    final pattern = RegExp(r'\{\{(\#?)(\w+)(?::([^}]+))?\}\}');

    return pattern
        .allMatches(body)
        .map(
          (m) => TemplateVariable(
            name: m.group(2)!,
            display: m.group(4),
            asHashtag: m.group(1) == '#',
          ),
        )
        .toList();
  }
}

class TemplateVariable {
  final String name;
  final String? display;
  final bool asHashtag;

  TemplateVariable({required this.name, this.display, required this.asHashtag});

  Map<String, dynamic> toJson() => {
    'name': name,
    'display': display,
    'asHashtag': asHashtag,
  };

  factory TemplateVariable.fromJson(Map<String, dynamic> json) =>
      TemplateVariable(
        name: json['name'] as String,
        display: json['display'] as String?,
        asHashtag: json['asHashtag'] as bool,
      );
}
