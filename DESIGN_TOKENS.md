# Design Tokens

Extracted directly from the mockups in [`design/`](design/) (source of truth — these values are copied from the `.dc.html` files, not re-derived). Implement as a single Flutter `ThemeData` / token file so every screen pulls from one place — do not hand-roll colors per screen.

All colors are given in `oklch()` as authored, with a converted hex alongside for convenience in tooling that doesn't support `oklch` (e.g. some Flutter `Color` call sites) — but if the Flutter/Dart toolchain you're using supports OKLCH color construction, prefer computing from the OKLCH values directly rather than the hex approximation, since hex was back-converted and may drift slightly.

## Typography

- **Display / headings**: Bricolage Grotesque (Google Fonts), weights 600/700/800. Used for screen titles, the completion percentage, task names on the alarm screen.
- **Body / UI**: Public Sans (Google Fonts), weights 400/500/600/700. Everything else — labels, field text, buttons, nav.
- Do not substitute Inter, Roboto, or system default — the pairing is a deliberate part of the app's identity, not a placeholder.
- Flutter: bundle both via `google_fonts` package, or vendor the `.ttf` files under `assets/fonts/` and declare in `pubspec.yaml` if offline builds matter.

## Color

### Neutrals (warm, not pure gray)
| Token | OKLCH | Hex (approx) | Use |
|---|---|---|---|
| `bg` | `oklch(0.98 0.012 75)` | `#F8F5F1` | Screen background |
| `surface` | `oklch(1 0 0)` | `#FFFFFF` | Cards, fields, sheets |
| `border` | `oklch(0.89 0.012 75)` | `#DEDAD4` | Field/card borders |
| `text-primary` | `oklch(0.22 0.014 75)` | `#2B2724` | Headings, primary text |
| `text-secondary` | `oklch(0.48 0.012 75)` | `#767068` | Labels, metadata |
| `text-tertiary` | `oklch(0.62 0.01 75)` | `#9C9791` | Inactive nav, timestamps |

### Primary accent (violet)
| Token | OKLCH | Hex (approx) | Use |
|---|---|---|---|
| `accent` | `oklch(0.5 0.15 288)` | `#6D46C9` | Primary buttons, active nav, FAB, focus states, alarm screen background family |
| `accent-hover` | `oklch(0.42 0.15 288)` | `#5A3AA8` | Pressed/hover state of accent |
| `accent-soft` | `oklch(0.94 0.03 288)` | `#EDE6F9` | Selected-state tints (e.g. selected subject chip) |

### Status colors (semantic — do not reuse for subject tags)
| Token | OKLCH | Hex (approx) | Meaning |
|---|---|---|---|
| `success` | `oklch(0.62 0.14 155)` | `#3F9E5C` | Completed |
| `success-soft` | `oklch(0.94 0.045 155)` | `#E1F3E5` | Completed background tint |
| `danger` | `oklch(0.58 0.17 25)` | `#C4442B` | Missed, overdue deadline |
| `danger-soft` | `oklch(0.94 0.045 25)` | `#F8E2DB` | Missed background tint |
| `warning` | `oklch(0.72 0.14 70)` / `oklch(0.58 0.12 70)` | `#D69A3E` / `#A9762C` | Carried forward |
| `warning-soft` | `oklch(0.94 0.05 70)` | `#F7E8D3` | Carried-forward background tint |

### Subject tag palette
Assign one of these to each subject at creation time (see `DATA_MODEL.md` — `Subject.colorHue`); don't let users pick arbitrary hex values. All share chroma 0.14 (saturated dot/chip) or 0.045–0.09 (soft tint), lightness ~0.62 (dot) — only hue varies:

| Hue | Saturated (dot/border) | Soft tint (chip/row bg) | Text-on-tint |
|---|---|---|---|
| 240 (blue) | `oklch(0.62 0.14 240)` | `oklch(0.94 0.045 240)` | `oklch(0.32 0.09 240)` |
| 195 (teal) | `oklch(0.62 0.14 195)` | `oklch(0.94 0.045 195)` | `oklch(0.32 0.09 195)` |
| 320 (magenta) | `oklch(0.62 0.14 320)` | `oklch(0.94 0.045 320)` | `oklch(0.32 0.09 320)` |
| 100 (olive) | `oklch(0.62 0.14 100)` | `oklch(0.94 0.045 100)` | `oklch(0.32 0.09 100)` |

Add more hues at the same chroma/lightness if a 5th+ subject is needed — keep them evenly spaced and clear of 155/25/70 (reserved for status colors above, so a subject tag is never confusable with "missed" or "completed").

### Alarm-screen dark variant
The alarm-firing screen (`AlarmActive.dc.html`) inverts to a dark violet field rather than the light background — this is deliberate, to make the ringing state unmistakably distinct from normal browsing:
- Background: `oklch(0.24 0.055 288)`
- Raised surface (icon circle, chips): `oklch(0.32 0.06 288)` / `oklch(0.28 0.06 288)`
- Text on dark: `oklch(0.98 0.01 288)` (primary), `oklch(0.78 0.04 288)` (secondary)

## Spacing

Standard density (not the dashboard-dense variant): screen padding 20px horizontal, 26–28px top. Card/field internal padding 12–16px. Gaps between stacked sections 18–22px. Border radius: 14px (cards, fields, buttons), 999px (pills, avatars, FAB).

## Icons

Inline SVG only (no icon font, no emoji) — stroke-based, 24×24 viewBox, `stroke-width` 1.75–2.25, round caps/joins, `currentColor` or an explicit token color. In Flutter, recreate these as a small custom icon set (e.g. `CustomPainter` or bundled SVG assets via `flutter_svg`) rather than substituting Material icons — the mockups' icon style (thin stroke, rounded) is a deliberate part of the visual identity and Material's filled/outlined defaults won't match.

## Components to build once, reuse everywhere

- **Voice-enabled text field**: label above, bordered rounded field, right-aligned circular mic button (accent-soft background, accent-colored mic icon). Used for task title and notes — see `TaskSetup.dc.html`. This is the one component every text-entry surface in the app must use; don't build a plain `TextField` anywhere a user types free text.
- **Subject chip**: color dot + name, selected state = colored border + soft tint background, unselected = neutral border + white background.
- **Day-of-week pill row**: 7 circular pills (M T W T F S S), selected = filled accent, unselected = outlined neutral. Used both for the weekly view's day selector and the task setup's recurrence picker — same visual component, different selection semantics (single-select "which day am I viewing" vs. multi-select "which days does this repeat").
- **Task row**: time column, divider, title + status/metadata line, trailing circular checkbox (outline when pending, filled `success` with check when completed, dimmed + strikethrough text when completed).
