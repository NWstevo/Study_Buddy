# Data Model

Local-first, single-user. No backend — persist with an on-device database (see [`CLAUDE.md`](CLAUDE.md) for the specific package choice). This document defines entities and the recurrence/carry-forward logic precisely enough to implement without further product decisions; treat any gap you find here as something to flag, not to silently invent.

## Entities

### Subject
| Field | Type | Notes |
|---|---|---|
| `id` | uuid | |
| `name` | string | e.g. "Cell Biology" |
| `colorHue` | int (0–360) | Drives the subject's tag color everywhere (task rows, chips, summary bars). Pick from the palette in `DESIGN_TOKENS.md` §Subject tag palette when the user creates a subject; don't let them free-pick an arbitrary hex — that's how the tag system drifts. |
| `createdAt` | datetime | |
| `archivedAt` | datetime? | Soft-delete: archived subjects drop out of pickers and the weekly view but stay in historical summary data. Never hard-delete a subject that has any task occurrences — it would corrupt past reports. |

### TaskDefinition
The *template* for a task or routine — what the user edits on the "New Task" screen.

| Field | Type | Notes |
|---|---|---|
| `id` | uuid | |
| `subjectId` | uuid (FK → Subject) | |
| `title` | string | Entered via keyboard or voice-to-text — store as plain text either way; the input method isn't persisted. |
| `notes` | string? | Same voice-to-text handling as `title`. |
| `frequency` | enum: `once` \| `weekly` | |
| `weekdays` | `Set<Weekday>` | Only meaningful when `frequency == weekly`. 1–7 days selected (Mon–Sun). Empty set is invalid — reject it in the UI, don't persist it. |
| `alarmTime` | time (HH:mm) | The time-of-day the alarm fires on each active day. |
| `deadline` | date? | Optional and **independent of `alarmTime`** — see CONTEXT.md: the deadline is when the obligation is actually due, which may be later than any individual alarm occurrence (e.g. daily alarms building toward a Friday deadline). |
| `createdAt` | datetime | |
| `archivedAt` | datetime? | Soft-delete, same reasoning as Subject. Archiving a definition stops generating future occurrences but does not touch past ones. |

### TaskOccurrence
A single concrete instance of a task on a specific date — this is what the weekly view, the alarm, and the summary all actually operate on. Generated from `TaskDefinition` (see "Occurrence generation" below), but **mutable and independent** once created — editing the parent definition does not retroactively change occurrences that already exist, only future generation.

| Field | Type | Notes |
|---|---|---|
| `id` | uuid | |
| `taskDefinitionId` | uuid (FK) | |
| `subjectId` | uuid (FK, denormalized) | Copied at generation time so historical reports stay correct even if a task is reassigned to a different subject later. |
| `scheduledDate` | date | The day this occurrence is "for." |
| `alarmAt` | datetime | Date + time the alarm fires. Starts as `scheduledDate + parent.alarmTime`; changes when the occurrence is rescheduled or carried forward (see below). |
| `deadline` | date? | Copied from the parent at generation time. |
| `status` | enum: `pending` \| `completed` \| `missed` \| `carried_forward` | See state machine below. |
| `completedAt` | datetime? | Set when `status → completed`. |
| `carriedFromOccurrenceId` | uuid? | Set when this occurrence was created *by* carrying another one forward — links the chain so history is traceable (task A on Tue carried to Wed carried to Thu is one visible thread, not three unrelated rows). |
| `carryCount` | int | How many times this thread has been carried forward. Not a hard cap in v1, but surface it in the UI (e.g. "carried 3 times") — repeated carrying is the signal the product exists to surface. |

## Occurrence generation

- For `frequency: once` tasks: exactly one `TaskOccurrence` is created immediately on save, `scheduledDate` = the date implied by the task setup.
- For `frequency: weekly` tasks: generate occurrences rolling forward (e.g. maintain 2–4 weeks of future occurrences at any time, topped up on app open or a background check) for each selected weekday. Don't pre-generate indefinitely into the future — that's unbounded storage for no benefit.
- Editing a `TaskDefinition`'s `weekdays` or `alarmTime` affects only occurrences generated *after* the edit. Existing `pending` occurrences keep whatever was true when they were generated, unless the user explicitly reschedules that individual occurrence.

## Occurrence status state machine

```
pending ──(user marks done, any time)──────────────► completed
pending ──(alarm fires, user taps Carry Forward)────► carried_forward
                                                        └─ spawns a new `pending` occurrence
                                                           (carriedFromOccurrenceId = this one,
                                                            scheduledDate/alarmAt = the new time
                                                            the user set — required, never optional)
pending ──(alarm fires, user taps Reschedule)───────► stays `pending`
                                                        (alarmAt updated to the new time;
                                                         scheduledDate updates too if the new
                                                         time crosses midnight)
pending ──(alarm fires and is dismissed/ignored,
           no action taken by end of scheduledDate)──► missed
```

Notes:
- **Carry Forward vs. Reschedule** are distinct actions with the same UI mechanic (both require picking a new time — see the "Reschedule sheet" mockup) but different data effects: Carry Forward closes out the current occurrence as `carried_forward` and creates a new one; Reschedule mutates the current occurrence in place. Carry Forward is the "move to a different day" case; Reschedule is "same obligation, just later." Follow CONTEXT.md's rule either way: **never leave a carried/rescheduled task without a concrete new `alarmAt`** — the picker's "Confirm" action is required, there's no "carry forward with no new time" path.
- A `missed` determination needs a sweep (e.g. on app open, or a lightweight background task): any `pending` occurrence whose `scheduledDate` has fully elapsed and was never acted on becomes `missed`. This is a batch job, not something decided at alarm-fire time.
- `completed` is reachable directly from the weekly view (tapping the checkbox on a task row) without ever going through the alarm — the alarm is *one* path to completion, not the only one.

## WeeklyReport (derived, not stored)

Computed on demand from `TaskOccurrence` rows for a given week + optional subject filter:
- `completed`, `missed`, `carriedForward` counts (and the completion % shown as the ring on the Summary screen).
- Per-subject breakdown: same three counts scoped to `subjectId`.
- Day-by-day breakdown: per weekday, the dominant/worst status for that day (drives the colored bar-height strip on the Summary screen).

Don't persist a separate `WeeklyReport` table in v1 — it's a query over `TaskOccurrence`, and persisting it risks drifting out of sync with the source data. Revisit only if the query becomes a measured performance problem.

## Alarm delivery

An `alarmAt` on a `TaskOccurrence` needs a real OS-level scheduled notification/alarm (see `CLAUDE.md` for the package), not an in-app timer — the app will not always be foregrounded when the alarm should fire. When an occurrence's `alarmAt` changes (reschedule, carry-forward, or the definition-level edit path), the previously-scheduled OS alarm for that occurrence must be cancelled and a new one scheduled — never leave a stale alarm firing at the old time alongside the new one.
