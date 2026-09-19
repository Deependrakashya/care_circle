import '../api/care_circle_api.dart';
import '../models/api_envelope.dart';
import '../models/check_in_request.dart';
import '../models/json_parsing.dart';

abstract interface class CheckInRepository {
  /// May throw [MockApiError] with status 422 for blank reasons.
  Future<ApiEnvelope<CheckInRequest>> createCheckInRequest(
    CheckInRequestInput input,
  );
}

class ApiCheckInRepository implements CheckInRepository {
  const ApiCheckInRepository(this._api);

  final CareCircleApi _api;

  @override
  Future<ApiEnvelope<CheckInRequest>> createCheckInRequest(
    CheckInRequestInput input,
  ) async {
    // MockApiError (422) propagates naturally for blank reason.
    final json = await _api.createCheckInRequest(input.toJson());
    return ApiEnvelope.fromJson(json, (value) {
      return CheckInRequest.fromJson(requireObject(value, 'checkInRequest'));
    });
  }
}
