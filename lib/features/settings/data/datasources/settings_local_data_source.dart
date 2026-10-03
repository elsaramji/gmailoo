import '../models/app_settings_model.dart';

abstract class SettingsLocalDataSource {
  Future<AppSettingsModel> loadSettings();
  Future<void> persistSettings(AppSettingsModel settings);
}
