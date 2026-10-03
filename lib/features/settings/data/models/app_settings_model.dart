import '../../domain/entities/app_settings.dart';

class AppSettingsModel extends AppSettings {
  const AppSettingsModel({
    required super.locale,
    required super.timezone,
    super.useArabicIndicDigits,
    super.quietHoursEnabled,
  });

  factory AppSettingsModel.fromJson(Map<String, dynamic> json) {
    return AppSettingsModel(
      locale: json['locale'] as String,
      timezone: json['timezone'] as String,
      useArabicIndicDigits: json['useArabicIndicDigits'] as bool? ?? false,
      quietHoursEnabled: json['quietHoursEnabled'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'locale': locale,
    'timezone': timezone,
    'useArabicIndicDigits': useArabicIndicDigits,
    'quietHoursEnabled': quietHoursEnabled,
  };
}
