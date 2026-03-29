import 'dart:convert';

import 'package:postgres/postgres.dart' as pg;

/// because postgres is a great library that
/// [connot decode enums properly since 2024](https://github.com/isoos/postgresql-dart/issues/276)
/// we need use a custom codec to decode enums
///
/// BUT we steel need to find OID of enums we using...
class EnumTextCodec extends pg.Codec {
  @override
  pg.EncodedValue? encode(pg.TypedValue input, pg.CodecContext context) {
    final value = input.value;
    if (value == null) {
      return pg.EncodedValue.null$(typeOid: input.type.oid);
    }

    final stringValue = value.toString();
    final bytes = utf8.encode(stringValue);

    return pg.EncodedValue(
      bytes,
      typeOid: input.type.oid,
      format: pg.EncodingFormat.text,
    );
  }

  @override
  Object? decode(pg.EncodedValue input, pg.CodecContext context) {
    final bytes = input.bytes;
    if (bytes == null) {
      return null;
    }

    return utf8.decode(bytes);
  }
}
