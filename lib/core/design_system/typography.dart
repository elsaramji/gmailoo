// lib/core/design_system/typography.dart
import 'package:flutter/material.dart';

class GmailooTypography {
  static const String displayFont = 'Cairo';
  static const String uiFont = 'IBMPlexSansArabic';

  static TextTheme gmailooTextTheme(Locale locale, Color color) {
    final isArabic = locale.languageCode == 'ar';

    TextStyle s({
      required double latin,
      required double latinLine,
      required double arabic,
      required double arabicLine,
      required FontWeight weight,
      String family = uiFont,
    }) {
      final size = isArabic ? arabic : latin;
      final line = isArabic ? arabicLine : latinLine;
      return TextStyle(
        fontFamily: family,
        fontFamilyFallback: family == displayFont
            ? const [uiFont, 'Roboto']
            : const ['Roboto'],
        fontSize: size,
        height: line / size, // Multiplier of font size
        fontWeight: weight,
        letterSpacing: 0, // Mandatory for Arabic letter joining
        color: color,
      );
    }

    return TextTheme(
      displayLarge: s(
        latin: 32,
        latinLine: 40,
        arabic: 32,
        arabicLine: 48,
        weight: FontWeight.w700,
        family: displayFont,
      ),
      headlineMedium: s(
        latin: 24,
        latinLine: 32,
        arabic: 24,
        arabicLine: 38,
        weight: FontWeight.w700,
        family: displayFont,
      ),
      headlineSmall: s(
        latin: 20,
        latinLine: 28,
        arabic: 20,
        arabicLine: 32,
        weight: FontWeight.w600,
        family: displayFont,
      ),
      titleMedium: s(
        latin: 16,
        latinLine: 24,
        arabic: 17,
        arabicLine: 28,
        weight: FontWeight.w600,
      ),
      titleSmall: s(
        latin: 14,
        latinLine: 20,
        arabic: 15,
        arabicLine: 24,
        weight: FontWeight.w600,
      ),
      bodyLarge: s(
        latin: 16,
        latinLine: 24,
        arabic: 17,
        arabicLine: 28,
        weight: FontWeight.w400,
      ),
      bodyMedium: s(
        latin: 14,
        latinLine: 20,
        arabic: 15,
        arabicLine: 24,
        weight: FontWeight.w400,
      ),
      bodySmall: s(
        latin: 12,
        latinLine: 16,
        arabic: 13,
        arabicLine: 20,
        weight: FontWeight.w400,
      ),
      labelLarge: s(
        latin: 14,
        latinLine: 20,
        arabic: 15,
        arabicLine: 22,
        weight: FontWeight.w500,
      ),
      labelMedium: s(
        latin: 12,
        latinLine: 16,
        arabic: 13,
        arabicLine: 18,
        weight: FontWeight.w500,
      ),
      labelSmall: s(
        latin: 11,
        latinLine: 16,
        arabic: 12,
        arabicLine: 18,
        weight: FontWeight.w500,
      ),
    );
  }
}
