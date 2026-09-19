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

## 13:00 — Reduce clinical detail and move to reassurance-first disclosure

Decision:
Revised the primary family experience after the client clarified that
CareCircle should answer "Is my parent okay?" rather than function as
a health dashboard.

The Home screen will prioritize a concise reassurance state, freshness,
and a small number of everyday supporting moments. Detailed clinical
information such as vitals will not be part of the primary V1 experience.

Supporting information will use progressive disclosure instead of being
presented as a monitoring dashboard.

Why:
The CEO explicitly stated that families should be able to open the app
and quickly know their parent is okay. Residents have also expressed
concern about excessive monitoring by their children.

This better supports both family reassurance and resident autonomy.

Changed:
- Reduced prominence of individual care metrics.
- Removed vitals from the primary Home experience.
- Reframed timeline as "Today's moments" / "Recent updates."
- Made resident-controlled sharing explicit.
- Preserved check-in as the recovery path when information is insufficient.

Rejected / deferred:
- Health dashboard.
- Vital charts.
- Clinical status interpretation.
- Exposing all available backend information simply because it exists.

## 13:25 — Transition to Immediate Reassurance Startup

Decision:
Changed the startup experience from resident selection to direct resident reassurance overview.

Why:
The CEO clarified that the primary product value is immediate reassurance rather than monitoring. Requiring a selection screen before showing reassurance adds unnecessary friction.

Changed:
- Overview is now the clean-launch screen.
- Resident switching remains available from the header.
- Clinical information is secondary.
- Refresh is no longer a primary action.
- Privacy is surfaced explicitly.
- Check-in is the escalation path for insufficient information.

Rejected / deferred:
- Dashboard-first navigation.
- Prominent manual refresh.
- Vitals-first presentation.
- Mandatory resident selection on every launch.

## 2026-09-19 13:40 — UI Polish: Prototype → Premium Consumer Product

Decision:
Upgraded the entire CareCircle Flutter UI from a functional prototype to a
polished premium consumer product without changing product logic, navigation
structure, or API behavior.

Why:
The judges' first impression should communicate "warm, trustworthy, calm,
human" — not "generic hackathon app". Visual hierarchy and component quality
materially affect perceived product credibility.

Changed:
- Design tokens: tighter surface hierarchy (background / card / hero),
  improved typography scale (27/23/20/17/15/14/12), consistent spacing
  constants (pagePadding=20, sectionGap=24, heroRadius=24, buttonHeight=54).
- ReassuranceCard: icon container, stronger headline, soft gradient border,
  freshness divider, compact metadata row. Now feels like the emotional hero.
- ResidentHeader: identity-component structure (not a form field), animated
  picker selection state with filled check circle.
- EventCard: compact single-row status+time metadata, 42px icon circle,
  removed StatusChip in favor of inline text. Height reduced ~35%.
- PrivacyCard: now shows actual Medication/Meals/Activities/Vitals sharing
  state with color-coded chips. No red used for Private.
- Home screen (ResidentDetailView): CustomScrollView layout, collapsible
  AppBar, "Today's moments" with "See all" link, check-in framed as CTA card.
- Timeline: dot+connector vertical rail, card-per-event, skeleton loading rows,
  warm empty/error states.
- Check-in sheet: handle bar, animated custom option chips, premium success
  state, 54px FilledButton.
- Resident picker: handle bar, animated card selection, no redundant label text.
- Root view: warm loading state, human-language error/empty states with icons.

Rejected / deferred:
- Glassmorphism, heavy shadows, neon colors, large gradients.
- New features or screens not already present.

## 2026-09-19 14:00 — CareCircle Visual Identity: Care Pulse + Resident Agency

Decision:
Introduced a subtle CareCircle visual identity centered on the Care Pulse
motif, resident-controlled sharing language, and story-like daily moments.

Why:
The existing interface was functional and calm but visually generic. This
creative layer adds memorability while reinforcing reassurance, human
connection, and resident autonomy — without introducing monitoring aesthetics.

Changed:
- Care Pulse: three low-opacity concentric circles behind the reassurance icon
  (teal for settled, warm amber for insufficient-data). Clipped to card,
  positioned top-right, never covers content.
- Entrance animation: ReassuranceCard fades and slides up 4px on screen load
  (500ms, easeOut, one-shot). Communicates information arriving, not data
  updating.
- "Shared with you by [Name]": appears below the freshness row in the hero
  card (settled state only) and as a subtle footer in the privacy card.
  Reinforces resident agency as a product principle.
- Contextual greeting: "Good morning/afternoon/evening" above the resident
  header — focuses attention on the person, not the interface.
- Staggered event card entrance: each of the 3 moment cards fades in with a
  60ms offset, giving a gentle "day unfolding" rhythm.
- Check-in success: animated scale+fade for the check circle (0.6→1.0 with
  easeOutBack, 380ms), text fades after icon settles. Calm confirmation,
  not celebratory.

Rejected:
- Animated heartbeat/ECG lines — conflict with product direction.
- Glassmorphism, neon gradients, confetti.
- Gamification, badges, streaks.
- Live-status dots suggesting continuous surveillance.
- Breathing/looping pulse animation — one-shot entrance is sufficient.
- Decorative character illustrations.

## 2026-09-19 14:20 — Custom Typography: Open Sans

Decision:
Adopted the Open Sans font family for the entire application, replacing the default system font.

Why:
A custom font further elevates the application from a generic prototype to a premium consumer product, aligning with the design goals of warmth, trust, and a cohesive visual identity.

Changed:
- Added Open Sans `.ttf` files to `assets/fonts/Open_Sans/static/`.
- Declared the font family in `pubspec.yaml` with associated weights and styles.
- Updated `AppTheme` to use `fontFamily: 'OpenSans'` as the global default.
