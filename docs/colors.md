# Gmailoo Design System: Color Palette

**Version:** 0.1 (draft) · **Themes:** Light + Dark · **Standard:** WCAG 2.2 AA

All contrast ratios in this file were computed with the WCAG relative-luminance formula, not estimated by eye. Re-run them if you change any hex value.

---

## 1. Color Principles

1. **Calm by default.** Neutrals do 90% of the work. Saturated color is a scarce resource.
2. **One saturated signal per screen.** Only *Important unread* and the primary action get a strong color. *Marketing* is deliberately the quietest color in the app, because it is the noise we are filtering out.
3. **Color is never the only signal.** Every bucket pairs its color with an icon and a text label (color-blind users, and users in bright sunlight).
4. **No pure black or pure white backgrounds.** Slightly tinted neutrals feel softer and reduce halation, especially in dark mode.
5. **Both themes are first-class.** Dark mode is not an inverted light mode; it has its own tuned values.

---

## 2. Brand

| Name | Light | Dark | Use |
|---|---|---|---|
| **Gmailoo Indigo** | `#4F46E5` | `#9A94FF` | Logo, primary buttons, links, selected tab |

Indigo was chosen to sit far away from Gmail red (so we don't read as a Gmail skin) while still feeling calm and "night-sky". *(This is an analysis-based recommendation; confirm with your brand direction.)*

---

## 3. Core Tokens

### Light theme

| Token | Role | Hex | Contrast |
|---|---|---|---|
| `bg` | App background | `#F7F7FB` | — |
| `surface` | Cards, sheets, app bars | `#FFFFFF` | — |
| `surfaceVariant` | Chips, inputs, grouped rows | `#EEF0F7` | — |
| `outline` | Dividers (decorative only) | `#D5D9E6` | 1.4:1 |
| `outlineStrong` | Input borders, focus rings, icons | `#7C829E` | 3.8:1 |
| `onSurface` | Primary text | `#14162B` | 17.8:1 |
| `onSurfaceMuted` | Secondary text (snippets, metadata) | `#4A4F6A` | 8.0:1 |
| `onSurfaceSubtle` | Tertiary text (timestamps, hints) | `#646A86` | 5.3:1 |
| `primary` | Brand, primary buttons, links | `#4F46E5` | 6.3:1 |
| `onPrimary` | Text/icons on primary | `#FFFFFF` | 6.3:1 |
| `primaryContainer` | Selected states, Zen Day hero | `#E8E7FD` | — |
| `onPrimaryContainer` | Text on primaryContainer | `#2A2486` | 10.2:1 |

*Contrast is measured against `surface` (or against `primary` / `primaryContainer` for the `on*` tokens).*


### Dark theme

| Token | Role | Hex | Contrast |
|---|---|---|---|
| `bg` | App background | `#0E1020` | — |
| `surface` | Cards, sheets, app bars | `#171A2E` | — |
| `surfaceVariant` | Chips, inputs, grouped rows | `#20243D` | — |
| `outline` | Dividers (decorative only) | `#343A5C` | 1.6:1 |
| `outlineStrong` | Input borders, focus rings, icons | `#7479A0` | 4.1:1 |
| `onSurface` | Primary text | `#F1F2FA` | 15.4:1 |
| `onSurfaceMuted` | Secondary text (snippets, metadata) | `#B4B9D6` | 8.9:1 |
| `onSurfaceSubtle` | Tertiary text (timestamps, hints) | `#9298BA` | 6.1:1 |
| `primary` | Brand, primary buttons, links | `#9A94FF` | 6.6:1 |
| `onPrimary` | Text/icons on primary | `#14123F` | 6.8:1 |
| `primaryContainer` | Selected states, Zen Day hero | `#2D2A6E` | — |
| `onPrimaryContainer` | Text on primaryContainer | `#E3E1FF` | 9.9:1 |

*Contrast is measured against `surface` (or against `primary` / `primaryContainer` for the `on*` tokens).*


---

## 4. Bucket Colors

Each of the four smart buckets, plus VIP, has a trio of tokens:

- **`accent`**: for the leading bar, dot, and icon only (graphical objects need ≥ 3:1).
- **`container`**: the chip / row-tint background.
- **`onContainer`**: text and icons placed on the container (≥ 7:1 in both themes).

> **Rule:** never use `accent` as *text* color. Several accents are below 4.5:1 by design. Put text in `onContainer` on `container`, or in `onSurface`.

| Bucket | Icon (Material Symbols Rounded) | Character |
|---|---|---|
| Important unread | `mark_email_unread` | Warm coral: the only "loud" color in the inbox |
| Important | `priority_high` | Amber: noticeable, not alarming |
| Timetables | `calendar_month` | Calm blue: informational, trustworthy |
| Marketing | `sell` | Cool slate: intentionally quiet |
| VIP | `workspace_premium` | Magenta: personal, distinct from the brand indigo |

### Light theme

| Bucket | `accent` | `container` | `onContainer` | Text on container | Accent on `surface` |
|---|---|---|---|---|---|
| **Important unread** | `#E5484D` | `#FDECEC` | `#8C1D21` | 7.9:1 | 3.9:1 |
| **Important** | `#B86E00` | `#FFF3D6` | `#6B4300` | 7.8:1 | 4.0:1 |
| **Timetables** | `#2F7DE1` | `#E5F0FF` | `#0F3D7A` | 9.3:1 | 4.1:1 |
| **Marketing** | `#7C829E` | `#EEF0F5` | `#4A4F6A` | 7.0:1 | 3.8:1 |
| **VIP** | `#D6409F` | `#FDE7F4` | `#7A1B55` | 8.5:1 | 4.1:1 |


### Dark theme

| Bucket | `accent` | `container` | `onContainer` | Text on container | Accent on `surface` |
|---|---|---|---|---|---|
| **Important unread** | `#FF6B70` | `#3D1A1D` | `#FFB9BB` | 9.5:1 | 6.2:1 |
| **Important** | `#FFB84D` | `#3A2A0B` | `#FFD99A` | 10.3:1 | 10.0:1 |
| **Timetables** | `#5AA0FF` | `#14284A` | `#B5D4FF` | 9.7:1 | 6.5:1 |
| **Marketing** | `#9298BA` | `#1E2136` | `#B4B9D6` | 8.2:1 | 6.1:1 |
| **VIP** | `#F06FBF` | `#3D1530` | `#FFB3E0` | 9.5:1 | 6.3:1 |


### Unread emphasis

Unread state is **not** color alone: subject and sender go to weight 600, and a 8 dp `accent` dot appears at the leading edge. Read rows drop to weight 400 and `onSurfaceMuted`.

---

## 5. Semantic Colors

### Light theme

| Token | Role | Hex | On `surface` | Pair |
|---|---|---|---|---|
| `success` | Sent, synced, success | `#0B7A5C` | 5.3:1 | — |
| `error` | Failed send, auth errors | `#C62828` | 5.6:1 | — |
| `warning` | Offline, schedule at risk | `#9A5B00` | 5.4:1 | — |
| `info` | Neutral tips | `#1F6FD1` | 4.9:1 | — |
| `onError` | Text on `error` fill | `#FFFFFF` | 5.6:1 | on `error` |


### Dark theme

| Token | Role | Hex | On `surface` | Pair |
|---|---|---|---|---|
| `success` | Sent, synced, success | `#3DD6A8` | 9.3:1 | — |
| `error` | Failed send, auth errors | `#FF8A80` | 7.5:1 | — |
| `warning` | Offline, schedule at risk | `#FFB84D` | 10.0:1 | — |
| `info` | Neutral tips | `#7DB2FF` | 7.9:1 | — |
| `onError` | Text on `error` fill | `#3B0A07` | 7.5:1 | on `error` |


Use semantic colors for system feedback only (snackbars, send status, banners). They are never used for the bucket system.

---

## 6. Interaction States

Apply state layers on top of any surface using `onSurface` (or `onPrimary` on filled primary buttons):

| State | Overlay opacity |
|---|---|
| Hover (pointer / tablet) | 8% |
| Focus (keyboard / switch access) | 12% + 2 dp `primary` focus ring |
| Pressed | 12% |
| Dragged | 16% |
| Disabled content | 38% (container 12%) |

---

## 7. Elevation

- **Light:** use soft shadows (`onSurface` at 8%, blur 16, y 4) for sheets and FABs only. Cards are flat with an `outline` border.
- **Dark:** shadows vanish on dark backgrounds. Express elevation by stepping surface tone: `bg` → `surface` → `surfaceVariant`.

---

## 8. Accessibility Checklist

- Body text on any surface: **≥ 4.5:1** (all `onSurface*` tokens pass on `bg`, `surface`, and `surfaceVariant` in both themes).
- Non-text UI (input borders, icons, bucket accents, focus rings): **≥ 3:1**. Use `outlineStrong`, never `outline`, for anything the user must perceive.
- Test bucket distinctions with a color-blindness simulator (deuteranopia and protanopia). The icon + label pairing is the fallback.
- Support Android/iOS **high-contrast** settings by switching `outline` → `outlineStrong` for dividers.

---

## 9. Flutter Implementation

Tokens live in `core/design_system/` and are exposed through a `ThemeExtension`, so widgets read `context.colors` instead of hardcoding hex.

```dart
// lib/core/design_system/colors.dart
import 'package:flutter/material.dart';

@immutable
class BucketColor {
  const BucketColor({required this.accent, required this.container, required this.onContainer});
  final Color accent;
  final Color container;
  final Color onContainer;
}

@immutable
class BucketPalette {
  const BucketPalette({
    required this.unread,
    required this.important,
    required this.timetables,
    required this.marketing,
    required this.vip,
  });
  final BucketColor unread;
  final BucketColor important;
  final BucketColor timetables;
  final BucketColor marketing;
  final BucketColor vip;
}

@immutable
class GmailooColors extends ThemeExtension<GmailooColors> {
  const GmailooColors({
    required this.bg,
    required this.surface,
    required this.surfaceVariant,
    required this.outline,
    required this.outlineStrong,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.onSurfaceSubtle,
    required this.primary,
    required this.onPrimary,
    required this.primaryContainer,
    required this.onPrimaryContainer,
    required this.success,
    required this.error,
    required this.onError,
    required this.warning,
    required this.info,
    required this.buckets,
  });

  final Color bg, surface, surfaceVariant, outline, outlineStrong;
  final Color onSurface, onSurfaceMuted, onSurfaceSubtle;
  final Color primary, onPrimary, primaryContainer, onPrimaryContainer;
  final Color success, error, onError, warning, info;
  final BucketPalette buckets;

  static const light = GmailooColors(
    bg: Color(0xFFF7F7FB),
    surface: Color(0xFFFFFFFF),
    surfaceVariant: Color(0xFFEEF0F7),
    outline: Color(0xFFD5D9E6),
    outlineStrong: Color(0xFF7C829E),
    onSurface: Color(0xFF14162B),
    onSurfaceMuted: Color(0xFF4A4F6A),
    onSurfaceSubtle: Color(0xFF646A86),
    primary: Color(0xFF4F46E5),
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFFE8E7FD),
    onPrimaryContainer: Color(0xFF2A2486),
    success: Color(0xFF0B7A5C),
    error: Color(0xFFC62828),
    onError: Color(0xFFFFFFFF),
    warning: Color(0xFF9A5B00),
    info: Color(0xFF1F6FD1),
    buckets: BucketPalette(
      unread: BucketColor(accent: Color(0xFFE5484D), container: Color(0xFFFDECEC), onContainer: Color(0xFF8C1D21)),
      important: BucketColor(accent: Color(0xFFB86E00), container: Color(0xFFFFF3D6), onContainer: Color(0xFF6B4300)),
      timetables: BucketColor(accent: Color(0xFF2F7DE1), container: Color(0xFFE5F0FF), onContainer: Color(0xFF0F3D7A)),
      marketing: BucketColor(accent: Color(0xFF7C829E), container: Color(0xFFEEF0F5), onContainer: Color(0xFF4A4F6A)),
      vip: BucketColor(accent: Color(0xFFD6409F), container: Color(0xFFFDE7F4), onContainer: Color(0xFF7A1B55)),
    ),
  );

  static const dark = GmailooColors(
    bg: Color(0xFF0E1020),
    surface: Color(0xFF171A2E),
    surfaceVariant: Color(0xFF20243D),
    outline: Color(0xFF343A5C),
    outlineStrong: Color(0xFF7479A0),
    onSurface: Color(0xFFF1F2FA),
    onSurfaceMuted: Color(0xFFB4B9D6),
    onSurfaceSubtle: Color(0xFF9298BA),
    primary: Color(0xFF9A94FF),
    onPrimary: Color(0xFF14123F),
    primaryContainer: Color(0xFF2D2A6E),
    onPrimaryContainer: Color(0xFFE3E1FF),
    success: Color(0xFF3DD6A8),
    error: Color(0xFFFF8A80),
    onError: Color(0xFF3B0A07),
    warning: Color(0xFFFFB84D),
    info: Color(0xFF7DB2FF),
    buckets: BucketPalette(
      unread: BucketColor(accent: Color(0xFFFF6B70), container: Color(0xFF3D1A1D), onContainer: Color(0xFFFFB9BB)),
      important: BucketColor(accent: Color(0xFFFFB84D), container: Color(0xFF3A2A0B), onContainer: Color(0xFFFFD99A)),
      timetables: BucketColor(accent: Color(0xFF5AA0FF), container: Color(0xFF14284A), onContainer: Color(0xFFB5D4FF)),
      marketing: BucketColor(accent: Color(0xFF9298BA), container: Color(0xFF1E2136), onContainer: Color(0xFFB4B9D6)),
      vip: BucketColor(accent: Color(0xFFF06FBF), container: Color(0xFF3D1530), onContainer: Color(0xFFFFB3E0)),
    ),
  );

  // Themes are switched, not animated, so lerp returns the nearest side.
  @override
  GmailooColors lerp(GmailooColors? other, double t) => t < 0.5 ? this : (other ?? this);

  @override
  GmailooColors copyWith() => this; // tokens are immutable; swap the whole set instead.

  /// Map to Material 3 so stock widgets inherit the palette.
  ColorScheme toColorScheme(Brightness b) => ColorScheme(
        brightness: b,
        primary: primary,
        onPrimary: onPrimary,
        primaryContainer: primaryContainer,
        onPrimaryContainer: onPrimaryContainer,
        secondary: primary,
        onSecondary: onPrimary,
        error: error,
        onError: onError,
        surface: surface,
        onSurface: onSurface,
        surfaceContainerHighest: surfaceVariant,
        outline: outlineStrong,
        outlineVariant: outline,
      );
}

extension GmailooColorsX on BuildContext {
  GmailooColors get colors => Theme.of(this).extension<GmailooColors>()!;
}
```

Wire it up in the theme:

```dart
ThemeData buildTheme(Brightness b, Locale locale) {
  final c = b == Brightness.light ? GmailooColors.light : GmailooColors.dark;
  return ThemeData(
    useMaterial3: true,
    colorScheme: c.toColorScheme(b),
    scaffoldBackgroundColor: c.bg,
    textTheme: gmailooTextTheme(locale, c.onSurface), // see typography.md
    extensions: [c],
  );
}
```

**Do / Don't**

| Do | Don't |
|---|---|
| `context.colors.buckets.unread.container` | `Color(0xFFFDECEC)` inline |
| Pair bucket color with icon + label | Show a bucket as a colored dot only |
| Use `onContainer` for text on chips | Use `accent` as text color |
| Use `outlineStrong` for input borders | Use `outline` for anything interactive |
