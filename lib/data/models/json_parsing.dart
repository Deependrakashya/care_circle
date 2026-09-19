typedef JsonMap = Map<String, dynamic>;

JsonMap requireObject(Object? value, String field) {
  if (value is! JsonMap) {
    throw FormatException('Expected an object for $field.');
  }
  return value;
}

String requireString(JsonMap json, String field) {
  final value = json[field];
  if (value is! String || value.trim().isEmpty) {
    throw FormatException('Expected a nonempty string for $field.');
  }
  return value;
}

bool requireBool(JsonMap json, String field) {
  final value = json[field];
  if (value is! bool) {
    throw FormatException('Expected a boolean for $field.');
  }
  return value;
}

String? optionalString(JsonMap json, String field) {
  final value = json[field];
  if (value == null) return null;
  if (value is! String) {
    throw FormatException('Expected a string or null for $field.');
  }
  return value;
}

int? optionalInt(JsonMap json, String field) {
  final value = json[field];
  if (value == null) return null;
  if (value is! int) {
    throw FormatException('Expected an integer or null for $field.');
  }
  return value;
}

DateTime requireDateTime(JsonMap json, String field) {
  final raw = requireString(json, field);
  final parsed = DateTime.tryParse(raw);
  if (parsed == null) {
    throw FormatException('Invalid date/time for $field.');
  }
  return parsed;
}

DateTime? optionalDateTime(JsonMap json, String field) {
  final raw = optionalString(json, field);
  if (raw == null) return null;
  final parsed = DateTime.tryParse(raw);
  if (parsed == null) {
    throw FormatException('Invalid date/time for $field.');
  }
  return parsed;
}

/// Requires the JSON value to be a number or string, returning it as a String.
/// Useful for fields like vital values that may be numeric or string.
String requireValueAsString(JsonMap json, String field) {
  final value = json[field];
  if (value is String && value.trim().isNotEmpty) return value;
  if (value is num) return value.toString();
  throw FormatException('Expected a nonempty string or number for $field.');
}
