import 'package:bloc/bloc.dart';

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
}
