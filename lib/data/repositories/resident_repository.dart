import '../api/care_circle_api.dart';
import '../models/api_envelope.dart';
import '../models/json_parsing.dart';
import '../models/resident.dart';

abstract interface class ResidentRepository {
  Future<ApiEnvelope<List<Resident>>> listResidents();
}

class ApiResidentRepository implements ResidentRepository {
  const ApiResidentRepository(this._api);

  final CareCircleApi _api;

  @override
  Future<ApiEnvelope<List<Resident>>> listResidents() async {
    final json = await _api.listResidents();
    return ApiEnvelope.fromJson(json, (value) {
      if (value is! List) {
        throw const FormatException('Expected a resident list.');
      }
      final residents = value
          .map((item) => Resident.fromJson(requireObject(item, 'resident')))
          .toList(growable: false);
      if (residents.map((resident) => resident.id).toSet().length !=
          residents.length) {
        throw const FormatException('Duplicate resident identifiers.');
      }
      return List<Resident>.unmodifiable(residents);
    });
  }
}
