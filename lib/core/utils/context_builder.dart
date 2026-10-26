// lib/core/utils/context_builder.dart
import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../design_system/colors.dart';

/// Convenient BuildContext extensions providing direct, strongly-typed
/// access to theme tokens, typography, localization, media queries, and layout.
extension ContextBuilder on BuildContext {
  // ==========================================
  // Localization
  // ==========================================

  /// Current app localization dictionary.
  AppLocalizations get l10n {
    final localizations = AppLocalizations.of(this);
    if (localizations == null) {
      throw FlutterError(
        'AppLocalizations not found in BuildContext. Ensure that MaterialApp includes '
        'AppLocalizations.localizationsDelegates and supportedLocales.',
      );
    }
    return localizations;
  }

  /// Current active locale.
  Locale get locale => Localizations.localeOf(this);

  /// True if current locale language is Arabic.
  bool get isArabic => locale.languageCode == 'ar';

  /// True if text direction is right-to-left.
  bool get isRtl => Directionality.of(this) == TextDirection.rtl;

  // ==========================================
  // Design System Colors & Theme
  // ==========================================

  /// Complete GmailooColors design tokens (surface, primary, outline, buckets, etc.).
  GmailooColors get colors =>
      Theme.of(this).extension<GmailooColors>() ?? GmailooColors.light;

  /// Smart buckets palette (unread, important, timetables, marketing, vip).
  BucketPalette get buckets => colors.buckets;

  /// Active ThemeData.
  ThemeData get theme => Theme.of(this);

  /// Active TextTheme (Cairo display & IBM Plex Sans Arabic).
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// Active Material 3 ColorScheme.
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  /// True if currently in Dark Theme mode.
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  /// True if currently in Light Theme mode.
  bool get isLightMode => Theme.of(this).brightness == Brightness.light;

  // ==========================================
  // Responsive Screen & MediaQuery
  // ==========================================

  /// Full MediaQuery data.
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  /// Current screen size.
  Size get screenSize => MediaQuery.sizeOf(this);

  /// Current screen width.
  double get screenWidth => MediaQuery.sizeOf(this).width;

  /// Current screen height.
  double get screenHeight => MediaQuery.sizeOf(this).height;

  /// Device status bar & notch padding.
  EdgeInsets get screenPadding => MediaQuery.paddingOf(this);

  /// Device keyboard insets.
  EdgeInsets get viewInsets => MediaQuery.viewInsetsOf(this);

  // ==========================================
  // Feedback & SnackBar Helpers
  // ==========================================

  /// ScaffoldMessenger reference.
  ScaffoldMessengerState get scaffoldMessenger => ScaffoldMessenger.of(this);

  /// Show a quick text snackbar with default styling.
  void showTextSnackBar(String message, {Duration duration = const Duration(seconds: 2)}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration,
      ),
    );
  }
}
