import 'package:drift_postgres/drift_postgres.dart';

import '../database/database.dart';

class CaptionService {
  static const systemVariables = [
    'character',
    'artist',
    'franchise',
    'fandom',
    'description',
    'source_url',
    'account_shortlink',
    'target_label',
    'date',
    'date_short',
    'media_count',
  ];

  /// Renders a caption template with the given variables.
  ///
  /// Template syntax:
  /// - `{{variable}}` → plain value (empty string if missing)
  /// - `{{#variable}}` → `#hashtagified_value` (empty string if missing)
  ///
  /// After all replacements, dangling prepositions are cleaned up:
  /// - `from by` → `by` (franchise missing between from and by)
  /// - leading `from ` → removed
  /// - trailing ` from` / ` by` → removed
  String render({
    required String templateBody,
    required Map<String, String> variables,
  }) {
    var result = templateBody;

    for (final entry in variables.entries) {
      final pattern = '{{#${entry.key}}}';
      if (!result.contains(pattern)) continue;

      final value = entry.value.trim();
      result = result.replaceAll(
        pattern,
        value.isEmpty ? '' : _toHashtag(value),
      );
    }

    for (final entry in variables.entries) {
      final pattern = '{{${entry.key}}}';
      if (!result.contains(pattern)) continue;

      result = result.replaceAll(pattern, entry.value.trim());
    }

    return _postProcess(result);
  }

  /// Builds system variables from post data and target.
  ///
  /// Custom variables from the template (JSONB) should be merged on top
  /// using [renderWithCustomVariables] or manually.
  Map<String, String> buildVariables({
    required PostWithRelations post,
    required SocialAccountTarget target,
  }) {
    final franchiseNames = post.franchises.map((f) => f.name).join(', ');
    final sourceUrl = post.media
        .map((m) => m.sourceUrl)
        .where((url) => url != null && url.isNotEmpty)
        .firstOrNull;

    return {
      'character': post.characters.map((c) => c.name).join(', '),
      'artist': post.artists.map((a) => a.name).join(', '),
      'franchise': franchiseNames,
      'fandom': franchiseNames,
      'description': post.post.description ?? '',
      'source_url': sourceUrl ?? '',
      'account_shortlink': target.shortLink ?? '',
      'target_label': target.targetLabel ?? '',
      'date': _formatDate(post.post.createdAt),
      'date_short': _formatDateShort(post.post.createdAt),
      'media_count': post.media.length.toString(),
    };
  }

  /// Convenience: builds system vars, merges custom vars from template,
  /// and renders in one call.
  ///
  /// Custom variables override system ones on key collision.
  String renderWithCustomVariables({
    required String templateBody,
    required PostWithRelations post,
    required SocialAccountTarget target,
    required Map<String, Object> customVariables,
  }) {
    final system = buildVariables(post: post, target: target);
    final merged = {
      ...system,
      for (final e in customVariables.entries) e.key: e.value.toString(),
    };

    return render(templateBody: templateBody, variables: merged);
  }

  String _toHashtag(String text) {
    final lower = text.toLowerCase();
    final cleaned = lower.replaceAll(RegExp(r'[^\w]+', dotAll: true), '_');
    return '#$cleaned';
  }

  String _formatDate(PgDateTime dt) {
    final d = dt.toDateTime().toUtc();
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }

  String _formatDateShort(PgDateTime dt) {
    final d = dt.toDateTime().toUtc();
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[d.month - 1]} ${d.day}';
  }

  String _postProcess(String text) {
    var result = text.replaceAll(RegExp(r'\s+'), ' ').trim();

    result = result.replaceAllMapped(
      RegExp(r'\bfrom\s+by\b', caseSensitive: false),
      (_) => 'by',
    );
    result = result.replaceAllMapped(
      RegExp(r'^from\s+', caseSensitive: false),
      (_) => '',
    );
    result = result.replaceAllMapped(
      RegExp(r'\s+from\s*$', caseSensitive: false),
      (_) => '',
    );
    result = result.replaceAllMapped(
      RegExp(r'\s+by\s*$', caseSensitive: false),
      (_) => '',
    );

    return result.trim();
  }
}
