import 'package:equatable/equatable.dart';

enum AppThemeMode { system, light, dark }

enum AppLanguage { system, en, ar }

class AppSettings extends Equatable {
  final AppThemeMode themeMode;
  final AppLanguage language;
  final int ttsIterations;

  const AppSettings({
    required this.themeMode,
    required this.language,
    required this.ttsIterations,
  });

  const AppSettings.defaults()
    : this(
        themeMode: AppThemeMode.system,
        language: AppLanguage.system,
        ttsIterations: 1,
      );

  AppSettings copyWith({
    AppThemeMode? themeMode,
    AppLanguage? language,
    int? ttsIterations,
  }) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      language: language ?? this.language,
      ttsIterations: ttsIterations ?? this.ttsIterations,
    );
  }

  @override
  List<Object?> get props => [themeMode, language, ttsIterations];
}
