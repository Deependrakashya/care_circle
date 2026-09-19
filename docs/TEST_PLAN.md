# Test plan

Statuses: NOT TESTED / PASS / FAIL / PARTIAL. Only actual checks may be PASS. Source review is not runtime verification. Default generated widget test is not a CareCircle acceptance test.

## Verification performed

| Check | Result | Evidence |
| --- | --- | --- |
| Supplied TypeScript baseline | PASS | npm run typecheck exited 0 on 2026-09-19 during setup |
| Authoritative brief/contract review | PASS | Read all 10 PDF pages, source types/fixtures/service, API doc, SUBMISSION and templates |
| Incident configuration inspection | PASS | src/mock/incident-state.json has vitals503 false; no incident command run |
| Flutter analyze / flutter test | NOT TESTED | No product code changed during documentation setup |
| Android build/install/launch | NOT TESTED | No device or APK verified |
| Documentation links/completeness | PASS | All 12 required docs and 5 root/workflow files exist; all 14 local Markdown links resolve |
| Setup scope and source preservation | PASS | SHA-256 comparison confirms 11 application/fixture/dependency files unchanged; user workflow preserved verbatim; conditional CLIENT_RESPONSE.md absent |

## Manual acceptance matrix

| Case | Expected evidence | Status |
| --- | --- | --- |
| Clean launch | App opens and principal workflow is usable without setup surprises | NOT TESTED |
| Resident switching | Correct identity/facility/data; no old response or private content flash | NOT TESTED |
| Normal data | Meera's permitted recent day/event detail is coherent | NOT TESTED |
| Sparse data | Devendra has useful insufficient-information messaging | NOT TESTED |
| Stale data | Prior-day summary accurately dated; no fresh label from envelope | NOT TESTED |
| No events | Empty shared-updates state without fabricated data | NOT TESTED |
| Malformed/unknown records | Invalid entries skipped without losing valid records/crashing | NOT TESTED |
| Private records | Medication, vitals, notes absent from all presentation paths | NOT TESTED |
| Broken media | Permitted failed image has usable placeholder | NOT TESTED |
| Hidden media | Disabled photo generates no network request/prefetch | NOT TESTED |
| Slow loading | Independent loading remains responsive | NOT TESTED |
| API failure | Vitals failure leaves meals/activity/medication usable | NOT TESTED |
| Retry | Only failed section retried; success restores it | NOT TESTED |
| Check-in success | Local received state, no persistence/staff-notification claim | NOT TESTED |
| Check-in validation | Blank and whitespace-only reasons rejected; draft retained | NOT TESTED |
| Android rendering | Install/launch, navigation, keyboard, small screen, no overflow | NOT TESTED |
| Accessibility basics | Text scaling, contrast, touch targets, semantic labels, focus | NOT TESTED |
| Freshness labels | Record timestamps and resident zone, including device-zone difference | NOT TESTED |
| Privacy enforcement | Category AND record restrictions, read-only preferences, detail/summary parity | NOT TESTED |
| Null optional values | No null text, fake zero duration, or crashes | NOT TESTED |
| Fixture isolation | UI mutation cannot corrupt canonical service data | NOT TESTED |

Do not activate supplied incident early. Once officially instructed, record original bulletin/time and command, verify 503 and unrelated sections, and retain evidence. Until then, planned failure-handling tests can use an isolated test double without mutating official incident state.
