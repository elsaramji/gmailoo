# Gmailoo: Fonts and Iconography Specification

**Project:** Gmailoo (Ephemeral, Stress-Free Email Client)  
**Target Platforms:** Flutter (iOS & Android)  
**Locales:** Arabic (Egypt, `ar-EG`) & English (US, `en-US`)  
**Design Principles:** Arabic First, Calm by Default, Never Color Alone  
**References:**
- Typography System: [typography.md](file:///d:/mobile%20development%20%20advance/gmailoo/docs/typography.md)
- Color Palette: [colors.md](file:///d:/mobile%20development%20%20advance/gmailoo/docs/colors.md)
- UI Specification: [ui-design-spec.md](file:///d:/mobile%20development%20%20advance/gmailoo/docs/ui-design-spec.md)
- Implementation Plan: [agent-implementation-plan.md](file:///d:/mobile%20development%20%20advance/gmailoo/docs/agent-implementation-plan.md)

---

## 1. Font Families Specification

To preserve privacy, support 100% offline functionality from the first launch, and eliminate Flash of Unstyled Text (FOUT), **all fonts are bundled locally** in `assets/fonts/` instead of fetched at runtime via `google_fonts`.

### 1.1 Primary Font Families

| Role | Family | Weights Bundled | Scripts | Usage | License |
|---|---|---|---|---|---|
| **Display & Branding** | **Cairo** | `600` (SemiBold)<br>`700` (Bold) | Arabic + Latin | Screen titles, Zen Day reset hero, app wordmark, onboarding headlines | SIL Open Font License 1.1 (OFL) |
| **UI, Reading & Body** | **IBM Plex Sans Arabic** | `400` (Regular)<br>`500` (Medium)<br>`600` (SemiBold) | Arabic + Latin | Email body text, subject lines, senders, buttons, smart bucket chips, metadata | SIL Open Font License 1.1 (OFL) |

### 1.2 Font Selection Rationale
1. **Cairo (Display):**
   - Geometric, crisp, and approachable.
   - Resonates with Gen Z / Gen Alpha aesthetics.
   - Naturally harmonizes Arabic and Latin letterforms in high-contrast headlines without mid-sentence stylistic clashes.
2. **IBM Plex Sans Arabic (UI & Body):**
   - High legibility at small sizes (`11sp` – `17sp`).
   - The Latin glyphs within IBM Plex Sans Arabic are drawn to match Arabic heights and stem thicknesses, preventing uneven lines in mixed-script subject lines (e.g. `CS402 Exam - جدول الامتحانات`).
   - Generous open counters and clean diacritic placement.

### 1.3 System Fallback Chain
```
Display:  Cairo → IBMPlexSansArabic → Roboto (Android) / SF Pro (iOS) → sans-serif
Body/UI:  IBMPlexSansArabic → Roboto (Android) / SF Pro (iOS) → sans-serif
```

In Flutter `TextStyle`:
```dart
fontFamilyFallback: family == 'Cairo' 
    ? const ['IBMPlexSansArabic', 'Roboto'] 
    : const ['Roboto'],
```

### 1.4 Asset File Structure
Place the following `.ttf` binaries and license file in `assets/fonts/`:
```
assets/
└── fonts/
    ├── Cairo-SemiBold.ttf
    ├── Cairo-Bold.ttf
    ├── IBMPlexSansArabic-Regular.ttf
    ├── IBMPlexSansArabic-Medium.ttf
    ├── IBMPlexSansArabic-SemiBold.ttf
    └── OFL.txt
```

---

## 2. Arabic & RTL Typography Rules

1. **Zero Letter-Spacing (`letterSpacing: 0`):**
   - Any positive letter-spacing breaks cursive Arabic ligatures and connections between glyphs. Applied uniformly across both Latin and Arabic for design consistency.
2. **Never Synthesize Italics:**
   - Arabic has no native italic form; mechanical slanting distorts letterforms and impairs readability. Emphasis is achieved via `FontWeight` or semantic color tokens.
3. **Arabic +1 sp Size & Line Height Compensation:**
   - Arabic letterforms feature a smaller x-height and require vertical clearance for diacritics (harakat) and dots. Arabic styles are tuned with `+1 sp` and taller line multipliers (`height: line / size`).
4. **Per-Item Text Direction (`directionOf`):**
   - Incoming subjects and snippets often mix languages. Direction is evaluated from the first strong Unicode rune rather than blindly inheriting the app locale.
5. **Unicode Isolates for Mixed Runs:**
   - URLs, email addresses, and timestamps inside Arabic text are wrapped with directional isolate marks (`\u2066...\u2069`) to prevent punctuation and numbers from jumping sides.
6. **Dynamic Type & Clamping:**
   - Body copy scales with system accessibility up to `200%`.
   - Navigation tabs, filter chips, and badges are clamped at `130%` using `MediaQuery.withClampedTextScaling` to prevent container clipping.

---

## 3. Complete Type Scale

| Role | Font Family | Weight | Latin Size / Line | Arabic Size / Line | UI Placement |
|---|---|---|---|---|---|
| **Display** | Cairo | 700 | `32sp` / `40dp` | `32sp` / `48dp` | Zen Day reset hero headline, splash wordmark |
| **Headline M** | Cairo | 700 | `24sp` / `32dp` | `24sp` / `38dp` | Screen titles ("This Week", "Timetables") |
| **Headline S** | Cairo | 600 | `20sp` / `28dp` | `20sp` / `32dp` | Onboarding card titles, modal sheet headers |
| **Title M** | Plex Arabic | 600 | `16sp` / `24dp` | `17sp` / `28dp` | Email subject (unread), VIP card name |
| **Title S** | Plex Arabic | 600 | `14sp` / `20dp` | `15sp` / `24dp` | Section headers, sender name (unread) |
| **Body L** | Plex Arabic | 400 | `16sp` / `24dp` | `17sp` / `28dp` | Email body viewer, privacy notice paragraphs |
| **Body M** | Plex Arabic | 400 | `14sp` / `20dp` | `15sp` / `24dp` | Sender name (read), email subject (read) |
| **Body S** | Plex Arabic | 400 | `12sp` / `16dp` | `13sp` / `20dp` | Snippet preview, card descriptions |
| **Label L** | Plex Arabic | 500 | `14sp` / `20dp` | `15sp` / `22dp` | Primary CTA buttons, action sheet items |
| **Label M** | Plex Arabic | 500 | `12sp` / `16dp` | `13sp` / `18dp` | Smart bucket filter chips, category pills |
| **Label S** | Plex Arabic | 500 | `11sp` / `16dp` | `12sp` / `18dp` | Timestamps, cycle countdown badges, lock notes |

---

## 4. Icon Packages and Iconography System

In Gmailoo, icons are essential for accessibility and contrast: **"Color is never the only signal"** — every status or bucket pairs its color with an explicit icon and text label.

### 4.1 Recommended Icon Packages

| Package | Version | Purpose |
|---|---|---|
| **`material_symbols_icons`** | `^4.2764.0` | **Primary Icon Set:** Pixel-perfect implementation of Google's modern **Material Symbols (Rounded)** family, providing rounded strokes that match Cairo and IBM Plex Sans Arabic. |
| **`cupertino_icons`** | `^1.0.8` | **iOS System Glyphs:** iOS native disclosure chevrons, sheet grabbers, and Apple-standard modal icons. |
| **`flutter_svg`** | `^2.0.10+1` | **Vector Assets:** Renders custom vector SVGs: Gmailoo squircle logo, Google multi-colored `G` auth monogram, and Zen Day lotus illustration. |

*(Note: If zero extra dependencies is preferred for core icons, Flutter's built-in `Icons.*_rounded` from `uses-material-design: true` can be used as a direct alternative).*

---

### 4.2 Smart Bucket Icon Mapping

Every smart bucket requires a dedicated rounded icon:

| Bucket | Icon Identifier (Material Symbols Rounded) | Built-in Flutter Alternative | Semantic Meaning & Token Accent |
|---|---|---|---|
| **Important unread** | `Symbols.mark_email_unread_rounded` | `Icons.mark_email_unread_rounded` | Coral (`#E5484D`): Urgent unread mail requiring attention |
| **Important** | `Symbols.priority_high_rounded` | `Icons.priority_high_rounded` | Amber (`#B86E00`): Important email already read |
| **Timetables** | `Symbols.calendar_month_rounded` | `Icons.calendar_month_rounded` | Blue (`#2F7DE1`): Schedules, lectures, exams, deadlines |
| **Marketing** | `Symbols.sell_rounded` | `Icons.sell_rounded` | Slate (`#7C829E`): Promotions, newsletters, quiet ads |
| **VIP Senders / Folders** | `Symbols.workspace_premium_rounded` | `Icons.workspace_premium_rounded` | Magenta (`#D6409F`): VIP senders and private folders |
| **Everything Else** | `Symbols.mail_rounded` | `Icons.mail_rounded` | Subtle Grey (`#646A86`): Miscellaneous fallback mail |

---

### 4.3 Navigation & Action Icons

#### Bottom Navigation Bar:
- **Inbox Tab:** `Symbols.inbox_rounded` / `Symbols.mail_rounded`
- **Timetables Tab:** `Symbols.calendar_today_rounded` / `Symbols.calendar_month_rounded`
- **VIPs Tab:** `Symbols.grade_rounded` / `Symbols.star_rounded`
- **Settings Tab:** `Symbols.settings_rounded` / `Symbols.tune_rounded`

#### Action & Utility Icons:
- **Compose (Floating Action Button):** `Symbols.edit_rounded` / `Symbols.edit_note_rounded`
- **Reply Action:** `Symbols.reply_rounded` (mirrored in RTL)
- **Forward Action:** `Symbols.forward_rounded` (mirrored in RTL)
- **Open in Gmail Deep Link:** `Symbols.open_in_new_rounded`
- **Security & Privacy:** `Symbols.lock_rounded` / `Symbols.verified_user_rounded`
- **Attachments:** `Symbols.attach_file_rounded` / `Symbols.description_rounded`
- **Calendar Sync Action:** `Symbols.event_available_rounded`
- **Filter / Search:** `Symbols.filter_list_rounded`, `Symbols.search_rounded`
- **Directional Navigation:** `Symbols.arrow_back_rounded` / `Symbols.arrow_forward_rounded`

---

### 4.4 Icon Directionality & Accessibility Rules

1. **RTL Directional Mirroring:**
   - Icons conveying reading progression or physical direction (`arrow_back`, `reply`, `forward`, `chevron_right`) **must automatically flip** when the UI is in RTL mode.
   - Use Flutter's `Icons.arrow_back` or wrap directional icons in `Transform.flip(flipX: Directionality.of(context) == TextDirection.rtl, child: icon)`.
2. **Accessibility & Screen Readers:**
   - Every standalone icon button must declare a localized `tooltip` and `Semantics(label: ...)` in both Arabic and English.
   - Decorative icons inside pills or chips must set `excludeFromSemantics: true` to avoid cluttering screen readers.

---

## 5. Configuration Snippet

### `pubspec.yaml`
```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  material_symbols_icons: ^4.2764.0
  flutter_svg: ^2.0.10+1

flutter:
  uses-material-design: true

  assets:
    - assets/fonts/
    - assets/icons/

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
