# Fixture provenance

residents.json is an exact JSON export of the residents array from the supplied PSI_CareCircle_Candidate_Starter_Code/src/mock/fixtures.ts, dated 2026-09-19. Both records are fictional. The source was read and transpiled locally; it was not edited.

Only the resident-list endpoint is ported so far. Other fixtures, deliberate errors and incident state remain in the official reference and must retain their semantics when ported. No incident toggle is exposed in the current Flutter app.

MockCareCircleApi decodes the bundled asset per request, delays 220–599 ms, and returns the supplied envelope shape with current response time. That timestamp is not a care-record freshness claim. No external service, backend, credential or sibling directory is needed to run this resident example.
