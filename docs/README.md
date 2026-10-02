# Gmailoo Design System

**Version:** 0.1 (draft) · **Platform:** Flutter (iOS + Android) · **Locales:** ar-EG, en-US (RTL + LTR) · **Themes:** Light + Dark

The visual foundation for Gmailoo, an ephemeral, stress-free email client for Gen Z and Gen Alpha. This collection defines the UI color palette and fonts so design and code share one source of truth.

---

## Contents

| File | What's inside |
|---|---|
| [`colors.md`](./colors.md) | Brand color, light and dark core tokens, the five bucket colors, semantic colors, interaction states, contrast ratios, Flutter `ThemeExtension` code |
| [`typography.md`](./typography.md) | Font families and fallbacks, full type scale for Latin and Arabic, RTL rules, dynamic type, Flutter `TextTheme` code |
| [`ui-design-spec.md`](./ui-design-spec.md) | Complete frontend UI design blueprint: screen blueprints, BLoC/Cubit states, `go_router` navigation hierarchy, and offline mock test data fixtures |

---

## At a Glance

| | |
|---|---|
| **Brand color** | Gmailoo Indigo, `#4F46E5` (light) / `#9A94FF` (dark) |
| **Neutrals** | Cool, slightly blue-tinted greys; no pure black or white backgrounds |
| **Display font** | Cairo (600, 700) |
| **UI font** | IBM Plex Sans Arabic (400, 500, 600) |
| **Smart bucket colors** | Important unread = coral · Important = amber · Timetables = blue · Marketing = slate · VIP = magenta |
| **Accessibility target** | WCAG 2.2 AA; body text ≥ 4.5:1, non-text UI ≥ 3:1 |

## Design Principles

1. **Calm by default.** Neutrals carry the UI; saturated color is rationed.
2. **Quiet by design.** Marketing is the quietest color on purpose. The palette reinforces the product promise: only what matters gets loud.
3. **Arabic first.** Type sizes, line heights, and layout are set for Arabic, then tuned for Latin.
4. **Never color alone.** Every state pairs color with an icon, label, or weight change.
5. **Tokens, not hex.** Widgets read `context.colors` and `Theme.of(context).textTheme`; no hardcoded values.

---

## Suggested Repo Layout

```
lib/core/design_system/
├── colors.dart          # GmailooColors ThemeExtension (see colors.md)
├── typography.dart      # gmailooTextTheme (see typography.md)
└── theme.dart           # buildTheme(Brightness, Locale)
assets/fonts/            # Cairo + IBM Plex Sans Arabic + license files
docs/design-system/      # this folder
```

## Open Decisions

Items that are my recommendations and need your confirmation before they are treated as final:

1. **Brand color:** Indigo is proposed; confirm against any existing logo or brand direction.
2. **Font pairing:** Cairo + IBM Plex Sans Arabic is proposed; test on 2 to 3 real devices before locking in.
3. **Arabic size bump (+1 sp):** a starting point; adjust after on-device review.
4. **Digit style default:** locale default vs. Western digits for ar-EG.

## Changing the System

1. Edit the token in `colors.md` or `typography.md` first, then in code.
2. Recompute contrast for any changed color pair (target: text ≥ 4.5:1, graphics ≥ 3:1).
3. Bump the version at the top of the file and note the change in a changelog entry below.

### Changelog

- **0.1** (2 Oct 2026): initial palette and type scale.
