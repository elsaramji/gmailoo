import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Gmailoo'**
  String get appName;

  /// No description provided for @tagline.
  ///
  /// In en, this message translates to:
  /// **'Ephemeral & Calm Email'**
  String get tagline;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search this week\'s mail...'**
  String get searchHint;

  /// No description provided for @openInGmail.
  ///
  /// In en, this message translates to:
  /// **'Open in Gmail'**
  String get openInGmail;

  /// No description provided for @reply.
  ///
  /// In en, this message translates to:
  /// **'Reply'**
  String get reply;

  /// No description provided for @forward.
  ///
  /// In en, this message translates to:
  /// **'Forward'**
  String get forward;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @compose.
  ///
  /// In en, this message translates to:
  /// **'Compose'**
  String get compose;

  /// No description provided for @tabInbox.
  ///
  /// In en, this message translates to:
  /// **'Inbox'**
  String get tabInbox;

  /// No description provided for @tabTimetables.
  ///
  /// In en, this message translates to:
  /// **'Timetables'**
  String get tabTimetables;

  /// No description provided for @tabVips.
  ///
  /// In en, this message translates to:
  /// **'VIPs'**
  String get tabVips;

  /// No description provided for @tabSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get tabSettings;

  /// No description provided for @splashSyncing.
  ///
  /// In en, this message translates to:
  /// **'Syncing this week\'s mail...'**
  String get splashSyncing;

  /// No description provided for @splashSecurityFootnote.
  ///
  /// In en, this message translates to:
  /// **'Encrypted & Local Only • Powered by Gmail API'**
  String get splashSecurityFootnote;

  /// No description provided for @onboardingSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get onboardingSkip;

  /// No description provided for @onboardingTitle1.
  ///
  /// In en, this message translates to:
  /// **'Email that clears itself. Zero anxiety.'**
  String get onboardingTitle1;

  /// No description provided for @onboardingBody1.
  ///
  /// In en, this message translates to:
  /// **'Only see this week\'s emails. Marketing noise is silenced, exam timetables are prioritized, and every Friday gives you a fresh start.'**
  String get onboardingBody1;

  /// No description provided for @onboardingTitle2.
  ///
  /// In en, this message translates to:
  /// **'Friday Zen Day: Automatic Local Reset'**
  String get onboardingTitle2;

  /// No description provided for @onboardingBody2.
  ///
  /// In en, this message translates to:
  /// **'Every Friday, your inbox empties so you can truly disconnect for the weekend. Your Gmail archive is always safe and untouched.'**
  String get onboardingBody2;

  /// No description provided for @onboardingTitle3.
  ///
  /// In en, this message translates to:
  /// **'Smart Buckets & VIP Priority'**
  String get onboardingTitle3;

  /// No description provided for @onboardingBody3.
  ///
  /// In en, this message translates to:
  /// **'Timetables, important unread, and VIP contacts get clear signals. No notification unless it truly matters.'**
  String get onboardingBody3;

  /// No description provided for @onboardingGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get onboardingGetStarted;

  /// No description provided for @onboardingSignInPrompt.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Sign In'**
  String get onboardingSignInPrompt;

  /// No description provided for @authHeadline.
  ///
  /// In en, this message translates to:
  /// **'Connect Your Google Account'**
  String get authHeadline;

  /// No description provided for @authSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Link your Gmail securely to experience an ephemeral, stress-free inbox.'**
  String get authSubtitle;

  /// No description provided for @authContinueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get authContinueWithGoogle;

  /// No description provided for @authTrustPoint1.
  ///
  /// In en, this message translates to:
  /// **'Reads & auto-sorts only mail from the current week.'**
  String get authTrustPoint1;

  /// No description provided for @authTrustPoint2.
  ///
  /// In en, this message translates to:
  /// **'Sends replies & schedules messages upon your request.'**
  String get authTrustPoint2;

  /// No description provided for @authTrustPoint3.
  ///
  /// In en, this message translates to:
  /// **'Local-only ephemeral wipe: Original emails are never deleted in Gmail.'**
  String get authTrustPoint3;

  /// No description provided for @authTrustPoint4.
  ///
  /// In en, this message translates to:
  /// **'No third-party tracking, advertising, or selling.'**
  String get authTrustPoint4;

  /// No description provided for @authOfficialScopeBadge.
  ///
  /// In en, this message translates to:
  /// **'Official Google OAuth 2.0 Restricted Scope Verified'**
  String get authOfficialScopeBadge;

  /// No description provided for @authLegalFooter.
  ///
  /// In en, this message translates to:
  /// **'Complies with Egypt PDPL (Law 151/2020) & Google API User Data Policy.'**
  String get authLegalFooter;

  /// No description provided for @bucketAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get bucketAll;

  /// No description provided for @bucketImportantUnread.
  ///
  /// In en, this message translates to:
  /// **'Important unread'**
  String get bucketImportantUnread;

  /// No description provided for @bucketImportant.
  ///
  /// In en, this message translates to:
  /// **'Important'**
  String get bucketImportant;

  /// No description provided for @bucketTimetables.
  ///
  /// In en, this message translates to:
  /// **'Timetables'**
  String get bucketTimetables;

  /// No description provided for @bucketMarketing.
  ///
  /// In en, this message translates to:
  /// **'Marketing'**
  String get bucketMarketing;

  /// No description provided for @bucketVip.
  ///
  /// In en, this message translates to:
  /// **'VIP'**
  String get bucketVip;

  /// No description provided for @cycleStatusBadge.
  ///
  /// In en, this message translates to:
  /// **'This Week • {days}d left'**
  String cycleStatusBadge(int days);

  /// No description provided for @emptyInbox.
  ///
  /// In en, this message translates to:
  /// **'You\'re all caught up for this week.'**
  String get emptyInbox;

  /// No description provided for @emptyFilter.
  ///
  /// In en, this message translates to:
  /// **'No emails in this bucket.'**
  String get emptyFilter;

  /// No description provided for @syncedWithGmail.
  ///
  /// In en, this message translates to:
  /// **'Synced with Gmail'**
  String get syncedWithGmail;

  /// No description provided for @daysRemaining.
  ///
  /// In en, this message translates to:
  /// **'{days}d remaining'**
  String daysRemaining(int days);

  /// No description provided for @addToCalendar.
  ///
  /// In en, this message translates to:
  /// **'Add to Calendar'**
  String get addToCalendar;

  /// No description provided for @eventSynced.
  ///
  /// In en, this message translates to:
  /// **'Synced to Google Calendar'**
  String get eventSynced;

  /// No description provided for @downloadAttachment.
  ///
  /// In en, this message translates to:
  /// **'Download Attachment'**
  String get downloadAttachment;

  /// No description provided for @timetablesTitle.
  ///
  /// In en, this message translates to:
  /// **'Timetables & Schedules'**
  String get timetablesTitle;

  /// No description provided for @timetablesBanner.
  ///
  /// In en, this message translates to:
  /// **'Verified Events Detected from Email • Wipes Friday on Zen Day'**
  String get timetablesBanner;

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @filterExams.
  ///
  /// In en, this message translates to:
  /// **'Exams'**
  String get filterExams;

  /// No description provided for @filterLectures.
  ///
  /// In en, this message translates to:
  /// **'Lectures'**
  String get filterLectures;

  /// No description provided for @filterDeadlines.
  ///
  /// In en, this message translates to:
  /// **'Deadlines'**
  String get filterDeadlines;

  /// No description provided for @vipsTitle.
  ///
  /// In en, this message translates to:
  /// **'VIP Senders'**
  String get vipsTitle;

  /// No description provided for @vipsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'VIP emails always bypass marketing filters and trigger notifications.'**
  String get vipsSubtitle;

  /// No description provided for @addVip.
  ///
  /// In en, this message translates to:
  /// **'Add VIP Sender'**
  String get addVip;

  /// No description provided for @vipProfessor.
  ///
  /// In en, this message translates to:
  /// **'Professor'**
  String get vipProfessor;

  /// No description provided for @vipWork.
  ///
  /// In en, this message translates to:
  /// **'Work'**
  String get vipWork;

  /// No description provided for @zenDayTitle.
  ///
  /// In en, this message translates to:
  /// **'You\'re Done for the Week.'**
  String get zenDayTitle;

  /// No description provided for @zenDaySubtitleAr.
  ///
  /// In en, this message translates to:
  /// **'Clean inbox, calm mind'**
  String get zenDaySubtitleAr;

  /// No description provided for @zenDayDescription.
  ///
  /// In en, this message translates to:
  /// **'Every email from this week has been cleared from your device so you can disconnect. Remember, all your original emails are untouched and safely preserved in Gmail.'**
  String get zenDayDescription;

  /// No description provided for @zenStatCleared.
  ///
  /// In en, this message translates to:
  /// **'Emails Cleared'**
  String get zenStatCleared;

  /// No description provided for @zenStatVip.
  ///
  /// In en, this message translates to:
  /// **'VIP & Priority Attended'**
  String get zenStatVip;

  /// No description provided for @zenStatTimetables.
  ///
  /// In en, this message translates to:
  /// **'Timetables Synced'**
  String get zenStatTimetables;

  /// No description provided for @zenStatMarketing.
  ///
  /// In en, this message translates to:
  /// **'Marketing Pitches Muted'**
  String get zenStatMarketing;

  /// No description provided for @zenNextCycle.
  ///
  /// In en, this message translates to:
  /// **'Next cycle begins Saturday • Resets in {hours}h'**
  String zenNextCycle(int hours);

  /// No description provided for @zenEnjoyWeekend.
  ///
  /// In en, this message translates to:
  /// **'Enjoy Your Weekend 🌿'**
  String get zenEnjoyWeekend;

  /// No description provided for @zenTrustBadge.
  ///
  /// In en, this message translates to:
  /// **'Zero unread anxiety • 100% ephemeral privacy'**
  String get zenTrustBadge;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsAccount.
  ///
  /// In en, this message translates to:
  /// **'Connected Account'**
  String get settingsAccount;

  /// No description provided for @settingsAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance & Display'**
  String get settingsAppearance;

  /// No description provided for @settingsTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingsTheme;

  /// No description provided for @settingsThemeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get settingsThemeLight;

  /// No description provided for @settingsThemeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get settingsThemeDark;

  /// No description provided for @settingsThemeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get settingsThemeSystem;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsLanguageAr.
  ///
  /// In en, this message translates to:
  /// **'العربية (Arabic)'**
  String get settingsLanguageAr;

  /// No description provided for @settingsLanguageEn.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get settingsLanguageEn;

  /// No description provided for @settingsDigits.
  ///
  /// In en, this message translates to:
  /// **'Digit Style'**
  String get settingsDigits;

  /// No description provided for @settingsDigitsWestern.
  ///
  /// In en, this message translates to:
  /// **'Western (0-9)'**
  String get settingsDigitsWestern;

  /// No description provided for @settingsDigitsIndic.
  ///
  /// In en, this message translates to:
  /// **'Arabic-Indic (٠-٩)'**
  String get settingsDigitsIndic;

  /// No description provided for @settingsNotifications.
  ///
  /// In en, this message translates to:
  /// **'Zen Notifications'**
  String get settingsNotifications;

  /// No description provided for @settingsNotificationsDesc.
  ///
  /// In en, this message translates to:
  /// **'Only VIPs and Important Unread trigger notifications'**
  String get settingsNotificationsDesc;

  /// No description provided for @settingsQuietHours.
  ///
  /// In en, this message translates to:
  /// **'Quiet Hours (10:00 PM – 8:00 AM)'**
  String get settingsQuietHours;

  /// No description provided for @settingsStorage.
  ///
  /// In en, this message translates to:
  /// **'Ephemeral Local Storage'**
  String get settingsStorage;

  /// No description provided for @settingsCacheSize.
  ///
  /// In en, this message translates to:
  /// **'Cached Locally: {size}'**
  String settingsCacheSize(String size);

  /// No description provided for @settingsClearCache.
  ///
  /// In en, this message translates to:
  /// **'Clear Local Cache Now'**
  String get settingsClearCache;

  /// No description provided for @settingsSignOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out & Revoke Local Access'**
  String get settingsSignOut;

  /// No description provided for @settingsVersion.
  ///
  /// In en, this message translates to:
  /// **'Gmailoo Version'**
  String get settingsVersion;

  /// No description provided for @composeTitle.
  ///
  /// In en, this message translates to:
  /// **'New Message'**
  String get composeTitle;

  /// No description provided for @toField.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get toField;

  /// No description provided for @subjectField.
  ///
  /// In en, this message translates to:
  /// **'Subject'**
  String get subjectField;

  /// No description provided for @bodyField.
  ///
  /// In en, this message translates to:
  /// **'Write your message...'**
  String get bodyField;

  /// No description provided for @scheduleSend.
  ///
  /// In en, this message translates to:
  /// **'Schedule Send'**
  String get scheduleSend;

  /// No description provided for @discard.
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get discard;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
