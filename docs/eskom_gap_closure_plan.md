# EskomSePush Gap-Closure Plan (P0 / P1 / P2)

This plan translates benchmark gaps into actionable implementation work so LightsOut can close utility and trust gaps while preserving current aesthetic improvements.

## Baseline summary

Current strengths:
- Premium visual language and theme consistency.
- Basic utility features (favorites, dark appearance toggle, map entry point, persisted preferences).

Current benchmark gaps vs EskomSePush:
- Static/hardcoded outage data and area list.
- Limited area search/management workflows.
- Alerts are UI-level preference only (not schedule-driven notifications).
- Minimal reliability context (last updated, data source status, confidence).
- Limited map utility (seeded markers, no filtering/detail overlays).

---

## P0 (must-have, immediate)

**Goal:** Establish trustworthy core utility.

### P0.1 Data layer + schedule ingestion
- Introduce typed domain models:
  - `Area`, `ScheduleWindow`, `AreaStatus`, `SourceHealth`.
- Add repository abstraction (`OutageRepository`) with:
  - local mock adapter (for now),
  - API adapter scaffold (for later integration),
  - normalization/parsing boundary.
- Replace hardcoded card data with repository-fed view models.

**Deliverables**
- `lib/models/outage_models.dart`
- `lib/repositories/outage_repository.dart`
- `lib/repositories/adapters/mock_outage_adapter.dart`
- Home page wired to repository stream/future.

### P0.2 Area search + save management
- Add search flow to add areas by name/feeder.
- Persist ordered saved areas list (not only set semantics).
- Support remove/reorder areas from saved list.

**Deliverables**
- `Saved Areas` management sheet/page.
- Preference service expanded for ordered area IDs and metadata.

### P0.3 Utility-grade status clarity
- Add per-area:
  - `Last updated` timestamp,
  - `Data source` label,
  - `Current state` (On/Off/Unknown),
  - `Next change` time (not only `next outage in Xh`).
- Add empty/error/retry states for schedule load failures.

**Deliverables**
- New status row component on area card.
- Global refresh action with loading/error feedback.

### P0.4 Notification plumbing (meaningful alerts)
- Convert alert toggle into real schedule-backed reminders:
  - `X minutes before outage starts`,
  - `power restored` event (when computable from schedule windows).
- Add per-area alert enable/disable.

**Deliverables**
- Notification scheduling service with idempotent resync.
- Alert settings screen/sheet.

### P0 acceptance criteria
- User can search and save areas, with order preserved.
- Area cards show trusted status with timestamps/source.
- Alerts trigger off real schedule windows for saved areas.
- App gracefully handles offline/error states.

---

## P1 (high-value enhancements)

**Goal:** Improve planning depth and multi-area utility.

### P1.1 24-hour timeline upgrade
- Replace simplistic bars with a timeline showing outage windows across 24h.
- Add local-time labels and tap-to-inspect windows.

### P1.2 Multi-area dashboard improvements
- Add concise overview panel:
  - areas currently off,
  - next outage across saved areas,
  - longest upcoming outage.
- Add quick actions: `refresh all`, `manage areas`, `alert settings`.

### P1.3 Map utility expansion
- Map filters (stage/area status/saved-only).
- Marker badges with current state.
- Tap marker -> area details bottom sheet.

### P1.4 Reliability instrumentation
- Track fetch success/failure rates and staleness.
- Add lightweight telemetry events for critical flows.

### P1 acceptance criteria
- Users can compare multiple saved areas at a glance.
- Timeline/map materially improves outage planning.
- Data staleness and failures are transparent and measured.

---

## P2 (polish + scale)

**Goal:** Product maturity and ecosystem readiness.

### P2.1 Personalization and quality-of-life
- Commute mode (alert for home + work areas).
- Smart suggestion of nearby/popular feeders.
- Optional compact cards and widget-friendly layouts.

### P2.2 Accessibility + i18n hardening
- Screen-reader labels for all actionable controls.
- Dynamic type verification.
- Localization scaffolding for key copy.

### P2.3 Ops and release readiness
- CI gates for lint/test/format.
- Crash and performance monitoring integration.
- Feature flags for rollout control.

### P2 acceptance criteria
- Stable release pipeline and observability are in place.
- Accessibility and localization readiness validated.

---

## Suggested implementation sequence (8-week sample)

### Weeks 1–2 (P0 foundation)
- Build repository + models + mock adapter.
- Migrate home data source from static constants to repository.

### Weeks 3–4 (P0 utility core)
- Implement search/save/reorder area management.
- Add status clarity row, timestamps, source, retry states.

### Weeks 5–6 (P0 alerts)
- Integrate schedule-backed notification service.
- Add per-area alert settings and resync lifecycle.

### Weeks 7–8 (P1 starters)
- Ship 24-hour timeline v1.
- Expand map filters and marker state chips.

---

## Definition of done for “near-EskomSePush parity”

LightsOut can be considered near parity when:
- Data is source-backed and refresh-aware, not static.
- Multi-area management is first-class (search/add/remove/reorder).
- Alerting is schedule-driven and reliable.
- Status trust signals (updated at/source/error states) are visible.
- Timeline and map both aid decision-making, not just visualization.
