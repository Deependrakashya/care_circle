/// Development-only health check response, matching the reference StarterHealth.
class StarterHealth {
  const StarterHealth({
    required this.residentCount,
    required this.timelineRecordCount,
    required this.vitalsIncident,
    required this.fixtureDate,
  });

  final int residentCount;
  final int timelineRecordCount;
  final bool vitalsIncident;
  final String fixtureDate;
}
