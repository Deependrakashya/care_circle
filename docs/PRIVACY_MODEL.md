# Privacy model

Status: reviewed contract and proposed policy; no Flutter enforcement/tests yet. Sources: supplied types, docs/API.md, PDF pp. 7–8. Apply category preference AND record visibility before presentation. Unknown/malformed permission values default to withholding. Family cannot edit preferences.

| Category | Source and family rule | Hidden UI | Load underlying data? | Details |
| --- | --- | --- | --- | --- |
| Medication | shareMedicationStatus + event visibility | Generic sharing explanation; no hidden label/status/note/count | Mixed events may load; filter before widgets | Same restrictions |
| Meals | shareMealStatus + event visibility | Sharing explanation, not “no meals” | Filter mixed events | Same restrictions |
| Activities | shareActivityDetails + event visibility | No hidden activity/duration/note | Filter mixed events | Same restrictions |
| Vitals | shareVitalDetails + reading visibility | No numeric value or derived diagnosis | Skip category request when disabled; filter all returned readings | Same restrictions |
| Staff text | shareStaffNotes + update visibility; matrix below | No hidden text/author detail | Skip when no permitted text/photo can be used; otherwise sanitize fields | Same restrictions |
| Photos | sharePhotos + update visibility; separate from note-text permission | Neutral placeholder if useful; no URL disclosure | Never request/decode/prefetch if disabled | Same restrictions |
| Daily summary | No category/visibility tags in type | Neutral insufficient/shared-information message when text cannot be safely verified | May load; do not blindly forward headline/highlights | No summary bypass |
| Preferences | Resident sharingPreferences | Read-only resident-controlled information | Load with profile | No edit controls |

Ordinary category records: family requires enabled category; limited additionally requires category permission; resident_only is always excluded. Visibility alone is insufficient.

## Conservative staff-note interpretation

PDF p. 8 says limited preference permits only family-visible notes. API describes limited visibility as eligible when category preference allows it, without an explicit staff matrix. Adopt conservatively: preference none → no text; limited → visibility family only; all → family and limited; resident_only → never. This withholds Meera's limited note text. Record any later authoritative change; do not ask organizers to interpret product ambiguity.

Photo permission is separate: Devendra's shareStaffNotes none must hide text even though sharePhotos is true. A scoped family-visible photo may still fail gracefully at its intentionally broken URL. Meera's photos must never be requested.

## Summary and secondary-channel risks

Summary strings can mention disabled categories without structured tags. Planned safe fallback: neutral overview from validated permitted evidence, or insufficient information; never fabricate a reassuring/clinical state. Implement and test before exposing summaries.

Apply restrictions to details, search if added, accessibility labels, logs, errors, caches, counts, media requests, and fallbacks. Avoid distinguishing a specific private record from an absent one. Local fictional fixtures are for evaluation; client filtering is not production backend authorization.
