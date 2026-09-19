# Architecture

Implemented: MVVM with Provider, explicitly requested by the user on 2026-09-19.

```text
UI → ViewModel → Repository → API data
                      ↓
                 Model parsing
```

## Actual structure

```text
lib/
  main.dart                                 Entry point
  app.dart                                  MaterialApp/theme
  app_providers.dart                        Dependency composition root
  views/residents_view.dart                 Stateless screen
  view_models/residents_view_model.dart
  data/
    api/care_circle_api.dart                Raw API interface (9 endpoints)
    api/mock_care_circle_api.dart           Local JSON asset + simulated delay
    api/mock_api_error.dart                 Typed 404/422/503 errors
    api/incident_state.dart                 Runtime vitals-503 toggle
    repositories/
      resident_repository.dart
      daily_summary_repository.dart
      care_event_repository.dart
      vital_repository.dart
      staff_update_repository.dart
      check_in_repository.dart
    models/
      json_parsing.dart                     JSON guards and helpers
      api_envelope.dart                     Generic envelope with generatedAt
      resident.dart                         Resident + facility + preferences
      facility.dart
      sharing_preferences.dart
      visibility.dart                       family / limited / resident_only
      daily_summary.dart                    Summary + reassurance state
      care_event.dart                       Sealed hierarchy: medication/meal/activity
      vital_reading.dart                    Numeric/string value, visibility
      staff_update.dart                     Nullable text/mediaUrl, visibility
      check_in_request.dart                 Input (toJson) + Response (fromJson)
      starter_health.dart                   Development-only health check
assets/data/
  residents.json                            Two residents from official fixture
  daily_summaries.json                      Meera reassuring, Devendra stale/empty
  care_events.json                          6 valid events (incl. private, delayed)
  vitals.json                               2 readings (resident_only + family)
  staff_updates.json                        3 updates (limited, private, null text)
  raw_timeline.json                         All events + malformed evt-malformed-999
```

## Mock API contract

All 9 endpoints from the supplied TypeScript `careCircleApi.ts` are ported:

| Dart method | Behavior |
| --- | --- |
| `getStarterHealth()` | Returns resident count, timeline count, incident state, fixture date (80–200ms) |
| `listResidents()` | Two residents, envelope-wrapped (220–600ms) |
| `getResident(id)` | Lookup or throw MockApiError 404 RESIDENT_NOT_FOUND |
| `getDailySummary(id)` | Matching summary or null data in envelope |
| `listCareEvents(id)` | Filtered typed events including private records |
| `listRawTimeline(id)` | Filtered raw records; malformed entry preserved as-is |
| `listVitals(id)` | Filtered readings; throws 503 VITALS_UNAVAILABLE when `IncidentState.vitals503` is true (350–1000ms) |
| `listStaffUpdates(id)` | Filtered updates preserving null text, broken URL, visibility |
| `createCheckInRequest(input)` | Validates reason (422) or returns local received acknowledgement (500–1000ms) |

Delays are asynchronous `Future.delayed` with randomized spread matching the reference. Each call decodes JSON afresh to isolate mutable responses (equivalent to reference's `structuredClone`).

## Boundaries and state ownership

`ResidentsView` only watches `ResidentsViewModel` and calls its actions. It never reads a repository/API provider, decodes JSON, runs service calls, or owns mutable application state. No StatefulWidget, setState, or FutureBuilder is used for app state.

`ResidentsViewModel extends ChangeNotifier` owns the resident list, initial/loading/ready/empty/error status, display error, selected resident ID, and lifecycle guard. Immutable getters expose state. `loadResidents()` handles first load, refresh and retry; `selectResident()` validates selection. Overlapping loads are ignored, disposed view models ignore late results, and valid selection survives refresh. Refresh clears old data rather than presenting it as current; failures expose safe messages without raw exception payloads.

Repositories define typed operations. Each calls `CareCircleApi`, parses the envelope and nested model objects through `fromJson`, and returns immutable typed data. They store no screen state. `CareEventRepository.listRawTimeline` skips malformed records gracefully (logging a warning) rather than crashing. `VitalRepository` and `CheckInRepository` propagate `MockApiError` for incident/validation errors.

`CareCircleApi` defines raw JSON access. `MockCareCircleApi` loads bundled assets, preserves original delay ranges, decodes anew per call to isolate mutable responses, and supplies response generatedAt. `IncidentState.vitals503` toggles the 503 error at runtime. No HTTP/backend exists.

Models are immutable data. Missing/invalid required fields raise FormatException instead of defaulting permissions to allow. Envelope generation time is not care-record freshness. `CareEvent` uses a sealed class hierarchy for exhaustive pattern matching.

## Provider wiring and lifecycle

`AppProviders` wires API → six repositories → ChangeNotifierProvider(view model). API/repository are injected via constructor; only the composition root resolves them through Provider. The view model starts its first load at creation. Provider owns notifier disposal. Views use `context.watch` for state and `context.read<ResidentsViewModel>()` inside callbacks for actions. These follow [Provider's package documentation](https://pub.dev/packages/provider).

Dependency: provider 6.1.5+1 (locked), with nested transitive dependency. No code generator, HTTP client, or additional state framework.

## Scope and future extension

Resident listing/selection is implemented as the working UI example. The full mock API contract and all repositories are implemented. Care event, summary, vitals, notes, check-in ViewModels and UI screens remain unimplemented. Privacy filtering (visibility + sharing preferences enforcement) is not yet applied. Add each screen's state/actions in a view model; widgets remain passive. No cache or synthetic fallback exists.
