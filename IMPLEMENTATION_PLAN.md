# Implementation Plan

A build agent working through this repo autonomously should tackle milestones in order — each one produces something runnable/testable before moving on, and later milestones depend on earlier ones (notifications need occurrences to exist; summary needs occurrences to have real status transitions).

## M1 — Project scaffold + data layer
- Flutter project init, folder structure and dependencies per `CLAUDE.md`.
- Implement `Subject`, `TaskDefinition`, `TaskOccurrence` models and local persistence (per `DATA_MODEL.md`).
- Occurrence generation logic for `weekly` and `once` tasks, with tests covering: a weekly task generates the right occurrences for its selected weekdays; editing a definition doesn't retroactively change existing occurrences; archiving stops future generation.
- **Done when:** you can create a subject and a weekly task definition in a test/debug harness and see the correct set of future `TaskOccurrence` rows.

## M2 — Weekly view (read + complete)
- Build the "This Week" screen per `Main.dc.html` / `DESIGN_TOKENS.md`: week navigation, day selector, tasks grouped by subject, tap-to-complete.
- Wire tap-to-complete to the `pending → completed` transition in `DATA_MODEL.md`.
- **Done when:** the weekly view reflects real occurrence data end-to-end, and marking a task complete persists and updates the UI.

## M3 — Task/routine creation, with voice input
- Build the "New Task" screen per `TaskSetup.dc.html`: subject picker (+ inline "new subject" creation), the voice-enabled text field component (title, notes), frequency toggle, weekday picker, alarm time picker, deadline picker.
- Integrate speech-to-text (package choice in `CLAUDE.md`) behind the mic button on every text field — this is a cross-cutting requirement, not a per-screen one; build the component once (see `DESIGN_TOKENS.md` → "Components to build once, reuse everywhere") and reuse it anywhere text is entered, including any field added later.
- Handle the mic permission prompt and the "voice recognition unavailable" fallback (still usable via keyboard) gracefully — don't let a denied permission block the field.
- **Done when:** a new subject/task can be created entirely by voice, entirely by keyboard, or mixed, and it shows up correctly in the weekly view from M2.

## M4 — Alarms: scheduling, firing, and the three outcomes
- Integrate local notifications/alarms (package choice in `CLAUDE.md`) scheduled from each `TaskOccurrence.alarmAt`.
- Build the alarm-firing screen per `AlarmActive.dc.html` and the reschedule bottom sheet per `RescheduleSheet.dc.html`.
- Wire all three outcomes per the state machine in `DATA_MODEL.md`: Mark Complete, Carry Forward (spawns new occurrence, requires new time via the reschedule sheet), Reschedule (mutates current occurrence, requires new time via the same sheet).
- Implement OS alarm cancel+reschedule whenever `alarmAt` changes — verify no duplicate/stale alarms fire after a reschedule.
- Implement the "missed" sweep (elapsed `pending` occurrences → `missed`) as an app-open check at minimum; a background periodic check if the platform allows it reliably.
- **Done when:** an alarm actually fires (device silenced/backgrounded included) showing the right task name and subject, and all three actions correctly update occurrence state and the weekly view.

## M5 — Summary / progress page
- Build the summary screen per `Summary.dc.html`: completion ring, completed/missed/carried-forward stat tiles, day-by-day strip, per-subject progress bars.
- Implement the `WeeklyReport` derived query from `DATA_MODEL.md` (computed, not stored) with a week-selector.
- **Done when:** the summary accurately reflects occurrence data generated/mutated by M2–M4, including carried-forward chains counted sensibly (a task carried twice shouldn't double-count as two separate misses and two separate completions).

## M6 — Polish pass
- Subject archive/edit flows (not mocked in the design canvas — use the existing visual language: chips, soft-tint states).
- Empty states (no tasks today, no subjects yet, first-run).
- Accessibility: verify voice-input fallback, tap target sizes (44×44pt minimum — already reflected in the mockups' pill/button sizing), color contrast on the status colors in `DESIGN_TOKENS.md`.
- Real device testing of alarm reliability across app-killed / background / do-not-disturb states — this is the highest-risk area of the whole app and deserves explicit manual verification, not just unit tests of the scheduling code.

## Explicitly not in this plan
Anything under "Out of scope" in `CONTEXT.md` (multi-user, backend/sync, calendar import/export, grades). If a milestone above seems to need one of these to be "done properly," that's a sign to flag it back rather than build it — the product intentionally excludes it for now.
