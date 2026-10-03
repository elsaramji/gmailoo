import 'package:flutter/material.dart';
import '../../core/design_system/colors.dart';

class AppTheme {
  static ThemeData get lightTheme => ThemeData.light().copyWith(
        extensions: const [GmailooColors.light],
      );

  static ThemeData get darkTheme => ThemeData.dark().copyWith(
        extensions: const [GmailooColors.dark],
      );
}
