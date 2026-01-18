import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum AppThemeMode { system, light, dark }

enum AppLanguage { system, en, ar }

class AppSettings extends Equatable {
  final AppThemeMode themeMode;
  final AppLanguage language;
  final int ttsIterations;
  final Color seedColor;

  /// Notification settings
  final int wordsPerDay;

  /// Minutes from midnight (0..1439)
  final int notifyStartMinutes;
  final int notifyEndMinutes;

  const AppSettings({
    required this.themeMode,
    required this.language,
    required this.ttsIterations,
    required this.seedColor,
    required this.wordsPerDay,
    required this.notifyStartMinutes,
    required this.notifyEndMinutes,
  });

  const AppSettings.defaults()
    : this(
        themeMode: AppThemeMode.system,
        language: AppLanguage.system,
        ttsIterations: 1,
        seedColor: Colors.yellow,
        wordsPerDay: 10,
        notifyStartMinutes: 9 * 60,
        notifyEndMinutes: 21 * 60,
      );

  AppSettings copyWith({
    AppThemeMode? themeMode,
    AppLanguage? language,
    int? ttsIterations,
    Color? seedColor,
    int? wordsPerDay,
    int? notifyStartMinutes,
    int? notifyEndMinutes,
  }) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      language: language ?? this.language,
      ttsIterations: ttsIterations ?? this.ttsIterations,
      seedColor: seedColor ?? this.seedColor,
      wordsPerDay: wordsPerDay ?? this.wordsPerDay,
      notifyStartMinutes: notifyStartMinutes ?? this.notifyStartMinutes,
      notifyEndMinutes: notifyEndMinutes ?? this.notifyEndMinutes,
    );
  }

  @override
  List<Object?> get props => [
    themeMode,
    language,
    ttsIterations,
    seedColor,
    wordsPerDay,
    notifyStartMinutes,
    notifyEndMinutes,
  ];
}
