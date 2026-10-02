# Gmailoo Design System: Typography

**Version:** 0.1 (draft) · **Scripts:** Arabic + Latin · **Directions:** RTL + LTR

---

## 1. Typography Principles

1. **Arabic is designed first, not adapted.** Arabic needs more line height and larger sizes than Latin at the same visual weight, and it must never have letter-spacing (it breaks the joining between letters).
2. **Two families, no more.** One display family for personality, one UI family for reading. Fewer fonts means a smaller app and calmer screens.
3. **Mixed-script text is normal.** Subjects like "اجتماع الـ sprint بكرة" are everyday email. Fonts must carry both scripts so fallbacks never fire mid-sentence.
4. **Hierarchy comes from size and weight, not color.** Color hierarchy is reserved for state (see `colors.md`).

---

## 2. Font Families

| Role | Family | Scripts | Weights bundled | Used for |
|---|---|---|---|---|
| **Display** | **Cairo** | Arabic + Latin | 600, 700 | Screen titles, Zen Day hero, onboarding headlines |
| **UI / Body** | **IBM Plex Sans Arabic** | Arabic + Latin | 400, 500, 600 | Everything else: lists, email bodies, buttons, labels |

**Why this pairing (analysis, not a rule):**

- Cairo is geometric and friendly, which suits a Gen Z / Gen Alpha audience, and covers both Arabic and Latin in one family.
- IBM Plex Sans Arabic is highly legible at small sizes, and its Latin glyphs are drawn to match its Arabic, so mixed Arabic/English subject lines look even.
- Both are open source (SIL Open Font License 1.1) and available on Google Fonts. **Include each license file in the repo** and verify the current license terms when you download.

**Alternatives considered:** Tajawal (lighter, more compact), Noto Sans Arabic (maximum coverage, less personality). Pick by testing on real devices, since screen rendering differs from specimen pages.

### Fallback stack

```
Cairo → IBM Plex Sans Arabic → Roboto (Android) / SF Pro (iOS) → system
```

In Flutter: `fontFamilyFallback: ['IBMPlexSansArabic']` on Cairo styles, and `['Roboto']` on body styles.

### Bundle the fonts, don't fetch them

Use bundled assets instead of the `google_fonts` runtime fetch. Reasons: Gmailoo is privacy-first (no third-party font request on launch), works offline from first run, and avoids a flash of unstyled text on a slow connection.

```yaml
# pubspec.yaml
flutter:
  fonts:
    - family: Cairo
      fonts:
        - asset: assets/fonts/Cairo-SemiBold.ttf
          weight: 600
        - asset: assets/fonts/Cairo-Bold.ttf
          weight: 700
    - family: IBMPlexSansArabic
      fonts:
        - asset: assets/fonts/IBMPlexSansArabic-Regular.ttf
          weight: 400
        - asset: assets/fonts/IBMPlexSansArabic-Medium.ttf
          weight: 500
        - asset: assets/fonts/IBMPlexSansArabic-SemiBold.ttf
          weight: 600
```

Keep the weight count low; every extra weight adds app size.

---

## 3. Type Scale

