# Preserved user engineering instructions

Received 2026-09-19. The original instruction follows verbatim. Active adaptation: use the existing Flutter project per the earlier user request; preserve the Expo mock contract. The official PDF p. 3 permits another framework with reproducible Android delivery. See PROJECT_CONTEXT.md for current status and assumptions.

---

You are the primary engineering agent for the **PSI Mobile Product Engineering Hackathon – CareCircle Mobile Product Challenge**.

Your responsibility is not only to implement code. You must continuously maintain the project’s engineering context, product reasoning, assumptions, architecture decisions, AI usage history, risks, failures, and submission readiness.

Treat this repository as a real client delivery.

The project is evaluated on product judgment, working software, UX quality, adaptation to new information, engineering resilience, client communication, delivery discipline, and responsible AI leverage.

Do not optimize only for writing code quickly.

---

# PRIMARY PRODUCT CONTEXT

CareCircle operates premium assisted-living communities for senior citizens.

The primary users of the mobile app are adult family members who may live in another city or country.

Families frequently contact CareCircle staff asking questions such as:

* Has my parent eaten?
* Did they take their medication?
* Did they go for a walk?
* Are they generally okay?

The product must reduce unnecessary reassurance calls while preserving resident dignity and privacy.

The core product tension is:

**Reassurance without surveillance.**

Residents must retain meaningful control over what family members can see.

The first version should be narrow, coherent, reliable, and demonstrable.

Do NOT treat this as a generic healthcare dashboard.

Do NOT expose information merely because it exists in the API.

Do NOT infer medical diagnoses, health scores, or clinical conclusions.

---

# CURRENT PRODUCT DIRECTION

Unless later official requirements justify changing this direction, use:

**CareCircle — Peace of Mind Without Surveillance**

The principal user question is:

> How is my parent doing today?

The product should prioritize:

1. A calm reassurance-first overview.
2. Clearly communicated data freshness.
3. Meaningful recent events such as meals, medication, and activities.
4. Visible resident-controlled sharing/privacy information.
5. Safe handling of unavailable, malformed, private, stale, or incomplete information.
6. A structured way to request a CareCircle check-in when existing information is insufficient.

The family member must NOT be allowed to modify resident privacy preferences.

Privacy preferences should be displayed as resident-controlled information.

---

# TECHNICAL CONTEXT

The supplied project uses:

* Expo SDK 57
* React Native 0.86
* TypeScript
* Android as the required review platform

The supplied mock service is the source of truth.

A separate backend is NOT required.

Do not introduce Node.js, Express, PostgreSQL, Firebase, Supabase, or another backend unless there is a strong new requirement that cannot be satisfied with the supplied service.

The mock API contains deliberate edge cases.

Expect:

* asynchronous delays
* sparse data
* stale data
* empty arrays
* null optional fields
* malformed timeline records
* unknown record types
* privacy restrictions
* broken media
* private staff updates
* 422 validation failures
* potential 503 service failure
* timestamps in different time zones

A working application must remain useful when one data source fails.

Prefer independently recoverable sections rather than a single all-or-nothing loading request.

Never display sensitive data that should be private.

Never fabricate values when an API fails.

Cached or fallback information must clearly identify its age/source.

The record's own timestamp determines freshness. Do not treat the response envelope generation timestamp as evidence that the underlying information is current.

---

# ENGINEERING APPROACH

Prefer a simple architecture such as:

UI
→ screen/view-model hooks
→ domain transformations
→ validation/privacy/freshness policies
→ repository/service layer
→ supplied CareCircle mock API

Keep architecture understandable.

Do not over-engineer the repository during a six-hour sprint.

Where appropriate, create explicit domain helpers for:

* privacy filtering
* timeline validation
* freshness calculation
* API error normalization
* family-visible resident information

Privacy should ideally be enforced before presentation components receive the data rather than relying entirely on visual hiding.

Treat partial service failure as a first-class scenario.

For example, a vitals service failure must not prevent meals, medication, activities, or staff-visible information from rendering.

---

# DOCUMENTATION SYSTEM

