# CareCircle — Peace of Mind Without Surveillance

A planned family experience for understanding a resident's recent day while respecting resident-controlled sharing. Goal: reduce repetitive reassurance calls without surveillance or medical certainty.

**Current state:** MVVM with Provider is implemented, with a working resident-list/selection screen using the exact supplied resident fixtures. Flow: UI → ViewModel → Repository → API data; the repository parses JSON into immutable models. All application state/actions live in the view model. Other care APIs and product workflows remain pending. The supplied Expo starter remains authoritative. No backend or credentials are required.

## Setup and run

From `care_circle`, with Flutter installed and on PATH (project requires Dart `^3.12.2`):

```sh
flutter pub get
flutter devices
flutter run -d <android-device-id>
```

Replace `<android-device-id>` with an ID from `flutter devices`. These are intended steps; Android launch has not been verified. Dependencies: Flutter, `cupertino_icons`, and `provider` 6.1.5+1 (locked); development dependencies: `flutter_test` and `flutter_lints`.

```sh
flutter analyze
flutter test
flutter build apk --release
```

Expected output after a successful build: `build/app/outputs/flutter-apk/app-release.apk`. No APK has been built or installed during this task. Flutter needs an APK delivery path; the brief's Expo Go fallback applies to Expo.

The supplied reference has dependencies installed in this workspace; its baseline check passed on 2026-09-19:

```sh
cd ../PSI_CareCircle_Candidate_Starter_Code
npm run typecheck
```

For clean reference setup, the brief specifies Node.js 22.13+ or 24.3+ and `npm install` before that check. Preserve the supplied lockfile.

## Scope, architecture, and privacy

Planned workflow: select resident → understand recent day/freshness → inspect permitted event → understand read-only sharing limits → request check-in. The supplied check-in only acknowledges locally; nothing is persisted or sent to staff.

Actual architecture is Provider MVVM with a stateless view, ChangeNotifier view model, typed repository and local raw-data API. See: [ARCHITECTURE](docs/ARCHITECTURE.md), [DATA_FLOW](docs/DATA_FLOW.md). Resident/nested preference parsing, loading/error/empty states, retry and selection are implemented. Care-record privacy filtering, independent care sections and freshness labels are still planned. No cache or fallback exists.

See [PRIVACY_MODEL](docs/PRIVACY_MODEL.md), [EDGE_CASES](docs/EDGE_CASES.md), [ASSUMPTIONS](docs/ASSUMPTIONS.md), and [RISKS](docs/RISKS.md). Absence/failure must not imply reassurance. Restricted content must not reach widgets, logs, or media requests.

Omitted: authentication, onboarding, backend, admin portal, chat, push, appointments, clinical scores, AI summaries, and complex charts. Family cannot edit sharing preferences.

## Fixtures and demo

Fictional fixture date: 2026-09-19. IDs: `resident-meera`, `resident-devendra`; both use `Asia/Kolkata`. Includes sparse/stale summaries, private records, malformed timeline data, nulls, and broken media. No credentials. Incident is off; activate only following an official bulletin. Resident-list Dart equivalence is implemented with bundled assets; other endpoints and incident reproduction remain unimplemented.

Resident assets are bundled, so running the current app needs no sibling folder. See `assets/data/README.md` for source provenance. Reference location for remaining work: `../PSI_CareCircle_Candidate_Starter_Code/`. Preserve the authoritative contract/fixtures in final source handover.

## Verification and delivery

Tested Android platform/device: none. Supplied TypeScript baseline: PASS. Flutter analysis: PASS. Automated test result is tracked in TEST_PLAN. Android rendering and APK build/install: NOT TESTED. See [TEST_PLAN](docs/TEST_PLAN.md).

Participant ID: pending. Freeze commit: pending. Final submission commit: pending. Neither project was a Git repository at inspection. See [SUBMISSION_STATUS](docs/SUBMISSION_STATUS.md) for artifacts, video limits, permissions, and deadlines.

Resume with [SESSION_STATE](docs/SESSION_STATE.md), then [PROJECT_CONTEXT](docs/PROJECT_CONTEXT.md). Maintain [DECISIONS](DECISIONS.md), [AI_LOG](AI_LOG.md), and [CHANGELOG](docs/CHANGELOG.md). The preserved user workflow is [ENGINEERING_WORKFLOW](docs/ENGINEERING_WORKFLOW.md).
