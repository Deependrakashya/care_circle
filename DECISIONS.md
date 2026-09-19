# Decision log

Times are local Asia/Kolkata, 2026-09-19. Entries below record decisions made during this setup session; no earlier implementation history is implied.

| Time | Decision | Why | Rejected/deferred alternatives |
| --- | --- | --- | --- |
| 11:29 | Use existing care_circle Flutter project as working target; retain supplied Expo starter as authoritative reference | Earlier user Flutter request; official PDF p. 3 permits other frameworks with reproducible Android delivery; assumption stated to user | Silently switching the app back to Expo based on pasted technical context |
| 11:29 | Initialize living docs before implementing features | User explicitly requested this setup; current implementation must not be overstated | Beginning screens without contract/context review |
| 11:29 | Adopt reassurance-first narrow overview, supporting event, read-only sharing, and structured check-in direction | User product direction and brief's reassurance/privacy tension | Clinical dashboard, surveillance views, broad unfinished feature list |
| 11:29 | No separate backend; plan a faithful local Dart mock port | Supplied service is local and source of truth; no network requirement | Earlier assistant's optional HTTP-wrapper route; deferred as unnecessary infrastructure |
| 11:29 | Filter/validate before presentation and isolate service recovery | Privacy must hold across views; vitals failure cannot block other content | Widget-only hiding and all-or-nothing load failure |
| 11:29 | Use record timestamps, not envelope generatedAt, for freshness | Source contract explicitly separates fetch time and record age | Treating current response time as current care information |
| 11:29 | Family sharing preferences remain read-only | Resident autonomy is an explicit user constraint | Family-controlled privacy editing |
| 11:29 | Interpret limited staff-note preference conservatively as visibility family only | PDF p. 8; API does not resolve complete staff matrix | Exposing limited note text under ambiguous permission wording |
| 11:32 | Keep actual architecture and test claims separate from plans; no cache initially | Only generated app exists, and no Flutter checks have run | Imaginary implemented layers or unverified PASS claims |
| 11:32 | Preserve official incident off and defer CLIENT_RESPONSE.md until requested | User instructions and brief restrict both triggers | Premature incident activation or fabricated bulletin response |
| 12:00 | Port full TypeScript mock API contract to Dart, preserving all 9 endpoints, fixture data, edge cases, error codes, delays, and incident behavior | Official starter is source of truth; Flutter submission requires Dart equivalents; no custom backend needed | HTTP wrapper, partial port, or redesigning the supplied data |
| 12:00 | Use runtime static boolean for incident state instead of bundled JSON asset | Simpler toggling without needing to rebuild the app; spec suggests `static bool vitals503 = false` | Read-only JSON asset approach |
| 12:00 | Use sealed class hierarchy for CareEvent (MedicationEvent/MealEvent/ActivityEvent) | Enables exhaustive switch patterns; Dart 3 feature matches TypeScript discriminated union semantics | Single class with nullable category-specific fields |
| 12:00 | Store VitalReading.value as String | Handles both numeric (74) and compound ('124/78') values uniformly without losing precision | Separate string/numeric fields or dynamic type |
| 12:00 | listRawTimeline repository skips malformed records with debug logging | Spec requires safe rejection without crashing; valid records must still display | Throwing on first malformed record; silently ignoring all errors |
| 12:16 | Apply privacy filtering at the ViewModel layer via `Visibility` enum and `SharingPreferences` | Keeps the repository layer purely reflecting the API; ViewModels enforce business rules for the specific user role (family) | Applying privacy at the Repository layer |
| 12:16 | ViewModels use a generic `SectionState` for independent loading of screen sections | Provides robust partial failure UI. If Vitals fail, Events still render successfully | Combining all data into a single loading state |
| 12:20 | Adopt "Calm Reassurance" visual language (soft teal, warm off-white, soft borders) | User directed product emotional state is "peace of mind, not medical surveillance" | High-contrast clinical dashboard with heavy shadows |
| 12:25 | Handle private vitals with a neutral, read-only masked UI state | Privacy is a normal product state, not an error. Keeps the family informed without anxiety. | Red "Error: Private" warnings |
| 12:28 | Flatten timeline into simple, non-technical list (`EventCard`) | Avoids chronological-feed telemetry feel, adhering to "calm and accessible" direction | Overly technical logging design with dense metadata |

Planned design decisions do not imply implementation. Future changes append dated rationale; preserve this history.