Sizes are in `sp` (they scale with the user's system font size). Line heights are in `dp` at 1.0 text scale.

| Role | Family | Weight | Latin size / line | Arabic size / line |
|---|---|---|---|---|
| **Display** | Cairo | 700 | 32 / 40 | 32 / 48 |
| **Headline M** | Cairo | 700 | 24 / 32 | 24 / 38 |
| **Headline S** | Cairo | 600 | 20 / 28 | 20 / 32 |
| **Title M** | Plex Arabic | 600 | 16 / 24 | 17 / 28 |
| **Title S** | Plex Arabic | 600 | 14 / 20 | 15 / 24 |
| **Body L** | Plex Arabic | 400 | 16 / 24 | 17 / 28 |
| **Body M** | Plex Arabic | 400 | 14 / 20 | 15 / 24 |
| **Body S** | Plex Arabic | 400 | 12 / 16 | 13 / 20 |
| **Label L** | Plex Arabic | 500 | 14 / 20 | 15 / 22 |
| **Label M** | Plex Arabic | 500 | 12 / 16 | 13 / 18 |
| **Label S** | Plex Arabic | 500 | 11 / 16 | 12 / 18 |

**Why Arabic gets +1 sp and taller lines:** Arabic letterforms have a smaller visual size and carry dots and diacritics above and below the line, so the same point size reads smaller and gets cramped with Latin line heights. These values are a starting point; adjust after testing on device.

**Minimum sizes:** nothing below Label S (11 sp Latin / 12 sp Arabic), and never use Label S for content the user must read to act.

### Where each style is used in the inbox

| UI element | Style |
|---|---|
| Screen title ("This week") | Headline M |
| Section / bucket header | Title S |
| Sender name (unread) | Title S (600) |
| Sender name (read) | Body M (400) |
| Subject (unread / read) | Body M, weight 600 / 400 |
| Snippet preview | Body S, `onSurfaceMuted` |
| Time stamp | Label S, `onSurfaceSubtle` |
| Bucket chip | Label M, `onContainer` |
| Button | Label L |
| Email body | Body L |
| Zen Day hero | Display |

---

## 4. Arabic and RTL Rules

1. **Letter-spacing is always 0.** Any tracking, even slightly positive, breaks the joining between Arabic letters. Apply this to Latin text too, for one consistent rule.
2. **Never use italics for Arabic.** Arabic has no true italic; synthesized slants look broken. Use weight or color for emphasis.
3. **Never use uppercase transforms** on Arabic (no effect) and avoid all-caps Latin labels in an RTL layout.
4. **Alignment follows direction, not language.** Use `TextAlign.start` / `AlignmentDirectional`, never `left` / `right`.
5. **Per-item direction.** Detect direction from the first strong character of each subject, sender, and snippet. Don't inherit it from the app locale: an English subject in an Arabic UI should be LTR.
6. **Mixed-direction runs.** Wrap emails, URLs, and numbers inside Arabic text with Unicode isolates (`\u2066…\u2069` for LTR) so punctuation doesn't jump to the wrong side.
7. **Numerals.** Follow the locale by default (`intl` decides), and offer a setting: Western digits (0–9) or Arabic-Indic (٠–٩). Keep time and unread-count formats consistent across the app.
8. **Truncation.** Ellipsize at the end of the reading direction. Test long Arabic subjects with diacritics.

---

## 5. Dynamic Type and Accessibility

- Respect system font scaling up to **200%** on body text. Test the inbox row at 200% in both languages; rows grow in height rather than truncating the sender.
- Cap scaling on bucket chips and tab labels at **130%** (`MediaQuery.withClampedTextScaling`) so navigation doesn't break; keep body text uncapped.
- Contrast for all text styles is governed by `colors.md`. Muted and subtle text colors are verified at ≥ 4.5:1.
- Don't convey unread state by weight alone: pair with the leading dot (see `colors.md`).

---

## 6. Flutter Implementation

```dart
// lib/core/design_system/typography.dart
import 'package:flutter/material.dart';

const _display = 'Cairo';
const _ui = 'IBMPlexSansArabic';

TextTheme gmailooTextTheme(Locale locale, Color color) {
  final isArabic = locale.languageCode == 'ar';

  TextStyle s({
    required double latin,
    required double latinLine,
    required double arabic,
    required double arabicLine,
    required FontWeight weight,
    String family = _ui,
  }) {
    final size = isArabic ? arabic : latin;
    final line = isArabic ? arabicLine : latinLine;
    return TextStyle(
      fontFamily: family,
      fontFamilyFallback: family == _display ? const [_ui, 'Roboto'] : const ['Roboto'],
      fontSize: size,
      height: line / size, // Flutter's `height` is a multiplier of font size
      fontWeight: weight,
      letterSpacing: 0, // required for Arabic joining
      color: color,
    );
  }

  return TextTheme(
    displayLarge:   s(latin: 32, latinLine: 40, arabic: 32, arabicLine: 48, weight: FontWeight.w700, family: _display),
    headlineMedium: s(latin: 24, latinLine: 32, arabic: 24, arabicLine: 38, weight: FontWeight.w700, family: _display),
    headlineSmall:  s(latin: 20, latinLine: 28, arabic: 20, arabicLine: 32, weight: FontWeight.w600, family: _display),
    titleMedium:    s(latin: 16, latinLine: 24, arabic: 17, arabicLine: 28, weight: FontWeight.w600),
    titleSmall:     s(latin: 14, latinLine: 20, arabic: 15, arabicLine: 24, weight: FontWeight.w600),
    bodyLarge:      s(latin: 16, latinLine: 24, arabic: 17, arabicLine: 28, weight: FontWeight.w400),
    bodyMedium:     s(latin: 14, latinLine: 20, arabic: 15, arabicLine: 24, weight: FontWeight.w400),
    bodySmall:      s(latin: 12, latinLine: 16, arabic: 13, arabicLine: 20, weight: FontWeight.w400),
    labelLarge:     s(latin: 14, latinLine: 20, arabic: 15, arabicLine: 22, weight: FontWeight.w500),
    labelMedium:    s(latin: 12, latinLine: 16, arabic: 13, arabicLine: 18, weight: FontWeight.w500),
    labelSmall:     s(latin: 11, latinLine: 16, arabic: 12, arabicLine: 18, weight: FontWeight.w500),
  );
}
```

Auto-detect direction per item:

```dart
TextDirection directionOf(String text) {
  for (final r in text.runes) {
    if ((r >= 0x0590 && r <= 0x08FF) || (r >= 0xFB1D && r <= 0xFEFC)) return TextDirection.rtl;
    if ((r >= 0x41 && r <= 0x5A) || (r >= 0x61 && r <= 0x7A)) return TextDirection.ltr;
  }
  return TextDirection.ltr; // fallback; callers may pass the app direction instead
}
```

Usage:

```dart
Text(
  email.subject,
  textDirection: directionOf(email.subject),
  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        fontWeight: email.isUnread ? FontWeight.w600 : FontWeight.w400,
      ),
  maxLines: 1,
  overflow: TextOverflow.ellipsis,
)
```

---

## 7. Testing Checklist

- [ ] Inbox row renders correctly in ar-EG and en-US at 100%, 130%, 200% text scale
- [ ] A subject mixing Arabic + English + a URL + digits displays in the right order
- [ ] No synthesized italics or fallback-font flashes on cold start (airplane mode)
- [ ] Arabic text with diacritics isn't clipped vertically in chips and buttons
- [ ] Display and Headline styles don't clip descenders at the Arabic line heights
- [ ] APK/IPA size impact of the bundled fonts measured and recorded