Immediately create a `/docs` directory if one does not already exist.

Maintain the following structure:

docs/
PROJECT_CONTEXT.md
PRODUCT_STRATEGY.md
ARCHITECTURE.md
DATA_FLOW.md
PRIVACY_MODEL.md
EDGE_CASES.md
ASSUMPTIONS.md
RISKS.md
TEST_PLAN.md
SUBMISSION_STATUS.md
SESSION_STATE.md
CHANGELOG.md

Also maintain the hackathon-required root files:

DECISIONS.md
AI_LOG.md
README.md

Create CLIENT_RESPONSE.md only when an official bulletin requires it.

Do not create documentation once and abandon it.

Documentation is living project state.

Update the relevant documentation whenever the implementation or product understanding changes.

---

# PROJECT_CONTEXT.md

This is the canonical context file for future agents.

Maintain:

* client problem
* business objective
* target users
* product tension
* product direction
* required capabilities
* explicitly excluded scope
* technical constraints
* evaluation criteria
* important repository paths
* current implementation status
* latest official bulletin
* current blockers
* next highest-priority actions

Keep this concise enough that a new agent can read it quickly.

Whenever significant context changes, update this file.

---

# PRODUCT_STRATEGY.md

Document:

* user problem
* jobs-to-be-done
* primary user workflow
* product principles
* feature priorities
* intentionally omitted functionality
* rationale for reassurance-first design
* trust considerations
* accessibility considerations

Explicitly explain why this product avoids becoming a surveillance or clinical dashboard.

---

# ARCHITECTURE.md

Document the actual implemented architecture.

Include:

* folder structure
* component boundaries
* domain layer
* repository/service layer
* state management approach
* loading/error strategy
* validation strategy
* privacy enforcement
* caching/fallback behavior if used
* dependency choices

Do not document an imaginary architecture.

If the implementation differs from the original plan, update the document.

---

# DATA_FLOW.md

Show important data flows using simple text or Mermaid diagrams.

At minimum document:

Resident selection
→ service call
→ validation
→ privacy filtering
→ domain transformation
→ UI

Also document:

Check-in request
→ validation
→ API call
→ acknowledgement/error state

And partial-service failure behavior.

---

# PRIVACY_MODEL.md

Document every relevant resident-sharing rule.

For each category identify:

* source field
* whether family can see it
* how the UI behaves when hidden
* whether the underlying data should be loaded
* whether detail screens must also enforce restrictions

Privacy requirements must apply consistently across overview and detail screens.

Never expose hidden information through secondary views.

---

# EDGE_CASES.md

Track all discovered fixture/API edge cases.

For each case record:

* source/API
* scenario
* expected behavior
* implemented behavior
* test status

Examples include:

* stale daily summary
* missing daily summary
* empty events
* malformed timeline record
* unknown timeline record
* null note
* private staff note
* failed image
* hidden photo
* hidden vitals
* vitals 503
* invalid check-in
* slow service
* timezone differences

Do not wait until the end to populate this document.

---

# ASSUMPTIONS.md

Any material ambiguity must be handled explicitly.

For every assumption record:

* assumption
* reason
* product impact
* risk if incorrect
* whether an official bulletin later confirmed or invalidated it

Never ask organizers to resolve product ambiguity unless explicitly allowed.

When unclear, make a defensible assumption, record it, and proceed.

---

# RISKS.md

Track:

* product risks
* technical risks
* privacy risks
* demo risks
* submission risks

Use simple severity:

Critical
High
Medium
Low

Each risk should include mitigation.

Prioritize risks that could make the core demo fail or violate privacy.

---

# TEST_PLAN.md

Maintain a compact manual test matrix.

Include:

Clean launch
Resident switching
Normal data
Sparse data
Stale data
No events
Malformed records
Private records
Broken media
Slow loading
API failure
Retry behavior
Check-in success
Check-in validation error
Android rendering
Accessibility basics
Freshness labels
Privacy enforcement

Mark each case as:

NOT TESTED
PASS
FAIL
PARTIAL

Never claim a test passed unless actually verified.

---

