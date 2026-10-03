import 'package:equatable/equatable.dart';

class AppSettings extends Equatable {
  final String locale;
  final String timezone;
  final bool useArabicIndicDigits;
  final bool quietHoursEnabled;

  const AppSettings({
    required this.locale,
    required this.timezone,
    this.useArabicIndicDigits = false,
    this.quietHoursEnabled = false,
  });

  @override
  List<Object?> get props => [locale, timezone, useArabicIndicDigits, quietHoursEnabled];
}
