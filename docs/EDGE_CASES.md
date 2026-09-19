# Edge cases

Initial inventory from authoritative source inspection, 2026-09-19. All expected behavior is planned; Flutter currently integrates none of these services. “Not implemented” is not a runtime test failure.

| Source/API | Scenario | Expected family behavior | Implemented behavior | Test status |
| --- | --- | --- | --- | --- |
| getDailySummary | Devendra summary generated previous day; empty highlights | Mark age/insufficient information; do not call it current because localDate/envelope is today | Not implemented | NOT TESTED |
| getDailySummary | No matching summary returns null | Neutral empty state; other sections usable | Not implemented | NOT TESTED |
| listCareEvents/listRawTimeline | Empty array | Calm no-shared-updates state, no invented events | Not implemented | NOT TESTED |
| listRawTimeline | Devendra meal has null recordedAt and unsupported RECORDED? status | Reject invalid record without breaking valid ones or leaking payload in logs | Not implemented | NOT TESTED |
| listRawTimeline | Unknown category/type (defensive case, not current fixture) | Skip safely; do not crash | Not implemented | NOT TESTED |
| listCareEvents | Null note/duration; optional scheduledAt absent | Omit unavailable field; never substitute zero duration | Not implemented | NOT TESTED |
| listCareEvents | Private medication | Filter before overview/detail/semantics/counts | Not implemented | NOT TESTED |
| listCareEvents | Delayed medication | State recorded status/time plainly; no clinical inference | Not implemented | NOT TESTED |
| listStaffUpdates | Private note | Withhold all restricted content in every view | Not implemented | NOT TESTED |
| listStaffUpdates | Null text | No string “null”; independent permitted photo handling | Not implemented | NOT TESTED |
| listStaffUpdates | Limited visibility + limited preference ambiguity | Conservative family-only text rule per PRIVACY_MODEL | Not implemented | NOT TESTED |
| listStaffUpdates | Invalid photo URL when photo is permitted | Graceful media placeholder; no retry loop | Not implemented | NOT TESTED |
| sharingPreferences | Meera sharePhotos false | Do not request or display media, including prefetch/details | Not implemented | NOT TESTED |
| listVitals | Meera hidden numeric reading | Skip disallowed request where feasible and filter any returned value | Not implemented | NOT TESTED |
| listVitals | Devendra family-visible numeric value, null referenceLabel | Show only supplied value/unit/time if in scope; no inferred interpretation | Not implemented | NOT TESTED |
| listVitals | Official incident produces 503 | Section unavailable/retry; other sections remain usable | Not implemented; supplied incident remains OFF | NOT TESTED |
| createCheckInRequest | Blank/whitespace reason throws 422 | Field-level validation; preserve input; no false success | Not implemented | NOT TESTED |
| createCheckInRequest | Valid routine/soon request | Honest local received acknowledgement; no staff-delivery claim | Not implemented | NOT TESTED |
| Mock service | Variable delays | Visible independent loading; prevent duplicate check-in | Not implemented | NOT TESTED |
| All record timestamps | Device zone differs from Asia/Kolkata | Use resident zone; clear record age/time, not envelope time | Not implemented | NOT TESTED |
| getResident | Unknown ID throws 404 | Recoverable selection/error state | Not implemented | NOT TESTED |
| Other reads | Unknown ID returns null/empty, not 404 | Preserve exact service behavior in port; validate selection separately | Not implemented | NOT TESTED |
| Resident switching | Older response completes after new selection | Discard stale request result; no cross-resident flash | Not implemented | NOT TESTED |
| Daily summaries | Free text could mention a hidden category | No summary privacy bypass; safe neutral permitted evidence | Not implemented | NOT TESTED |
| Envelope | generatedAt is current but records are old | Freshness from source record timestamp only | Not implemented | NOT TESTED |
| Response isolation | Caller mutates returned data | Preserve canonical fixtures as original service does via cloning | Not implemented in Dart | NOT TESTED |
