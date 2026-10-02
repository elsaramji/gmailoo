# Gmailoo: Frontend UI Specification & Implementation Blueprint

**Version:** 1.0 · **Target Viewport:** iPhone 13 mini (`375pt × 812pt`) · **Framework:** Flutter · **Architecture:** Clean Architecture + BLoC/Cubit · **Navigation:** `go_router`

This document defines the complete visual, architectural, state-driven, and data specification for implementing the front end of **Gmailoo**. An AI coding agent or Flutter engineer can implement every screen, transition, state, and offline mock fixture directly from this file without external dependencies.

---

## 1. Visual & System Design Foundations

### 1.1 Viewport & Form Factor
* **Primary Spec Device:** iPhone 13 mini (`375 × 812` logical points, `~3.0` pixel ratio).
* **Safe Areas:**
  * Top status bar: `44pt` (Dynamic Island / compact notch).
  * Bottom home indicator: `34pt` safe inset.
  * Maximum content height without scroll: `734pt`.
* **Adaptive Breakpoints:** Single-column vertical flow with strict horizontal content margins of `16pt` (`container-margin`). Responsive scaling up to iPad/Desktop (`>=600pt`) by constraining content max-width to `540pt` centered.

### 1.2 Design Tokens Quick Reference
Derived from [colors.md](file:///d:/mobile%20development%20%20advance/gmailoo/docs/colors.md) and [typography.md](file:///d:/mobile%20development%20%20advance/gmailoo/docs/typography.md):

```dart
// Core Tokens
const kBgLight = Color(0xFFF7F7FB);           // Soft tinted canvas
const kSurfaceLight = Color(0xFFFFFFFF);      // Cards and sheets
const kSurfaceVariantLight = Color(0xFFEEF0F7);// Grouped rows, chips
const kOutlineLight = Color(0xFFD5D9E6);       // Dividers (1.4:1)
const kOutlineStrongLight = Color(0xFF7C829E); // Borders, icons (3.8:1)
const kOnSurfaceLight = Color(0xFF14162B);     // Primary text (17.8:1)
const kOnSurfaceMutedLight = Color(0xFF4A4F6A);// Secondary text (8.0:1)
const kOnSurfaceSubtleLight = Color(0xFF646A86);// Tertiary text (5.3:1)
const kPrimaryLight = Color(0xFF4F46E5);       // Gmailoo Indigo (6.3:1)
const kPrimaryContainerLight = Color(0xFFE8E7FD);
const kOnPrimaryContainerLight = Color(0xFF2A2486);

// Smart Bucket Palette (accent, container, onContainer)
// Rule: Never use accent as text color; graphical elements only!
const kBucketUnreadAccent = Color(0xFFE5484D);
const kBucketUnreadContainer = Color(0xFFFDECEC);
const kBucketUnreadOnContainer = Color(0xFF8C1D21);

const kBucketImportantAccent = Color(0xFFB86E00);
const kBucketImportantContainer = Color(0xFFFFF3D6);
const kBucketImportantOnContainer = Color(0xFF6B4300);

const kBucketTimetablesAccent = Color(0xFF2F7DE1);
const kBucketTimetablesContainer = Color(0xFFE5F0FF);
const kBucketTimetablesOnContainer = Color(0xFF0F3D7A);

const kBucketMarketingAccent = Color(0xFF7C829E);
const kBucketMarketingContainer = Color(0xFFEEF0F5);
const kBucketMarketingOnContainer = Color(0xFF4A4F6A);

const kBucketVipAccent = Color(0xFFD6409F);
const kBucketVipContainer = Color(0xFFFDE7F4);
const kBucketVipOnContainer = Color(0xFF7A1B55);
```

### 1.3 Typography Rules (Non-Negotiable)
1. **Cairo** for Display & Headlines (`FontWeight.w700`, `w600`).
2. **IBM Plex Sans Arabic** (and IBM Plex Sans) for all UI, buttons, body copy, and metadata (`w400, w500, w600`).
3. **Letter Spacing:** `letterSpacing: 0` everywhere. Positive tracking breaks Arabic ligatures.
4. **No Synthesized Italics:** Never slant Arabic glyphs.
5. **Bidirectional Layout:** Subjects and snippets detect direction via rune inspection (`TextDirection.rtl` vs `TextDirection.ltr`). Layout uses `EdgeInsetsDirectional` and `AlignmentDirectional`.

---

## 2. Navigation & Routing Architecture (`go_router`)

### 2.1 Route Tree Hierarchy
```
/ (redirects based on auth & cycle)
├── /splash                          [SplashScreen]
├── /onboarding                      [OnboardingScreen]
├── /auth                            [GoogleOAuthScreen]
├── /zen-day                         [ZenDayScreen] (Friday Reset)
└── /app (StatefulShellRoute with BottomNavigationBar)
    ├── /inbox                       [InboxHomeScreen - Tab 0]
    │   ├── /inbox/detail/:id        [EmailDetailScreen]
    │   └── /inbox/compose           [ComposeModalScreen]
    ├── /timetables                  [TimetablesScreen - Tab 1]
    ├── /vips                        [VipsScreen - Tab 2]
    └── /settings                    [SettingsScreen - Tab 3]
```

### 2.2 GoRouter Implementation Blueprint
```dart
// lib/app/router.dart
final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/splash',
  redirect: (context, state) {
    final authState = context.read<AuthCubit>().state;
    final cycleState = context.read<CycleCubit>().state;

    final isSplash = state.matchedLocation == '/splash';
    final isOnboarding = state.matchedLocation == '/onboarding';
    final isAuth = state.matchedLocation == '/auth';

    if (isSplash) return null;

    if (authState is AuthUnauthenticated) {
      return isOnboarding ? null : '/onboarding';
    }

    if (authState is AuthNeedsGoogleOAuth) {
      return '/auth';
    }

    if (authState is AuthAuthenticated) {
      // Friday Zen Day takes precedence during reset window
      if (cycleState.isZenDay && state.matchedLocation != '/zen-day') {
        return '/zen-day';
      }
      if (isOnboarding || isAuth) {
        return '/inbox';
      }
    }

    return null;
  },
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/auth',
      builder: (context, state) => const GoogleOAuthScreen(),
    ),
    GoRoute(
      path: '/zen-day',
      builder: (context, state) => const ZenDayScreen(),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) => AppScaffoldWithNavBar(
        navigationShell: navigationShell,
      ),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/inbox',
              builder: (context, state) => const InboxHomeScreen(),
              routes: [
                GoRoute(
                  path: 'detail/:id',
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) => EmailDetailScreen(
                    emailId: state.pathParameters['id']!,
                  ),
                ),
                GoRoute(
                  path: 'compose',
                  parentNavigatorKey: _rootNavigatorKey,
                  pageBuilder: (context, state) => const MaterialPage(
                    fullscreenDialog: true,
                    child: ComposeModalScreen(),
                  ),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/timetables',
              builder: (context, state) => const TimetablesScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/vips',
              builder: (context, state) => const VipsScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/settings',
              builder: (context, state) => const SettingsScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);
```

---

## 3. Screen Specifications & State Management

### 3.1 Splash Screen
* **Path:** `/splash`
* **Viewport Requirements:** iPhone 13 mini (`375 × 812`), centered layout, top iOS status bar (`44pt`), bottom safe area (`34pt`).
* **Components:**
  * Radial ambient indigo glow background (`#4F46E5` @ 6% opacity).
  * 88×88px Squircle container (`#FFFFFF`, `radius: 24`, `border: 1px #D5D9E6`, soft shadow).
  * Indigo envelope logo + coral dot (`#E5484D`).
  * Cairo 32px Bold Wordmark: `Gmailoo •`.
  * Bilingual subtitle: `صندوق بريد هادئ • Ephemeral & Calm Email` (`14sp`, `#4A4F6A`).
  * Bottom Sync Bar: Indeterminate linear progress bar in `#4F46E5` / `#E8E7FD`.
  * Status text: `"Syncing this week's mail..."` (`12sp`, `#646A86`).
  * Security footnote: `"Encrypted & Local Only • Powered by Gmail API"` with lock icon (`11sp`, `#7C829E`).

#### State Model (`SplashCubit`)
```dart
sealed class SplashState {}
class SplashInitial extends SplashState {}
class SplashSyncing extends SplashState {
  final double progress; // 0.0 to 1.0
  final String statusText;
  SplashSyncing({required this.progress, required this.statusText});
}
class SplashCompleted extends SplashState {
  final bool hasSession;
  SplashCompleted({required this.hasSession});
}
class SplashError extends SplashState {
  final String message;
  SplashError(this.message);
}
```

---

### 3.2 Onboarding Screen
* **Path:** `/onboarding`
* **Viewport Requirements:** Compact 375×812. Ergonomic single-thumb reachability.
* **Components:**
  * Top Bar: Wordmark `Gmailoo •` (left), `Skip / تخطي` button (right, `#646A86`).
  * Central Hero Multi-tiered Card (`#FFFFFF`, `radius: 16`, `border: 1px #D5D9E6`):
    * Layer 1: "Friday Zen Day: Automatic Local Reset" with calendar leaf icon.
    * Layer 2: Floating smart bucket pills (`[Important unread]`, `[Timetables • جدول]`, `[VIP ⭐]`).
    * Layer 3: Reassurance badge: "Encrypted & Safe • Your Gmail archive is never deleted".
  * Typography:
    * Headline: `Email that clears itself. Zero anxiety.` (Cairo 22sp bold, `#14162B`).
    * Arabic Subtitle: `صندوق بريد يتجدد كل أسبوع بهدوء` (Cairo 18sp bold, `#4F46E5`).
    * Body: `"Only see this week's emails. Marketing noise is silenced, exam timetables are prioritized, and every Friday gives you a fresh start."` (IBM Plex 13sp, `#4A4F6A`).
  * Carousel Dots: 3 dots, active dot is extended pill (`width: 28pt`, `height: 8pt`, `#4F46E5`).
  * Action Zone: Primary button `"Get Started • ابدأ الآن"` (height `48pt`, `radius: 12`, `#4F46E5`), secondary link `"Already have an account? Sign In"`.

#### State Model (`OnboardingCubit`)
```dart
class OnboardingState {
  final int currentPageIndex; // 0, 1, 2
  final bool isLastPage;
  const OnboardingState({this.currentPageIndex = 0, this.isLastPage = false});
}
```

---

### 3.3 Google OAuth Login Screen
* **Path:** `/auth`
* **Components:**
  * Top navigation bar with back arrow and language switch pill (`العربية` / `English`).
  * Gmailoo 36×36px monogram badge.
  * Headline: `"Connect Your Google Account"` / `«تسجيل الدخول باستخدام جوجل»`.
  * Subtitle: `"Link your Gmail securely to experience an ephemeral, stress-free inbox."`
  * Official Google OAuth Button: Height `48pt`, `#FFFFFF`, border `#D5D9E6`, multicolor `G` asset, text `"Continue with Google"`.
  * User Preview Card (when prior token detected): Profile picture/initials, email (`mahmoud@gmail.com`), `"Switch account"` link.
  * High-Trust Privacy Container (`#FFFFFF`, `radius: 16`, `border: 1px #D5D9E6`):
    * ✓ Reads & auto-sorts only mail from the current week.
    * ✓ Sends replies & schedules messages upon your request.
    * ✓ Local-only ephemeral wipe: Original emails are never deleted in Gmail.
    * ✓ No third-party data tracking, advertising, or selling.
    * Pill badge: `"Official Google OAuth 2.0 Restricted Scope Verified"` with lock icon (`#E8E7FD` bg, `#2A2486` text).
  * Legal footer: Egypt PDPL (Law 151/2020) & Google API User Data Policy compliance notice.

#### State Model (`AuthCubit`)
```dart
sealed class AuthState {}
class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {
  final String statusText;
  AuthLoading(this.statusText);
}
class AuthAuthenticated extends AuthState {
  final UserEntity user;
  AuthAuthenticated(this.user);
}
class AuthUnauthenticated extends AuthState {}
class AuthNeedsGoogleOAuth extends AuthState {
  final String? cachedEmail;
  AuthNeedsGoogleOAuth({this.cachedEmail});
}
class AuthFailureState extends AuthState {
  final String errorMessage;
  final bool canRetry;
  AuthFailureState({required this.errorMessage, this.canRetry = true});
}
```

---

### 3.4 Main Inbox Screen ("This Week")
* **Path:** `/inbox`
* **Components:**
  * **Top Bar:** Wordmark `Gmailoo •` (Cairo 20sp bold), Cycle Status Badge (`"This Week • 3d left"`, `#EEF0F7` surface variant pill), search button, avatar icon (`MB`).
  * **Smart Bucket Filter Chips (Horizontal Scroll):**
    * `All (14)`: Active in `#E8E7FD` with `#2A2486` text.
    * `Important unread (3)`: `#FDECEC` container, `#8C1D21` text, 8dp coral leading dot.
    * `Timetables • جدول (2)`: `#E5F0FF` container, `#0F3D7A` text, calendar icon.
    * `VIP ⭐ (1)`: `#FDE7F4` container, `#7A1B55` text, star icon.
    * `Marketing`: Quiet slate `#EEF0F5` container, `#4A4F6A` text.
  * **Feed Cards (`#FFFFFF`, `radius: 12`, `border: 1px #D5D9E6`):**
    * Card 1 (Unread Important): Coral dot (`#E5484D`), sender `Dr. Tarek Hegazy` (Cairo 600), subject `CS402 Exam Schedule & Midterm Guidelines` (Cairo 600), snippet, time `10:24 AM`, bucket chip `[Timetables • جدول]`.
    * Card 2 (Arabic Timetable): RTL title `جدول المحاضرات المعدل للأسبوع الحالي`, sender `إدارة الكلية (Faculty Admin)`, snippet `تم تحديث مواعيد قاعات المحاضرات...`.
    * Card 3 (Important Read): Weight 400, muted snippet, bucket chip `[Important]`.
  * **Floating Action Button:** Pill-shaped `Compose` button with edit icon in Gmailoo Indigo (`#4F46E5`).
  * **Bottom Navigation Bar:** 4 tabs docked (Inbox [Active], Timetables, VIPs, Settings).

#### State Model (`InboxBloc`)
```dart
enum SmartBucketFilter { all, unread, timetables, vip, marketing }

class InboxState {
  final InboxStatus status; // initial, loading, loaded, refreshing, error
  final List<EmailItemEntity> emails;
  final SmartBucketFilter selectedFilter;
  final String searchQuery;
  final CycleEntity currentCycle;
  final String? errorMessage;

  const InboxState({
    this.status = InboxStatus.initial,
    this.emails = const [],
    this.selectedFilter = SmartBucketFilter.all,
    this.searchQuery = '',
    required this.currentCycle,
    this.errorMessage,
  });

  List<EmailItemEntity> get filteredEmails {
    return emails.where((e) {
      if (selectedFilter == SmartBucketFilter.all) return true;
      if (selectedFilter == SmartBucketFilter.unread) return e.isUnread;
      if (selectedFilter == SmartBucketFilter.timetables) return e.bucket == EmailBucket.timetables;
      if (selectedFilter == SmartBucketFilter.vip) return e.isVip;
      if (selectedFilter == SmartBucketFilter.marketing) return e.bucket == EmailBucket.marketing;
      return true;
    }).toList();
  }
}
```

---

### 3.5 Timetables Tab View (Tab 1)
* **Path:** `/timetables`
* **Components:**
  * Top Bar: Title `Timetables` / `الجداول والمواعيد` (Cairo 20sp bold).
  * Cycle Summary Banner: `"3 Verified Events Detected from Email • Wipes Friday on Zen Day"` (`#E5F0FF` bg, `#0F3D7A` text).
  * Sub-filters: `All (3)`, `Exams • امتحانات (1)`, `Lectures • محاضرات (1)`, `Deadlines • تسليمات (1)`.
  * Event Cards:
    * Exam card: Rose badge `EXAM • امتحان`, `CS402 Distributed Systems Midterm`, Sunday Oct 5, Hall 3B, Google Calendar synced chip (`#E6F7F0` bg, `#0B7A5C` text).
    * Lecture card: Blue badge `LECTURE`, `جدول المحاضرات والسكاشن المعدل`, PDF attachment preview chip (`CS_Cohort_Schedule.pdf`).
    * Deadline card: Amber badge `DEADLINE`, `Sprint 4 Deliverables & Staging Deadline`.

#### State Model (`TimetableCubit`)
```dart
enum TimetableCategory { all, exams, lectures, deadlines }

class TimetableState {
  final bool isLoading;
  final List<TimetableEventEntity> events;
  final TimetableCategory selectedCategory;
  final String? error;

  const TimetableState({
    this.isLoading = false,
    this.events = const [],
    this.selectedCategory = TimetableCategory.all,
    this.error,
  });
}
```

---

### 3.6 Email Detail & Reading View
* **Path:** `/inbox/detail/:id`
* **Components:**
  * Top Bar: Back button, VIP Star toggle (magenta `#D6409F`), Move Bucket folder icon, `"Synced with Gmail"` reassurance pill.
  * Header Card (`#FFFFFF`, `radius: 16`, `border: 1px #D5D9E6`):
    * Bucket pill: `[Timetables • جدول]` in `#E5F0FF` / `#0F3D7A`.
    * Subject: Cairo 20sp bold (`#14162B`).
    * Sender row: Monogram avatar (`TH`), Name `Dr. Tarek Hegazy`, badge `⭐ VIP Professor`, email address, timestamp, remaining lifespan indicator (`3d remaining`).
  * Body Card: High readability typography in IBM Plex Sans (16sp, line height 1.5).
  * Extracted Event Component: Embedded blue-bordered card with `Add to Calendar` CTA.
  * Attachment Card: PDF item with download icon.
  * Docked Action Bar: Full-width Indigo `#4F46E5` **Reply** CTA, Outlined **Forward**, and external **Open in Gmail** deep-link.

---

### 3.7 Friday "Zen Day" Reset Celebration Screen
* **Path:** `/zen-day`
* **Components:**
  * Soft indigo background canvas (`#F7F7FB` + ambient `#E8E7FD` glow).
  * Hero Emblem: Floating glowing lotus/envelope icon in `#E8E7FD` orb.
  * Headlines:
    * English: `"You're Done for the Week."` (Cairo Display 30sp bold).
    * Arabic: `«صندوق وارد نظيف، بال هادئ»` (Cairo 22sp bold, `#4F46E5`).
    * Subtitle: `"Every email from this week has been cleared from your device so you can disconnect. Remember, all your original emails are untouched and safely preserved in Gmail."`
  * 2×2 Weekly Serenity Snapshot Grid:
    * Metric 1: `48` Emails Cleared (Filtered automatically).
    * Metric 2: `4` VIP & Priority Attended.
    * Metric 3: `12` Timetables Synced to Calendar.
    * Metric 4: `32` Marketing Pitches Muted.
    * Trust banner: `"Zero unread anxiety • 100% ephemeral privacy"`.
  * Cycle Reset Card: `"Next cycle begins Saturday 12:00 AM • Resets in 14h 22m"`.
  * Actions: Primary CTA `"Enjoy Your Weekend 🌿"` and Ghost CTA `"Open Full Archive in Gmail"`.

---

### 3.8 Settings Page Screen (Tab 3)
* **Path:** `/settings`
* **Components:**
  * User profile card (`Mahmoud Badawy`, `mahmoud@gmail.com`, Google Workspace Connected badge).
  * Cycle status card: `"Weekly Cycle: Oct 3 – Oct 8 • Zen Day in 3d"`.
  * Group 1: Appearance & Locale (Theme segmented control: Light/Dark/System, Language toggle: Arabic/English, Digit Format toggle: Western 0-9 / Arabic-Indic ٠-٩).
  * Group 2: Zen Notifications (Toggle ON: Only VIPs & Important Unread notify; Quiet Hours interval: 10:00 PM – 8:00 AM).
  * Group 3: Ephemeral Storage (Cache size: `14.2 MB cached locally`, `"Clear Local Cache Now"`, `"Open Full Mailbox in Gmail"`).
  * Group 4: Account Action (`"Sign Out & Revoke Local Access"` red/coral button).

---

## 4. Complete Mock Data Fixtures (Ready for Offline Testing)

The following fixtures allow developers and AI agents to test all screens and states offline without needing active network connections or Gmail credentials.

### 4.1 Mock Users & Cycle
```dart
// lib/core/mock/mock_fixtures.dart
import 'package:flutter/material.dart';

class MockUserFixture {
  static const current = {
    'id': 'usr_9823412',
    'displayName': 'Mahmoud Badawy',
    'email': 'mahmoud@gmail.com',
    'photoUrl': null,
    'initials': 'MB',
    'isConnected': true,
    'provider': 'Google Workspace',
    'lastSyncTimestamp': '2026-10-02T15:30:00Z',
  };
}

class MockCycleFixture {
  static const activeCycle = {
    'cycleId': '2026-10-03',
    'startDate': '2026-10-03T00:00:00+03:00', // Saturday
    'endDate': '2026-10-08T23:59:59+03:00',   // Thursday
    'zenDayDate': '2026-10-09T00:00:00+03:00',// Friday
    'timeZone': 'Africa/Cairo',
    'daysRemaining': 3,
    'hoursRemaining': 14,
    'minutesRemaining': 22,
    'isZenDayActive': false,
  };

  static const zenDayCycle = {
    'cycleId': '2026-09-26',
    'startDate': '2026-09-26T00:00:00+03:00',
    'endDate': '2026-10-01T23:59:59+03:00',
    'zenDayDate': '2026-10-02T00:00:00+03:00',
    'timeZone': 'Africa/Cairo',
    'daysRemaining': 0,
    'hoursRemaining': 7,
    'minutesRemaining': 45,
    'isZenDayActive': true,
  };
}
```

### 4.2 Mock Emails (Covering All 5 Buckets & RTL/LTR)
```dart
class MockEmailFixtures {
  static const List<Map<String, dynamic>> inboxEmails = [
    {
      'id': 'msg_001',
      'senderName': 'Dr. Tarek Hegazy',
      'senderEmail': 'tarek.hegazy@eng.asu.edu.eg',
      'senderAvatar': 'TH',
      'subject': 'CS402 Exam Schedule & Midterm Guidelines',
      'snippet': 'Please review the updated lecture hall allocations and schedule for next Sunday. Attendance is mandatory...',
      'receivedAt': '10:24 AM',
      'isUnread': true,
      'isVip': true,
      'bucket': 'timetables', // Timetables bucket
      'vipRole': 'VIP Professor',
      'hasAttachments': true,
      'textDirection': 'ltr',
      'body': '''Dear Senior Students,

Please find below the confirmed room allocations and timetable for the upcoming Midterm Examinations scheduled for Sunday, October 5th.

⚠️ Key Instructions:
1. Attendance is strictly required 15 minutes before the exam slot.
2. Bring your physical university ID card.
3. No electronic devices are permitted inside the hall.

Best regards,
Dr. Tarek Hegazy''',
      'extractedEvent': {
        'title': 'CS402 Distributed Systems Midterm',
        'startTime': 'Sunday, Oct 5 • 10:00 AM',
        'endTime': '12:00 PM',
        'location': 'Hall 3B • Engineering Campus',
        'isSynced': true,
      },
      'attachments': [
        {
          'fileName': 'CS402_Midterm_Seat_Distribution.pdf',
          'size': '1.8 MB',
          'mimeType': 'application/pdf',
        }
      ],
    },
    {
      'id': 'msg_002',
      'senderName': 'إدارة الكلية (Faculty Admin)',
      'senderEmail': 'admin@eng.asu.edu.eg',
      'senderAvatar': 'كلية',
      'subject': 'جدول المحاضرات والسكاشن المعدل للأسبوع الحالي',
      'snippet': 'تم تحديث مواعيد قاعات المحاضرات لتبدأ من الساعة 9:00 صباحاً بدلاً من 8:30 بمدرج 4...',
      'receivedAt': 'Oct 1',
      'isUnread': false,
      'isVip': false,
      'bucket': 'timetables',
      'vipRole': null,
      'hasAttachments': true,
      'textDirection': 'rtl',
      'body': '''أعزاءنا الطلاب،

نحيطكم علماً بأنه قد تم تعديل جدول المحاضرات للأسبوع الحالي وفقاً لاقتراحات ممثلي الدفعات. تبدأ المحاضرات بقاعة 4 ابتداءً من يوم الاثنين القادم الساعة 9:00 صباحاً.

يرجى تحميل الجدول المرفق للاطلاع على التفاصيل الكاملة.''',
      'extractedEvent': {
        'title': 'محاضرة نظم التشغيل المتقدمة',
        'startTime': 'Monday, Oct 6 • 09:00 AM',
        'endTime': '11:00 AM',
        'location': 'مدرج 4 - المبنى الرئيسي',
        'isSynced': false,
      },
      'attachments': [
        {
          'fileName': 'CS_Cohort_Schedule.pdf',
          'size': '1.2 MB',
          'mimeType': 'application/pdf',
        }
      ],
    },
    {
      'id': 'msg_003',
      'senderName': 'Sarah Jenkins',
      'senderEmail': 's.jenkins@innovatetech.io',
      'senderAvatar': 'SJ',
      'subject': 'Sprint 4 Final Review: Ready for staging',
      'snippet': 'The pull requests are approved and ready to merge before Thursday. Please test staging endpoints...',
      'receivedAt': 'Yesterday',
      'isUnread': false,
      'isVip': false,
      'bucket': 'important',
      'vipRole': null,
      'hasAttachments': false,
      'textDirection': 'ltr',
      'body': '''Team,

The automated QA suites passed on Sprint 4. The branch is staged and ready for client sign-off. Please complete regression passes by Wednesday 5 PM.

Thanks!
Sarah''',
      'extractedEvent': null,
      'attachments': [],
    },
    {
      'id': 'msg_004',
      'senderName': 'Omar Khaled ⭐',
      'senderEmail': 'omar.k@gmailoo.co',
      'senderAvatar': 'OK',
      'subject': 'Quick sync before the investor pitch',
      'snippet': 'Hey, got the updated deck. Let me know when you have 5 minutes to run through slide 7...',
      'receivedAt': 'Sep 30',
      'isUnread': true,
      'isVip': true,
      'bucket': 'vip',
      'vipRole': 'Co-Founder',
      'hasAttachments': false,
      'textDirection': 'ltr',
      'body': '''Hey Mahmoud,

The deck looks super crisp. Can we sync briefly for 5 mins to align on the ephemeral local wipe metrics?

Talk soon,
Omar''',
      'extractedEvent': null,
      'attachments': [],
    },
    {
      'id': 'msg_005',
      'senderName': 'GitHub Notifications',
      'senderEmail': 'notifications@github.com',
      'senderAvatar': 'GH',
      'subject': 'Your weekly digest: 4 PRs merged in flutter/flutter',
      'snippet': 'Here is what happened across your subscribed repositories this week. Flutter 3.24 released...',
      'receivedAt': 'Sep 29',
      'isUnread': false,
      'isVip': false,
      'bucket': 'marketing',
      'vipRole': null,
      'hasAttachments': false,
      'textDirection': 'ltr',
      'body': '''GitHub Digest:
- 4 pull requests merged
- 2 releases published
- Check out trending Flutter repositories.''',
      'extractedEvent': null,
      'attachments': [],
    },
  ];
}
```

### 4.3 Mock Zen Day Metrics & Settings Fixture
```dart
class MockZenDayFixture {
  static const snapshot = {
    'totalEmailsCleared': 48,
    'vipEmailsResolved': 4,
    'timetablesSynced': 12,
    'marketingMuted': 32,
    'hoursSaved': 3.5,
    'cycleLabel': 'Cycle 39 • Oct 3 - Oct 8',
    'resetTimestamp': '2026-10-09T00:00:00Z',
  };
}

class MockSettingsFixture {
  static const currentSettings = {
    'themeMode': 'light', // 'light', 'dark', 'system'
    'locale': 'ar-EG',    // 'ar-EG', 'en-US'
    'digitFormat': 'western', // 'western' (0-9) or 'arabic_indic' (٠-٩)
    'zenNotificationsOnly': true,
    'quietHoursEnabled': true,
    'quietHoursStart': '22:00',
    'quietHoursEnd': '08:00',
    'cachedStorageBytes': 14889728, // 14.2 MB
    'autoWipeOnFriday': true,
    'version': '0.1.0 (build 42)',
  };
}
```

---

## 5. Domain & Presentation Architecture Mapping

```
lib/
├── core/
│   ├── design_system/
│   │   ├── colors.dart          # GmailooColors ThemeExtension
│   │   ├── typography.dart      # Cairo & IBM Plex Sans TextTheme
│   │   └── theme.dart           # buildTheme(Brightness, Locale)
│   ├── mock/
│   │   └── mock_fixtures.dart   # Offline testing fixtures (Section 4)
│   └── utils/
│       └── bidi_detector.dart   # rune-based textDirectionOf(text)
├── features/
│   ├── auth/
│   │   ├── domain/entities/user.dart
│   │   └── presentation/
│   │       ├── cubit/auth_cubit.dart
│   │       └── pages/google_oauth_screen.dart
│   ├── inbox/
│   │   ├── domain/entities/email_item.dart
│   │   └── presentation/
│   │       ├── bloc/inbox_bloc.dart
│   │       ├── pages/inbox_home_screen.dart
│   │       ├── pages/email_detail_screen.dart
│   │       ├── pages/compose_modal_screen.dart
│   │       └── widgets/
│   │           ├── smart_bucket_chip_bar.dart
│   │           ├── email_feed_card.dart
│   │           └── cycle_status_badge.dart
│   ├── timetables/
│   │   ├── domain/entities/timetable_event.dart
│   │   └── presentation/
│   │       ├── cubit/timetable_cubit.dart
│   │       ├── pages/timetables_screen.dart
│   │       └── widgets/timetable_event_card.dart
│   ├── zen_day/
│   │   └── presentation/
│   │       ├── cubit/zen_day_cubit.dart
│   │       └── pages/zen_day_screen.dart
│   └── settings/
│       └── presentation/
│           ├── cubit/settings_cubit.dart
│           └── pages/settings_screen.dart
└── app/
    ├── app.dart                 # MaterialApp.router with ThemeExtensions
    ├── router.dart              # GoRouter config with bottom navbar shell
    └── injection.dart           # GetIt service locator setup
```

---

## 6. Front-End Acceptance Criteria & Quality Gates

Before declaring any front-end task complete:
1. **Device Fitting:** The UI must display without any pixel overflows (`A RenderFlex overflowed by N pixels`) on the iPhone 13 mini (`375 × 812`) in both Arabic (`ar-EG`) and English (`en-US`).
2. **Offline Interactivity:** Running the app with `MockRepositories` must allow navigating through all 6 screens seamlessly without network calls.
3. **Contrast Verification:** All body copy on surfaces must achieve `>= 4.5:1` WCAG AA contrast.
4. **Bucket Integrity:** Bucket accent colors must **never** be used as raw text color; use `onContainer` or `onSurface` as specified.
5. **Bidirectional Harmony:** Mixed subjects (e.g., `CS402 Exam - جدول الامتحانات`) must render without punctuation jumping or ligature breakdown.
