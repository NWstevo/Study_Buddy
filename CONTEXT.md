# Study Planner — Product Context

## What this is

A mobile app for organizing weekly study work by **subject**. It is not a general calendar or to-do app: every task belongs to a subject, tasks are usually recurring weekly routines (not one-off events), and each one carries an alarm that actually interrupts the user when it's time to work — not a passive notification badge.

## Who it's for

A student managing several subjects at once (e.g. university courses), each with its own recurring rhythm — "Calculus practice every Mon/Wed/Fri morning," "Lab report due Thursday," "Read two chapters before Friday's seminar." The core pain this app solves: routines fall apart silently. A student intends to study Biology every evening, misses two days, and has no record of it or reminder to catch up. This app makes that visible and actionable in the moment (via the alarm) and in review (via the weekly summary).

## Core user flows

1. **Set up a subject and its routine.** Create a subject (e.g. "Cell Biology"), then add tasks/routines under it: a name, which days of the week it repeats on (or a one-time occurrence), an alarm time, and optionally a deadline distinct from the alarm time (e.g. the routine is "review notes," but the real deadline is Friday's exam).
2. **The alarm fires.** At the set time, the app alarms the user (sound + full-screen alert, like a real alarm clock, not a silent push notification) naming the pending task and its subject. From that alarm the user picks one of three outcomes right there:
   - **Mark complete.**
   - **Carry forward** — the task moves to the next day, and the user must set a *new* alarm time for it before that's confirmed (it doesn't just silently re-appear).
   - **Reschedule** — same as carry-forward's "set a new time" step, but without necessarily moving to the next day (e.g. push 3 hours later today).
3. **Review progress.** A summary page reports, per week and per subject: tasks completed, missed (alarm fired, no action taken / explicitly not done), and carried forward. This is the accountability layer — it's what turns "I meant to study" into a visible record.

## Key product decisions already made

- **Subject-first organization**, not a flat task list — every task/routine has exactly one subject.
- **Routines, not just events** — the primary object is a weekly-recurring task (specific days of the week), with one-off tasks as a secondary case.
- **Deadline ≠ alarm time.** A routine's alarm is when the user is *reminded to work*; its deadline is when the underlying obligation is actually due. These can differ (daily reminders building up to a Friday deadline) and both need to be trackable.
- **The alarm is the primary interaction surface for rescheduling.** Carry-forward and reschedule are not settings-page actions — they're decisions made *at the moment the alarm rings*, because that's when the user actually knows whether they can do the task now.
- **Carrying forward always requires setting a new time.** A carried-forward task never floats without a scheduled alarm — otherwise it silently becomes invisible debt, which defeats the purpose of the app.
- **Voice-to-text on every input field.** Every place the user types (task names, notes) needs a mic-based voice input alternative. This is a usability requirement across the whole app, not a single feature — treat every text field as needing both a keyboard and a mic affordance.
- **Weekly reporting is per-subject, not just global.** The summary needs to answer "how am I doing in Biology specifically," not only "how am I doing overall."

## Out of scope (for now)

- Multi-user / collaboration / sharing subjects or tasks.
- Any backend or account system — this is a local-first, single-user app. (Revisit only if the user later asks for cross-device sync.)
- Calendar import/export (Google Calendar, iCal) — not requested; don't build it speculatively.
- Grades, GPA tracking, or any content beyond task/routine completion.

## Design reference

Visual direction and screen layouts are in [`design/`](design/) — five mockup screens (weekly view, task/routine setup, alarm-firing state, reschedule sheet, weekly summary) published as a design canvas. Token values (colors, type, spacing) extracted from those mockups are in [`DESIGN_TOKENS.md`](DESIGN_TOKENS.md) for implementing the Flutter theme. The mockups are static (not wired prototypes) — screen states and transitions are specified in prose in [`DATA_MODEL.md`](DATA_MODEL.md) and [`IMPLEMENTATION_PLAN.md`](IMPLEMENTATION_PLAN.md), not inferable from the mockups alone.
