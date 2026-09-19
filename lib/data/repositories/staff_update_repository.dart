import '../api/care_circle_api.dart';
import '../models/api_envelope.dart';
import '../models/json_parsing.dart';
import '../models/staff_update.dart';

abstract interface class StaffUpdateRepository {
  Future<ApiEnvelope<List<StaffUpdate>>> listStaffUpdates(String residentId);
}

class ApiStaffUpdateRepository implements StaffUpdateRepository {
  const ApiStaffUpdateRepository(this._api);

  final CareCircleApi _api;

  @override
  Future<ApiEnvelope<List<StaffUpdate>>> listStaffUpdates(
    String residentId,
  ) async {
    final json = await _api.listStaffUpdates(residentId);
    return ApiEnvelope.fromJson(json, (value) {
      if (value is! List) {
        throw const FormatException('Expected a staff-update list.');
      }
      final updates = value
          .map(
            (item) =>
                StaffUpdate.fromJson(requireObject(item, 'staffUpdate')),
          )
          .toList(growable: false);
      return List<StaffUpdate>.unmodifiable(updates);
    });
  }
}
