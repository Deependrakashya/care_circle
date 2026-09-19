# CareCircle engineering workflow

Before substantial work, read in order: `docs/SESSION_STATE.md`, `docs/PROJECT_CONTEXT.md`, `DECISIONS.md`, `AI_LOG.md`, `docs/SUBMISSION_STATUS.md`, relevant technical docs, and source files.

Follow the preserved user instructions in `docs/ENGINEERING_WORKFLOW.md`. The active target is Flutter per the user's earlier request; PDF page 3 permits another framework with reproducible Android delivery. The supplied Expo starter remains the authoritative data/behavior reference. Record later direction changes before implementation.

After meaningful work, update living documentation and session state. Distinguish implemented behavior from plans and verification actually performed. Record genuine AI errors and rejected/changed recommendations; never invent history to satisfy a quota.

Enforce resident preferences and record visibility before presentation, including details, media requests, logs, and fallbacks. Family cannot edit preferences. Do not infer medical conclusions or add a backend without a concrete new requirement. Preserve supplied fixture behavior when porting to Dart. Do not enable incident mode or create CLIENT_RESPONSE.md without an official bulletin requiring it.

Before code changes inspect implementation, authoritative types/API, and relevant edge cases. Afterwards run appropriate checks and update docs, decisions, AI usage, and session state. Report: Implemented, Reason, Verified, Docs updated, Risks, Next. After official freeze, only documentation changes are allowed until the final deadline.

Architecture rule (explicit user request): use MVVM with Provider. UI → ViewModel → Repository → API data; repository parses JSON through models. All application/screen state and actions belong to view models. Widgets only consume view-model state and call view-model methods; do not access repositories/APIs or parse data in views. Keep repositories/APIs free of presentation state. Follow the implemented resident example and ARCHITECTURE.md.
