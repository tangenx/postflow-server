import 'package:drift/drift.dart';
import 'package:postgres/postgres.dart';

/// the custom drift type for postgres enum columns
///
/// maps a dart's [Enum] to a postgres enum type, ensuring values are
/// properly cast so that postgres doesn't reject them as a `text`
class PgEnumType<T extends Enum> implements CustomSqlType<T> {
  /// postgres type name (e.g. `'identity_provider'`)
  final String pgTypeName;

  /// all values of the dart enum, used for deserialization
  final List<T> values;

  const PgEnumType({required this.pgTypeName, required this.values});

  @override
  String mapToSqlLiteral(T dartValue) {
    return "'${dartValue.name}'::$pgTypeName";
  }

  @override
  Object mapToSqlParameter(T dartValue) {
    // type.unspecified lets PostgreSQL infer the enum type from context

    // that was smart acutally
    return TypedValue(Type.unspecified, dartValue.name);
  }

  @override
  T read(Object fromSql) {
    final name = fromSql as String;
    return values.byName(name);
  }

  @override
  String sqlTypeName(GenerationContext context) => pgTypeName;
}
