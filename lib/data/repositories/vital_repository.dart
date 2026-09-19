import '../api/care_circle_api.dart';
import '../models/api_envelope.dart';
import '../models/json_parsing.dart';
import '../models/vital_reading.dart';

abstract interface class VitalRepository {
  /// May throw [MockApiError] with status 503 during incident mode.
  Future<ApiEnvelope<List<VitalReading>>> listVitals(String residentId);
}

class ApiVitalRepository implements VitalRepository {
  const ApiVitalRepository(this._api);

  final CareCircleApi _api;

  @override
  Future<ApiEnvelope<List<VitalReading>>> listVitals(
    String residentId,
  ) async {
    // MockApiError (503) propagates naturally when incident mode is enabled.
    final json = await _api.listVitals(residentId);
    return ApiEnvelope.fromJson(json, (value) {
      if (value is! List) {
        throw const FormatException('Expected a vitals list.');
      }
      final vitals = value
          .map(
            (item) => VitalReading.fromJson(requireObject(item, 'vitalReading')),
          )
          .toList(growable: false);
      return List<VitalReading>.unmodifiable(vitals);
    });
  }
}
