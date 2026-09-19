# CareCircle Session State

## Core Product Constraints
- **Do not build a health dashboard.** Focus on reassurance-first.
- **Primary UI (Home Screen) must be extremely simple.** Omit detailed clinical data like vitals and staff notes from the primary view.
- **Use progressive disclosure.** Let families see just enough to know the resident is okay. They can tap to see more details if they want.
- **Respect resident privacy.** Ensure privacy text is understated but clear ("Meera chooses what is shared with family").
- **Recovery path:** Keep Check-in as the primary recovery path when information is insufficient (e.g., due to privacy limits or stale data).
- **No obsessive monitoring tools:** Do not add health scores, charts, monitoring streaks, alerts, graphs, or live-looking indicators. Do not encourage compulsive refreshing.
- **Clean launch:** Boot directly to the default resident overview, omitting a mandatory family-selection step.
- **Freshness rules:** Timestamp the latest update according to actual family-visible events, not summary generation times.

## Next Implementation Steps
- None. Task is complete.
