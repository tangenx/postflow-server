import 'dart:convert';

import '../core/exceptions.dart';

class RequestValidation {
  static Map<String, dynamic> parseJsonObject(String body) {
    if (body.trim().isEmpty) {
      throw ValidationException('Request body must be a JSON object');
    }

    final Object? decoded;
    try {
      decoded = jsonDecode(body);
    } on FormatException {
      throw ValidationException('Request body must be valid JSON');
    }
    if (decoded is! Map<String, dynamic>) {
      throw ValidationException('Request body must be a JSON object');
    }

    return decoded;
  }

  static String requiredString(
    Map<String, dynamic> data,
    String key, {
    int? minLength,
    int? maxLength,
  }) {
    final value = data[key];
    if (value is! String) {
      throw ValidationException('Field "$key" must be a string');
    }

    final normalized = value.trim();
    if (normalized.isEmpty) {
      throw ValidationException('Field "$key" must not be empty');
    }
    if (minLength != null && normalized.length < minLength) {
      throw ValidationException(
        'Field "$key" must be at least $minLength characters',
      );
    }
    if (maxLength != null && normalized.length > maxLength) {
      throw ValidationException(
        'Field "$key" must be at most $maxLength characters',
      );
    }

    return normalized;
  }

  static String? optionalString(
    Map<String, dynamic> data,
    String key, {
    int? maxLength,
  }) {
    final value = data[key];
    if (value == null) {
      return null;
    }
    if (value is! String) {
      throw ValidationException('Field "$key" must be a string or null');
    }

    final normalized = value.trim();
    if (normalized.isEmpty) {
      return null;
    }
    if (maxLength != null && normalized.length > maxLength) {
      throw ValidationException(
        'Field "$key" must be at most $maxLength characters',
      );
    }

    return normalized;
  }

  static int optionalPositiveInt(
    Map<String, dynamic> query,
    String key, {
    int fallback = 10,
    int min = 1,
    int max = 1000,
  }) {
    final raw = query[key];
    if (raw == null) {
      return fallback;
    }

    final parsed = int.tryParse(raw);
    if (parsed == null) {
      throw ValidationException('Query parameter "$key" must be an integer');
    }
    if (parsed < min || parsed > max) {
      throw ValidationException(
        'Query parameter "$key" must be between $min and $max',
      );
    }

    return parsed;
  }

  static bool? optionalBool(Map<String, dynamic> query, String key) {
    final raw = query[key];
    if (raw == null) {
      return null;
    }

    final parsed = bool.tryParse(raw);
    if (parsed == null) {
      throw ValidationException('Query parameter "$key" must be a boolean');
    }

    return parsed;
  }

  // handy validators
  // TODO: optionalEmail
  // static String optionalEmail(Map<String, String> query, String key) {}

  static String requiredSocialAccountTargetType(
    Map<String, dynamic> query,
    String key,
  ) {
    // 'user', 'group', 'channel', 'chat'
    final raw = query[key];
    if (raw == null) {
      throw ValidationException('Query parameter "$key" is required');
    }

    final normalized = raw.trim().toLowerCase();
    if (!['user', 'group', 'channel', 'chat'].contains(normalized)) {
      throw ValidationException(
        'Query parameter "$key" must be one of "user", "group", "channel", "chat"',
      );
    }

    return normalized;
  }
}
