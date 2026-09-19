import '../models/json_parsing.dart';
import '../models/starter_health.dart';

/// Raw transport boundary. Models are parsed by the repository, never widgets.
abstract interface class CareCircleApi {
  Future<StarterHealth> getStarterHealth();
  Future<JsonMap> listResidents();
  Future<JsonMap> getResident(String residentId);
  Future<JsonMap> getDailySummary(String residentId);
  Future<JsonMap> listCareEvents(String residentId);
  Future<JsonMap> listRawTimeline(String residentId);
  Future<JsonMap> listVitals(String residentId);
  Future<JsonMap> listStaffUpdates(String residentId);
  Future<JsonMap> createCheckInRequest(JsonMap input);
}