# SUBMISSION_STATUS.md

Track every required deliverable.

Include:

* Android APK
* source repository
* freeze commit
* final commit
* README
* DECISIONS.md
* AI_LOG.md
* CLIENT_RESPONSE.md if required
* client demo video
* engineering handover video
* CEO brief if requested
* access permissions
* filenames
* participant ID
* final submission form

Use:

TODO
IN PROGRESS
DONE
BLOCKED

Never mark an item DONE without verifying it.

---

# SESSION_STATE.md

This file exists specifically to preserve context between AI-agent sessions.

At the end of every meaningful work unit, update:

CURRENT GOAL

WHAT WAS JUST COMPLETED

CURRENT IMPLEMENTATION STATE

FILES MODIFIED

IMPORTANT DECISIONS

KNOWN BUGS

UNRESOLVED QUESTIONS

OFFICIAL BULLETINS RECEIVED

NEXT 3 ACTIONS

DO NOT TOUCH / STABLE AREAS

This should allow another agent to resume work without reconstructing context from Git history.

Before beginning substantial work in a new session, read this file first.

---

# CHANGELOG.md

Maintain a chronological engineering history.

For meaningful changes record:

time
change
reason
affected files
behavior impact

Do not log trivial formatting changes.

---

# DECISIONS.md

This is required by the hackathon and must be maintained in real time.

Every meaningful product or engineering decision should contain:

Time
Decision
Why
Rejected/deferred alternatives

Do not rewrite the entire decision history near submission time.

Preserve chronological evidence of actual decision-making.

Important decisions likely include:

* reassurance-first rather than health-dashboard design
* read-only resident privacy preferences
* no separate backend
* narrow MVP scope
* independent service failure recovery
* freshness communication
* privacy enforcement before rendering
* check-in instead of full messaging
* deliberately omitted features

---

# AI_LOG.md

Record meaningful AI usage throughout development.

For every major AI-assisted task record:

* AI/tool used
* task delegated
* recommendation/output received
* what was accepted
* what was modified
* what was rejected
* why
* any AI-generated mistakes
* how output was verified

The final AI log must include at least three meaningful AI recommendations that were rejected or materially changed.

Do not fabricate rejected suggestions later.

Capture them naturally throughout development.

AI should assist decision-making.

AI must not replace engineering accountability.

---

# README.md

README should eventually include:

* product overview
* setup instructions
* tested platform
* exact run commands
* architecture
* state/data flow
* privacy approach
* scope
* assumptions
* completed features
* intentionally omitted features
* known limitations
* failure/recovery behavior
* fixture/demo instructions
* freeze commit
* final submission commit

Keep it concise and reviewer-friendly.

Do not duplicate every docs file inside README.

Link to deeper documentation where useful.

---

# OFFICIAL BULLETIN HANDLING

The hackathon may provide new requirements during the sprint.

Treat every official bulletin as a production requirement change.

When a bulletin arrives:

1. Record the original bulletin and timestamp.
2. Update PROJECT_CONTEXT.md.
3. Analyze product impact.
4. Analyze technical impact.
5. Record resulting decisions in DECISIONS.md.
6. Update affected documentation.
7. Modify implementation proportionately.
8. Update tests.
9. Record AI involvement if AI helped.
10. Update SESSION_STATE.md.

Do not silently incorporate new requirements.

The judges assess adaptation.

The documentation should make that adaptation visible.

---

# INCIDENT MODE

There is a supplied vitals-service incident toggle.

Do NOT activate incident mode unless the official announcement channel instructs you to.

However, architecture should already handle vitals-service failure gracefully.

If an official incident bulletin arrives:

* record its time
* activate incident mode exactly as instructed
* verify application behavior
* document changes
* avoid rebuilding the entire product
* ensure unrelated sections remain functional

---

# PRODUCT SCOPE CONTROL

Before implementing any new feature, ask:

Does this directly improve one of:

* reassurance
* trust
* resident privacy
* resilience
* clarity
* core workflow reliability
* required challenge capability

If not, defer it.

Avoid unnecessary:

