import 'json_parsing.dart';

enum ReassuranceState { reassuring, needsAttention, notEnoughInformation }

class DailySummary {
  const DailySummary({
    required this.residentId,
    required this.localDate,
    required this.reassuranceState,
    required this.generatedAt,
    required this.headline,
    required this.highlights,
  });

  factory DailySummary.fromJson(JsonMap json) {
    final state = switch (requireString(json, 'reassuranceState')) {
      'reassuring' => ReassuranceState.reassuring,
      'needs_attention' => ReassuranceState.needsAttention,
      'not_enough_information' => ReassuranceState.notEnoughInformation,
      final other => throw FormatException(
        'Invalid reassurance state: $other.',
      ),
    };

    final rawHighlights = json['highlights'];
    if (rawHighlights is! List) {
      throw const FormatException('Expected a list for highlights.');
    }
    final highlights = rawHighlights
        .whereType<String>()
        .toList(growable: false);

    return DailySummary(
      residentId: requireString(json, 'residentId'),
      localDate: requireString(json, 'localDate'),
      reassuranceState: state,
      generatedAt: requireDateTime(json, 'generatedAt'),
      headline: requireString(json, 'headline'),
      highlights: List<String>.unmodifiable(highlights),
    );
  }

  final String residentId;
  final String localDate;
  final ReassuranceState reassuranceState;
  final DateTime generatedAt;
  final String headline;
  final List<String> highlights;
}
