// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Gmailoo';

  @override
  String get tagline => 'Ephemeral & Calm Email';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get done => 'Done';

  @override
  String get back => 'Back';

  @override
  String get searchHint => 'Search this week\'s mail...';

  @override
  String get openInGmail => 'Open in Gmail';

  @override
  String get reply => 'Reply';

  @override
  String get forward => 'Forward';

  @override
  String get send => 'Send';

  @override
  String get compose => 'Compose';

  @override
  String get tabInbox => 'Inbox';

  @override
  String get tabTimetables => 'Timetables';

  @override
  String get tabVips => 'VIPs';

  @override
  String get tabSettings => 'Settings';

  @override
  String get splashSyncing => 'Syncing this week\'s mail...';

  @override
  String get splashSecurityFootnote =>
      'Encrypted & Local Only • Powered by Gmail API';

  @override
  String get onboardingSkip => 'Skip';

  @override
  String get onboardingTitle1 => 'Email that clears itself. Zero anxiety.';

  @override
  String get onboardingBody1 =>
      'Only see this week\'s emails. Marketing noise is silenced, exam timetables are prioritized, and every Friday gives you a fresh start.';

  @override
  String get onboardingTitle2 => 'Friday Zen Day: Automatic Local Reset';

  @override
  String get onboardingBody2 =>
      'Every Friday, your inbox empties so you can truly disconnect for the weekend. Your Gmail archive is always safe and untouched.';

  @override
  String get onboardingTitle3 => 'Smart Buckets & VIP Priority';

  @override
  String get onboardingBody3 =>
      'Timetables, important unread, and VIP contacts get clear signals. No notification unless it truly matters.';

  @override
  String get onboardingGetStarted => 'Get Started';

  @override
  String get onboardingSignInPrompt => 'Already have an account? Sign In';

  @override
  String get authHeadline => 'Connect Your Google Account';

  @override
  String get authSubtitle =>
      'Link your Gmail securely to experience an ephemeral, stress-free inbox.';

  @override
  String get authContinueWithGoogle => 'Continue with Google';

  @override
  String get authTrustPoint1 =>
      'Reads & auto-sorts only mail from the current week.';

  @override
  String get authTrustPoint2 =>
      'Sends replies & schedules messages upon your request.';

  @override
  String get authTrustPoint3 =>
      'Local-only ephemeral wipe: Original emails are never deleted in Gmail.';

  @override
  String get authTrustPoint4 =>
      'No third-party tracking, advertising, or selling.';

  @override
  String get authOfficialScopeBadge =>
      'Official Google OAuth 2.0 Restricted Scope Verified';

  @override
  String get authLegalFooter =>
      'Complies with Egypt PDPL (Law 151/2020) & Google API User Data Policy.';

  @override
  String get bucketAll => 'All';

  @override
  String get bucketImportantUnread => 'Important unread';

  @override
  String get bucketImportant => 'Important';

  @override
  String get bucketTimetables => 'Timetables';

  @override
  String get bucketMarketing => 'Marketing';

  @override
  String get bucketVip => 'VIP';

  @override
  String cycleStatusBadge(int days) {
    return 'This Week • ${days}d left';
  }

  @override
  String get emptyInbox => 'You\'re all caught up for this week.';

  @override
  String get emptyFilter => 'No emails in this bucket.';

  @override
  String get syncedWithGmail => 'Synced with Gmail';

  @override
  String daysRemaining(int days) {
    return '${days}d remaining';
  }

  @override
  String get addToCalendar => 'Add to Calendar';

  @override
  String get eventSynced => 'Synced to Google Calendar';

  @override
  String get downloadAttachment => 'Download Attachment';

  @override
  String get timetablesTitle => 'Timetables & Schedules';

  @override
  String get timetablesBanner =>
      'Verified Events Detected from Email • Wipes Friday on Zen Day';

  @override
  String get filterAll => 'All';

  @override
  String get filterExams => 'Exams';

  @override
  String get filterLectures => 'Lectures';

  @override
  String get filterDeadlines => 'Deadlines';

  @override
  String get vipsTitle => 'VIP Senders';

  @override
  String get vipsSubtitle =>
      'VIP emails always bypass marketing filters and trigger notifications.';

  @override
  String get addVip => 'Add VIP Sender';

  @override
  String get vipProfessor => 'Professor';

  @override
  String get vipWork => 'Work';

  @override
  String get zenDayTitle => 'You\'re Done for the Week.';

  @override
  String get zenDaySubtitleAr => 'Clean inbox, calm mind';

  @override
  String get zenDayDescription =>
      'Every email from this week has been cleared from your device so you can disconnect. Remember, all your original emails are untouched and safely preserved in Gmail.';

  @override
  String get zenStatCleared => 'Emails Cleared';

  @override
  String get zenStatVip => 'VIP & Priority Attended';

  @override
  String get zenStatTimetables => 'Timetables Synced';

  @override
  String get zenStatMarketing => 'Marketing Pitches Muted';

  @override
  String zenNextCycle(int hours) {
    return 'Next cycle begins Saturday • Resets in ${hours}h';
  }

  @override
  String get zenEnjoyWeekend => 'Enjoy Your Weekend 🌿';

  @override
  String get zenTrustBadge => 'Zero unread anxiety • 100% ephemeral privacy';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsAccount => 'Connected Account';

  @override
  String get settingsAppearance => 'Appearance & Display';

  @override
  String get settingsTheme => 'Theme';

  @override
  String get settingsThemeLight => 'Light';

  @override
  String get settingsThemeDark => 'Dark';

  @override
  String get settingsThemeSystem => 'System';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsLanguageAr => 'العربية (Arabic)';

  @override
  String get settingsLanguageEn => 'English';

  @override
  String get settingsDigits => 'Digit Style';

  @override
  String get settingsDigitsWestern => 'Western (0-9)';

  @override
  String get settingsDigitsIndic => 'Arabic-Indic (٠-٩)';

  @override
  String get settingsNotifications => 'Zen Notifications';

  @override
  String get settingsNotificationsDesc =>
      'Only VIPs and Important Unread trigger notifications';

  @override
  String get settingsQuietHours => 'Quiet Hours (10:00 PM – 8:00 AM)';

  @override
  String get settingsStorage => 'Ephemeral Local Storage';

  @override
  String settingsCacheSize(String size) {
    return 'Cached Locally: $size';
  }

  @override
  String get settingsClearCache => 'Clear Local Cache Now';

  @override
  String get settingsSignOut => 'Sign Out & Revoke Local Access';

  @override
  String get settingsVersion => 'Gmailoo Version';

  @override
  String get composeTitle => 'New Message';

  @override
  String get toField => 'To';

  @override
  String get subjectField => 'Subject';

  @override
  String get bodyField => 'Write your message...';

  @override
  String get scheduleSend => 'Schedule Send';

  @override
  String get discard => 'Discard';
}
