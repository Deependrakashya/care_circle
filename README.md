# CareCircle — Peace of Mind Without Surveillance

A cohesive family experience for understanding a resident's recent day while respecting resident-controlled sharing. Goal: reduce repetitive reassurance calls without surveillance or medical certainty.

**Current state:** The CareCircle mobile challenge has been fully implemented in Flutter. The app features a complete "Peace of mind" workflow: from resident selection to a detailed reassurance dashboard (Timeline, Vitals, Staff Updates), including a check-in request form. The design system leverages a calming aesthetic without feeling like a clinical dashboard. 

## Setup and run

From `care_circle`, with Flutter installed and on PATH (project requires Dart `^3.12.2`):

```sh
flutter pub get
flutter devices
flutter run -d <android-device-id>
```

Replace `<android-device-id>` with an ID from `flutter devices`. Dependencies: Flutter, `cupertino_icons`, `intl`, and `provider` 6.1.5+1 (locked); development dependencies: `flutter_test` and `flutter_lints`.

```sh
flutter analyze
flutter test
flutter build apk --release
```

**APK Delivery**: An Android release APK has been successfully built and is located at `build/app/outputs/flutter-apk/app-release.apk`. 

The supplied reference Expo project has dependencies installed in this workspace; its baseline check passed on 2026-09-19:

```sh
cd ../PSI_CareCircle_Candidate_Starter_Code
npm run typecheck
```

For clean reference setup, the brief specifies Node.js 22.13+ or 24.3+ and `npm install` before that check. Preserve the supplied lockfile.

## Scope, architecture, and privacy

**Workflow Implementation**: The family member can select a resident → understand recent day/freshness (Reassurance Card) → inspect permitted events (Timeline/Updates) → understand read-only sharing limits (Privacy Card) → request check-in. The check-in only acknowledges locally; nothing is persisted or sent to staff.

**Architecture**: The app follows a robust Provider MVVM architecture with stateless views, `ChangeNotifier` view models, typed repositories, and a local raw-data API port. Independent sections handle their own loading and error states (`SectionState`), ensuring that a failure in one area (e.g., vitals) doesn't break the entire dashboard.

**Privacy & Trust**: Privacy filtering is actively enforced at the ViewModel layer. Restricted content (e.g., private vitals) is gracefully masked. The app behaves sensibly when data is absent (e.g., missing photos), malformed, or delayed. Family members cannot edit sharing preferences.

Omitted intentionally: authentication, onboarding, backend, admin portal, chat, push, appointments, clinical scores, AI summaries, and complex charts.

## Fixtures and demo

Fictional fixture date: 2026-09-19. IDs: `resident-meera`, `resident-devendra`; both use `Asia/Kolkata`. Includes sparse/stale summaries, private records, malformed timeline data, nulls, and broken media. No credentials. Incident is off; activate only following an official bulletin. The full TypeScript mock API contract was ported accurately to Dart.

Resident assets are bundled, so running the current app needs no sibling folder. See `assets/data/README.md` for source provenance. Reference location for remaining work: `../PSI_CareCircle_Candidate_Starter_Code/`. Preserve the authoritative contract/fixtures in final source handover.

## Verification and delivery

Supplied TypeScript baseline: PASS. Flutter analysis: PASS. Android APK build: SUCCESS (`app-release.apk`). Automated test result is tracked in TEST_PLAN.

Participant ID: pending. Freeze commit: pending. Final submission commit: pending. Neither project was a Git repository at inspection. See [SUBMISSION_STATUS](docs/SUBMISSION_STATUS.md) for artifacts, video limits, permissions, and deadlines.

Resume with [SESSION_STATE](docs/SESSION_STATE.md), then [PROJECT_CONTEXT](docs/PROJECT_CONTEXT.md). Maintain [DECISIONS](DECISIONS.md), [AI_LOG](AI_LOG.md), and [CHANGELOG](docs/CHANGELOG.md). The preserved user workflow is [ENGINEERING_WORKFLOW](docs/ENGINEERING_WORKFLOW.md).
