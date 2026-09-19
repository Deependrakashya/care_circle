/// Simple runtime incident state, matching the reference `incident-state.json`.
///
/// Default is OFF. The hackathon instructions require waiting for an
/// official bulletin before enabling the vitals incident scenario.
///
/// Toggle at runtime: `IncidentState.vitals503 = true;`
class IncidentState {
  IncidentState._();

  /// When true, [MockCareCircleApi.listVitals] throws a 503 MockApiError.
  static bool vitals503 = false;
}
