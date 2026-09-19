import 'json_parsing.dart';

class ApiEnvelope<T> {
  const ApiEnvelope({required this.data, required this.generatedAt});

  factory ApiEnvelope.fromJson(
    JsonMap json,
    T Function(Object? value) parseData,
  ) {
    final generatedAt = DateTime.tryParse(requireString(json, 'generatedAt'));
    if (generatedAt == null) {
      throw const FormatException('Invalid response generation timestamp.');
    }
    return ApiEnvelope(data: parseData(json['data']), generatedAt: generatedAt);
  }

  final T data;

  /// Response time only. This is never evidence of a care record's freshness.
  final DateTime generatedAt;
}
