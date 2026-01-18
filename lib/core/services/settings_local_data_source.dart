import 'package:flutter/material.dart';
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
  static const _seedColorKey = 'settings_seed_color';
  static const _wordsPerDayKey = 'settings_words_per_day';
  static const _notifyStartMinutesKey = 'settings_notify_start_minutes';
  static const _notifyEndMinutesKey = 'settings_notify_end_minutes';

  final SharedPreferences prefs;
  const SettingsLocalDataSourceImpl(this.prefs);

  @override
  Future<AppSettings> read() async {
    final themeIndex = prefs.getInt(_themeModeKey);
    final langIndex = prefs.getInt(_languageKey);
    final iterations = prefs.getInt(_ttsIterationsKey) ?? 1;
    final seedColorValue = prefs.getInt(_seedColorKey);

    final wordsPerDay = prefs.getInt(_wordsPerDayKey);
    final notifyStartMinutes = prefs.getInt(_notifyStartMinutesKey);
    final notifyEndMinutes = prefs.getInt(_notifyEndMinutesKey);

    final themeMode = (themeIndex == null)
        ? AppThemeMode.system
        : AppThemeMode.values[themeIndex.clamp(
            0,
            AppThemeMode.values.length - 1,
          )];
    final language = (langIndex == null)
        ? AppLanguage.system
        : AppLanguage.values[langIndex.clamp(0, AppLanguage.values.length - 1)];

    final defaults = const AppSettings.defaults();

    return AppSettings(
      themeMode: themeMode,
      language: language,
      ttsIterations: iterations.clamp(1, 10),
      seedColor: seedColorValue == null
          ? defaults.seedColor
          : Color(seedColorValue),
      wordsPerDay: (wordsPerDay ?? defaults.wordsPerDay).clamp(0, 100),
      notifyStartMinutes: (notifyStartMinutes ?? defaults.notifyStartMinutes)
          .clamp(0, 1439),
      notifyEndMinutes: (notifyEndMinutes ?? defaults.notifyEndMinutes).clamp(
        0,
        1439,
      ),
    );
  }

  @override
  Future<void> write(AppSettings settings) async {
    await prefs.setInt(_themeModeKey, settings.themeMode.index);
    await prefs.setInt(_languageKey, settings.language.index);
    await prefs.setInt(_ttsIterationsKey, settings.ttsIterations);
    await prefs.setInt(_seedColorKey, settings.seedColor.toARGB32());

    await prefs.setInt(_wordsPerDayKey, settings.wordsPerDay);
    await prefs.setInt(_notifyStartMinutesKey, settings.notifyStartMinutes);
    await prefs.setInt(_notifyEndMinutesKey, settings.notifyEndMinutes);
  }
}
