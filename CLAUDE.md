# CLAUDE.md — build agent instructions

This file is the operating manual for whichever agent builds this app. Read `CONTEXT.md` first (why this app exists, what it does), then `DATA_MODEL.md` and `DESIGN_TOKENS.md` before writing code, then `IMPLEMENTATION_PLAN.md` for build order.

## Stack

**Flutter** (Dart), targeting iOS + Android.

| Concern | Package | Why |
|---|---|---|
| State management | `riverpod` (+ `riverpod_generator` if code-gen is set up) | Testable, no BuildContext coupling for business logic like occurrence generation and the missed-task sweep. |
| Local persistence | `drift` (sqlite) | The data model in `DATA_MODEL.md` is genuinely relational (Subject ← TaskDefinition ← TaskOccurrence, weekly summary queries filtering/grouping across them) — a document store (Hive/Isar) would fight this. |
| Local notifications / alarms | See note below — verify current best option before committing | Needs to reliably fire a full-screen, sound-playing alert even when the app is backgrounded or killed, per `CONTEXT.md`'s "the alarm is a real alarm clock, not a push notification" requirement. |
| Voice-to-text | `speech_to_text` | Standard choice for on-device STT across iOS/Android; pair with `permission_handler` for mic permission. |
| Fonts | `google_fonts` | Bricolage Grotesque + Public Sans, per `DESIGN_TOKENS.md`. |
| Icons | `flutter_svg` | The mockups' icon set is hand-drawn inline SVG (see `design/*.dc.html`) — export these as individual `.svg` assets rather than substituting Material icons. |

**Before implementing the alarm package choice**, use Context7 (per the global instructions this session already has configured) to check current documentation and community consensus for Flutter alarm-clock-style notifications — this space has shifted between `flutter_local_notifications` (full-screen intent + exact alarms on Android, `UNNotificationCategory` on iOS) and dedicated alarm packages (e.g. `alarm`) more than once, and picking wrong here is the single highest-cost mistake available in this project. Confirm whichever you pick actually supports: firing with the app killed, firing in Do Not Disturb (this needs to be an explicit user-visible tradeoff if the platform doesn't allow it — don't silently ship a "sometimes fires" alarm), and a full-screen UI on fire (not just a notification-shade entry) matching `AlarmActive.dc.html`.

## Folder structure

```
lib/
  main.dart
  app.dart                    # MaterialApp, theme, routing
  theme/                      # DESIGN_TOKENS.md as code: colors, text styles, spacing constants
  models/                     # Subject, TaskDefinition, TaskOccurrence (per DATA_MODEL.md)
  data/
    database.dart             # Drift database + tables
    subject_repository.dart
    task_repository.dart      # occurrence generation, status transitions, missed-sweep
  features/
    weekly_view/               # Main.dc.html
    task_setup/                 # TaskSetup.dc.html — includes the reusable voice text field
    alarm/                      # AlarmActive.dc.html, RescheduleSheet.dc.html, OS scheduling glue
    summary/                    # Summary.dc.html, WeeklyReport query
  widgets/                     # shared components: subject chip, day pill row, task row, voice text field
test/
```

Each `features/<x>/` folder holds that screen's widget(s), its Riverpod providers, and its tests together — don't split widgets and their state management across parallel top-level `widgets/` and `providers/` trees.

## Conventions

- Null-safety, no `dynamic` in the data layer.
- Every status transition in `DATA_MODEL.md`'s state machine goes through one place in `task_repository.dart` — don't mutate `TaskOccurrence.status` directly from UI code. This is what keeps the OS-alarm cancel/reschedule logic from getting missed on some code path.
- Widget tests for every screen in `features/`; unit tests for occurrence generation, the state machine, and the missed-sweep (these are the parts with real logic and real ways to get subtly wrong — favor testing them over testing simple display widgets).
- Match `DESIGN_TOKENS.md` values exactly (colors, spacing, radii, type). If a mockup and this doc ever disagree, the mockup (`design/*.dc.html`) is the source of truth and this doc has drifted — fix the doc, don't guess.

## Definition of done (per milestone in `IMPLEMENTATION_PLAN.md`)

- The milestone's own "Done when" criterion is met and manually verified, not just unit-tested.
- No TODO left in a code path that's supposed to be complete for that milestone.
- New models/state transitions have tests.
- `flutter analyze` clean.

## Things not to do

- Don't add a backend, account system, or sync — `CONTEXT.md` explicitly scopes this out. If a feature seems to need one, that's a signal to stop and flag it, not to build a lightweight version of it.
- Don't let carry-forward or reschedule complete without a new `alarmAt` — this is a product invariant (`DATA_MODEL.md`), not a UI suggestion; enforce it in the repository layer too, not just by disabling the Confirm button.
- Don't build calendar import/export, grades, or multi-subject-per-task — all explicitly out of scope in `CONTEXT.md`.
- Don't substitute Material default icons or a different font pairing "to move faster" — the icon set and `Bricolage Grotesque` / `Public Sans` pairing are deliberate identity choices, not placeholders.
