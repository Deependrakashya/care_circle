import 'json_parsing.dart';
import 'visibility.dart';

enum VitalType { bloodPressure, heartRate, bloodGlucose }

class VitalReading {
  const VitalReading({
    required this.id,
    required this.residentId,
    required this.type,
    required this.value,
    required this.unit,
    required this.measuredAt,
    required this.visibility,
    this.referenceLabel,
  });

  factory VitalReading.fromJson(JsonMap json) {
    final type = switch (requireString(json, 'type')) {
      'blood_pressure' => VitalType.bloodPressure,
      'heart_rate' => VitalType.heartRate,
      'blood_glucose' => VitalType.bloodGlucose,
      final other => throw FormatException('Invalid vital type: $other.'),
    };

    return VitalReading(
      id: requireString(json, 'id'),
      residentId: requireString(json, 'residentId'),
      type: type,
      value: requireValueAsString(json, 'value'),
      unit: requireString(json, 'unit'),
      measuredAt: requireDateTime(json, 'measuredAt'),
      referenceLabel: optionalString(json, 'referenceLabel'),
      visibility: parseVisibility(json, 'visibility'),
    );
  }

  final String id;
  final String residentId;
  final VitalType type;

  /// Stored as String to handle both numeric (74) and compound ('124/78')
  /// values uniformly.
  final String value;
  final String unit;
  final DateTime measuredAt;
  final String? referenceLabel;
  final Visibility visibility;
}