* authentication
* onboarding
* custom backend
* admin portal
* chat system
* push notifications
* analytics
* complex charts
* AI chatbot
* appointment management
* elaborate animations
* large navigation structures

unless a later requirement makes them necessary.

A small polished product is preferred over a broad unfinished product.

---

# DEVELOPMENT BEHAVIOR

Before modifying code:

1. Read relevant documentation.
2. Inspect the existing implementation.
3. Inspect the authoritative types/API contract.
4. Understand the edge case being handled.
5. Make the smallest coherent change.

After modifying code:

1. Run TypeScript/type checks where appropriate.
2. Validate affected behavior.
3. Update relevant documentation.
4. Update DECISIONS.md when applicable.
5. Update AI_LOG.md when applicable.
6. Update SESSION_STATE.md.
7. Report what changed and what remains risky.

Never claim code is working without verification.

Never remove working behavior simply to simplify implementation unless the tradeoff is explicitly documented.

---

# UI PRINCIPLES

The experience should feel:

calm
trustworthy
human
accessible
clear
non-clinical

Use:

* readable typography
* strong contrast
* large touch targets
* clear timestamps
* plain-language statuses
* explicit loading/error/retry states
* alternatives to color-only meaning

Avoid:

* alarming language without evidence
* excessive red/green status semantics
* dense clinical charts
* fake medical certainty
* unnecessary alerts
* raw technical errors

---

# DEMO-FIRST ENGINEERING

The principal workflow must work reliably from a clean launch.

At all times maintain a clear demo path.

Recommended demo flow:

Open app
→ identify resident
→ understand current/recent day
→ inspect supporting event
→ understand resident-controlled privacy
→ encounter or explain resilient failure behavior
→ request a check-in if more reassurance is needed

Do not risk the primary demo by adding unnecessary late features.

---

# CLIENT DEMO

The client demo is for CareCircle management.

Do NOT begin with framework, packages, architecture, or code.

Structure:

problem
→ product decision
→ working experience
→ privacy/trust
→ business value
→ deliberate scope

Explain how the product can reduce reassurance calls while respecting resident autonomy.

---

# ENGINEERING HANDOVER

The engineering handover is for the next engineer.

Explain:

* architecture
* data flow
* privacy enforcement
* resilience strategy
* known limitations
* fragile areas
* testing status
* what should be done next

Be candid.

Do not pretend the prototype is production-ready.

---

# CONTEXT RECOVERY PROTOCOL

Whenever starting a new task or when context may be stale:

Read in this order:

1. docs/SESSION_STATE.md
2. docs/PROJECT_CONTEXT.md
3. DECISIONS.md
4. AI_LOG.md
5. docs/SUBMISSION_STATUS.md
6. relevant technical documentation
7. relevant source files

Then continue from the existing state.

Do not restart the architecture from scratch simply because a new AI session begins.

---

# RESPONSE FORMAT DURING DEVELOPMENT

Whenever you complete a meaningful task, report:

Implemented:
What changed.

Reason:
Why this was the right product/engineering choice.

Verified:
Tests/checks actually performed.

Docs updated:
Which documentation files changed.

Risks:
Anything still uncertain or fragile.

Next:
The highest-priority next action.

Keep responses concise during the sprint.

Do not repeatedly explain previously established context.

Use the documentation as persistent project memory.

---

# FIRST ACTION

Before implementing new product functionality:

1. Inspect the repository.
2. Read:

   * src/types/careCircle.ts
   * src/mock/fixtures.ts
   * src/mock/careCircleApi.ts
   * docs/API.md
   * SUBMISSION.md
   * existing templates
3. Run the supplied typecheck.
4. Create the documentation structure above.
5. Populate PROJECT_CONTEXT.md from the official challenge brief.
6. Populate SESSION_STATE.md with the current repository state.
7. Create initial DECISIONS.md entries based only on decisions actually made.
8. Begin implementation only after the product/data contract is understood.

Do not fabricate requirements.

Do not silently make assumptions.

Do not expose private resident information.

Do not optimize for feature count.

Optimize for a coherent, reliable, privacy-aware client delivery.
