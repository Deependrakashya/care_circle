import 'json_parsing.dart';

/// Record-level visibility, separate from category sharing preferences.
enum Visibility {
  /// Eligible for the family experience.
  family,

  /// Eligible only when the resident's category preference allows it.
  limited,

  /// Must not be exposed to a family user.
  residentOnly,
}

Visibility parseVisibility(JsonMap json, String field) {
  final value = requireString(json, field);
  return switch (value) {
    'family' => Visibility.family,
    'limited' => Visibility.limited,
    'resident_only' => Visibility.residentOnly,
    _ => throw FormatException('Invalid visibility value for $field: $value.'),
  };
}
