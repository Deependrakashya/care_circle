# Project context

Updated: 2026-09-19 (Asia/Kolkata), Provider MVVM setup. Canonical context for future agents.

## Authority and product

Sources read: `../../PSI_CareCircle_Candidate_Package (1).pdf` (all 10 pages); supplied types, fixtures, service, docs/API.md, SUBMISSION.md, and templates; user workflow preserved in ENGINEERING_WORKFLOW.md.

Client: CareCircle premium assisted-living communities. Users: adult family members living remotely; residents own sharing choices; staff record information in existing systems. Business goal: fewer repetitive reassurance calls and greater trust. Tension: reassurance without surveillance, useful detail without anxiety, speed without sacrificing reliability.

Direction: **CareCircle — Peace of Mind Without Surveillance**. Answer “How is my parent doing today?” through a calm overview, truthful freshness, meaningful supporting evidence, visible read-only sharing information, and a structured check-in. Do not diagnose or invent health scores.

## Official required capabilities

- Understand a resident's current status or recent day.
- Inspect at least one meaningful supporting event/detail.
- Understand resident privacy/sharing preferences.
- Handle absent, malformed, delayed, or unavailable data sensibly.
- Demonstrate the principal workflow reliably from a clean launch.

Multiple residents and check-in are chosen product scope; specific categories/check-in are not independently mandated by the initial brief. Exclude backend, authentication, onboarding, messaging, push, appointments, admin tools, clinical charts/scores, and AI-generated reassurance unless justified by a later requirement.

## Constraints and implementation

Official starter: Expo SDK 57 / React Native 0.86 / TypeScript. PDF p. 3 permits another framework with reproducible Android delivery. Active target: `care_circle` Flutter app. User explicitly requested MVVM + Provider with all states/actions in view models. Preserve supplied mock data and deterministic failures as Dart endpoints are ported. No separate backend.

Flutter now has a stateless resident screen, Provider wiring, ResidentsViewModel state/actions, ResidentRepository with model parsing, and a local API reading exact bundled resident fixtures. Loading/error/empty/retry/selection and lifecycle guards are implemented. Care-record privacy filtering and remaining care APIs are pending. Flutter analysis passed; automated verification is tracked in TEST_PLAN. Expo is unchanged; baseline typecheck passed. Official incident is off. No Android build/install verified; neither folder has Git history.

Paths relative to project root:
- `lib/app_providers.dart`: dependency wiring; `lib/views/`, `lib/view_models/`, `lib/data/`: MVVM layers.
- `assets/data/residents.json`: bundled authoritative residents; `test/`: model/repository/view-model/widget checks.
- `../PSI_CareCircle_Candidate_Starter_Code/src/types/careCircle.ts`: authoritative types.
- `../PSI_CareCircle_Candidate_Starter_Code/src/mock/`: fixtures, service, incident state.
- `../PSI_CareCircle_Candidate_Starter_Code/docs/API.md`: authoritative API contract.
- `../PSI_CareCircle_Candidate_Starter_Code/SUBMISSION.md`: checklist/freeze rules.
- `docs/SESSION_STATE.md`, `DECISIONS.md`, `AI_LOG.md`: persistent project history.

## Delivery and evaluation

Android required; APK preferred. Only Expo has the frozen Expo Go alternative. Client demo ≤3 minutes; engineering handover ≤90 seconds. CEO brief and CLIENT_RESPONSE.md only when requested. Participant ID belongs in artifact filenames and the submission form. Verify link access/installability and declare freeze/final commits. Organizer clock controls deadlines; times not yet provided. After freeze: no app, dependency, asset, fixture, or configuration changes; documentation-only commits allowed until final deadline.

Weights: product judgment 20%, working product 20%, UX/detail 15%, adaptation 15%, resilience 10%, client communication 10%, delivery discipline 5%, AI leverage 5%. Minimum bars: product judgment, resilience, client communication, delivery discipline.

## Bulletin, blockers, next priorities

No official bulletin received. The user workflow is not an incident announcement. Do not activate incident or create CLIENT_RESPONSE.md yet. Record original bulletin/time, then update context, decisions, affected implementation/tests, AI log, and session state.

No blocker to documentation/local implementation. Delivery dependencies: participant ID, official deadlines/channel, Git/source delivery location, Android verification, and freeze hash. Staff-note semantics need the conservative interpretation recorded in PRIVACY_MODEL.

Next: verify Android launch/build and establish Git; extend models/API/repository to care records; enforce privacy/freshness before adding care-section state and UI.
