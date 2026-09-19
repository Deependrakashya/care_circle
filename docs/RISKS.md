# Risks

Initial assessment; mitigations are planned unless explicitly marked verified.

| Severity | Area | Risk | Mitigation / current evidence |
| --- | --- | --- | --- |
| Critical | Privacy | Private values leak via summary, detail, semantics, logs, media, or caches | Sanitize before presentation and test every output path; not yet implemented |
| High | Product | Missing/stale data falsely reassures family or implies diagnosis | Use source timestamp and evidence-limited wording; no clinical scores |
| High | Technical | Dart port changes contract, null/error behavior, or incident reproduction | Preserve exact fixture/service semantics and compare with authoritative source |
| High | Technical | One failed service blocks all sections | Independent states/retry and request scoping; not yet implemented |
| High | Demo | Flutter Android toolchain/build/install not verified | Establish clean launch and APK install early; TypeScript pass does not verify Flutter |
| High | Submission | No Git repository or freeze/final commit | Establish version control and delivery package; capture real hashes at freeze/finalization |
| High | Submission | Deadline, ID, hosting/access, and form unknown | Track outstanding artifacts; use organizer clock; verify access before delivery |
| High | Submission | Flutter source cannot use Expo Go fallback | Produce and install-test Android APK |
| Medium | Privacy | Staff limited visibility/preferences wording ambiguous | Conservative family-only text interpretation, recorded in ASSUMPTIONS |
| Medium | Demo | Fixed fixture dates become stale | Preserve timestamps; truthful freshness; document fixture date/demo behavior |
| Medium | Technical | Resident switch shows old resident's delayed response | Scope request/state to resident and discard superseded responses |
| Medium | Trust | Local check-in mistaken for staff delivery | Label local acknowledgement; disclose no persistence/notification |
| Medium | Submission | AI log has fewer than three genuine rejected/materially changed outputs | Capture real decisions as they happen; never fabricate entries |
| Medium | Reproducibility | Final source package omits adjacent official reference | Include contract/fixtures with provenance when porting/package source |
| Low | Demo | Broken photo URL disrupts layout | Omit photos from core flow or show accessible failure placeholder |

Current setup does not resolve product risks; it makes them explicit before implementation.
