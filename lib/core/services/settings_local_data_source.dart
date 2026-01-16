import 'package:shared_preferences/shared_preferences.dart';

import 'app_settings.dart';

abstract class SettingsLocalDataSource {
  Future<AppSettings> read();
  Future<void> write(AppSettings settings);
}

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  static const _themeModeKey = 'settings_theme_mode';
  static const _languageKey = 'settings_language';
  static const _ttsIterationsKey = 'settings_tts_iterations';

  final SharedPreferences prefs;
  const SettingsLocalDataSourceImpl(this.prefs);

  @override
  Future<AppSettings> read() async {
    final themeIndex = prefs.getInt(_themeModeKey);
    final langIndex = prefs.getInt(_languageKey);
    final iterations = prefs.getInt(_ttsIterationsKey) ?? 1;

    final themeMode = (themeIndex == null)
        ? AppThemeMode.system
        : AppThemeMode.values[themeIndex.clamp(
            0,
            AppThemeMode.values.length - 1,
          )];
    final language = (langIndex == null)
        ? AppLanguage.system
        : AppLanguage.values[langIndex.clamp(0, AppLanguage.values.length - 1)];

    return AppSettings(
      themeMode: themeMode,
      language: language,
      ttsIterations: iterations.clamp(1, 10),
    );
  }

  @override
  Future<void> write(AppSettings settings) async {
    await prefs.setInt(_themeModeKey, settings.themeMode.index);
    await prefs.setInt(_languageKey, settings.language.index);
    await prefs.setInt(_ttsIterationsKey, settings.ttsIterations);
  }
}
