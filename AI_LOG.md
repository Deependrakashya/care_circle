# AI working note

## Tools used

Codex primary assistant; local shell and file tools; rg for source discovery; npm/TypeScript for supplied baseline check; Swift/PDFKit to read the local official brief; Python for documentation creation/validation. No subagents, external collaborators, generated images, or external app messages were used.

## Meaningful tasks

| Time (Asia/Kolkata) | Task delegated | Output/recommendation | Accepted / modified / rejected and why | Verification |
| --- | --- | --- | --- | --- |
| 2026-09-19, earlier scan; exact time not recorded | Inspect starter APIs/data for Flutter use | Identified local TypeScript mock, functions/types/fixtures, privacy and failure cases; suggested Dart port or HTTP wrapper | Accepted contract inventory; Dart port is chosen, optional HTTP route deferred because no backend/network requirement exists | Read authoritative source files and docs; no runtime/product claim |
| 2026-09-19 11:29 onward, setup session | Set up user's engineering-context workflow | Documentation scaffold, source/brief reconciliation, product direction, risk/test/submission records | Accepted living records; adapted Expo-specific workflow to user's Flutter target; no application changes or fictitious tests | Read all 10 brief pages/templates; supplied typecheck exit 0; all 17 documentation/guidance files and 14 local links verified; 11 application/fixture/dependency hashes unchanged |
| 2026-09-19 12:00 | Port TypeScript mock API contract to Dart | Created 7 model files, 5 JSON fixture assets, MockApiError, IncidentState, full 9-endpoint MockCareCircleApi, 5 repositories, AppProviders wiring | Accepted; all fixture values match TypeScript source exactly; runtime incident state instead of JSON asset; sealed CareEvent hierarchy | flutter analyze: 0 issues; flutter test: 15/15 passed; field-by-field comparison of all fixture data against TypeScript source verified |
| 2026-09-19 12:20 | Implement MVP UI & ViewModels | Created ResidentDetail, Timeline, and CheckIn screens and their corresponding ViewModels. Added privacy filtering logic in ViewModels. | Accepted; built the smallest coherent product. Preserved partial failure and malformed data handling without crashing. | flutter analyze: 0 issues; flutter test: 15/15 passed; UI flow tested against mock edge cases |

## Rejected or materially changed AI recommendations

1. Earlier assistant offered an HTTP wrapper as an integration option. During setup this route was deferred in favor of a planned local Dart port because the contract requires no backend. This records a real alternative considered, not an implemented/removed server.

Only one such decision is recorded so far. The final brief requires at least three; this requirement remains OPEN. Add genuine subsequent rejected/changed recommendations as they arise. Do not manufacture two more during final cleanup.

## What AI got wrong

- During the first scan, a node_modules exclusion pattern was too narrow for the prefixed search path; dependency matches flooded/truncated output. Corrected by searching explicit source/docs/scripts paths and rereading relevant files. No dependency content was mistaken for the application's API.
- First documentation patch attempted two operations on README in one patch and was rejected by the patch tool before any files were written. Recreated the documentation with a controlled file writer, then scheduled completeness/link validation. This is a tool-operation error, not a product defect.

## Accountability and next delegation

Static inspection is not proof of app behavior. TypeScript passing does not verify a Dart port. Future AI work should be bounded to faithful contract migration and privacy/failure cases with actual verification. Keep delivery decisions accountable to user intent and official sources. Update this log and SESSION_STATE after meaningful work; no fabricated history or PASS claims.
