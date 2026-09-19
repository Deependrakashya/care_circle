import '../api/care_circle_api.dart';
import '../models/api_envelope.dart';
import '../models/daily_summary.dart';
import '../models/json_parsing.dart';

abstract interface class DailySummaryRepository {
  Future<ApiEnvelope<DailySummary?>> getDailySummary(String residentId);
}

class ApiDailySummaryRepository implements DailySummaryRepository {
  const ApiDailySummaryRepository(this._api);

  final CareCircleApi _api;

  @override
  Future<ApiEnvelope<DailySummary?>> getDailySummary(String residentId) async {
    final json = await _api.getDailySummary(residentId);
    return ApiEnvelope.fromJson(json, (value) {
      if (value == null) return null;
      return DailySummary.fromJson(requireObject(value, 'dailySummary'));
    });
  }
}
