import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../../../core/services/app_settings.dart';
import '../../../../core/services/settings_local_data_source.dart';

class SettingsCubit extends Cubit<AppSettings> {
  final SettingsLocalDataSource local;

  SettingsCubit({required this.local}) : super(const AppSettings.defaults());

  Future<void> load() async {
    emit(await local.read());
  }

  Future<void> setThemeMode(AppThemeMode mode) async {
    final next = state.copyWith(themeMode: mode);
    emit(next);
    await local.write(next);
  }

  Future<void> setSeedColor(Color color) async {
    final next = state.copyWith(seedColor: color);
    emit(next);
    await local.write(next);
  }

  Future<void> setLanguage(AppLanguage language) async {
    final next = state.copyWith(language: language);
    emit(next);
    await local.write(next);
  }

  Future<void> setTtsIterations(int iterations) async {
    final next = state.copyWith(ttsIterations: iterations.clamp(1, 10));
    emit(next);
    await local.write(next);
  }

  Future<void> setWordsPerDay(int value) async {
    final next = state.copyWith(wordsPerDay: value.clamp(0, 100));
    emit(next);
    await local.write(next);
  }

  Future<void> setNotifyStartMinutes(int minutes) async {
    final next = state.copyWith(notifyStartMinutes: minutes.clamp(0, 1439));
    emit(next);
    await local.write(next);
  }

  Future<void> setNotifyEndMinutes(int minutes) async {
    final next = state.copyWith(notifyEndMinutes: minutes.clamp(0, 1439));
    emit(next);
    await local.write(next);
  }
}
