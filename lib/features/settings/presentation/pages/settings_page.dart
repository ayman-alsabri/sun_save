import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_save/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:sun_save/l10n/app_localizations.dart';

import '../../../../app/di/injection_container.dart';
import '../../../../app/router/app_router.dart';
import '../../../../core/services/app_settings.dart';
import '../../../../core/services/notifications_service.dart';
import '../../../words/presentation/bloc/words_bloc.dart';
import '../bloc/settings_cubit.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: BlocListener<SettingsCubit, AppSettings>(
        listenWhen: (p, c) =>
            p.wordsPerDay != c.wordsPerDay ||
            p.notifyStartMinutes != c.notifyStartMinutes ||
            p.notifyEndMinutes != c.notifyEndMinutes,
        listener: (context, settings) async {
          final service = sl<NotificationsService>();
          await service.requestPermissions();
        },
        child: BlocBuilder<SettingsCubit, AppSettings>(
          builder: (context, state) {
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  l10n.theme,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                SegmentedButton<AppThemeMode>(
                  segments: [
                    ButtonSegment(
                      value: AppThemeMode.system,
                      label: Text(l10n.system),
                    ),
                    ButtonSegment(
                      value: AppThemeMode.light,
                      label: Text(l10n.light),
                    ),
                    ButtonSegment(
                      value: AppThemeMode.dark,
                      label: Text(l10n.dark),
                    ),
                  ],
                  selected: {state.themeMode},
                  onSelectionChanged: (s) =>
                      context.read<SettingsCubit>().setThemeMode(s.first),
                ),
                const SizedBox(height: 16),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(l10n.theme),
                  subtitle: Text(l10n.appTitle),
                  trailing: CircleAvatar(
                    backgroundColor: state.seedColor,
                    radius: 12,
                  ),
                  onTap: () async {
                    var temp = state.seedColor;
                    final picked = await ColorPicker(
                      color: state.seedColor,
                      onColorChanged: (c) => temp = c,
                      width: 40,
                      height: 40,
                      borderRadius: 20,
                      heading: Text(
                        l10n.theme,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      showColorCode: true,
                      colorCodeHasColor: true,
                    ).showPickerDialog(context);

                    if (picked == true && context.mounted) {
                      await context.read<SettingsCubit>().setSeedColor(temp);
                    }
                  },
                ),
                const SizedBox(height: 24),
                Text(
                  l10n.notifications,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(l10n.wordsPerDay),
                  subtitle: Text('${state.wordsPerDay}'),
                  trailing: SizedBox(
                    width: 140,
                    child: Slider(
                      min: 0,
                      max: 50,
                      divisions: 50,
                      label: '${state.wordsPerDay}',
                      value: state.wordsPerDay.toDouble(),
                      onChanged: (v) => context
                          .read<SettingsCubit>()
                          .setWordsPerDay(v.round()),
                    ),
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(l10n.notifyStartTime),
                  trailing: Text(
                    _formatMinutes(context, state.notifyStartMinutes),
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  onTap: () async {
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: _minutesToTimeOfDay(
                        state.notifyStartMinutes,
                      ),
                    );
                    if (picked == null || !context.mounted) return;
                    await context.read<SettingsCubit>().setNotifyStartMinutes(
                      picked.hour * 60 + picked.minute,
                    );
                  },
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(l10n.notifyEndTime),
                  trailing: Text(
                    _formatMinutes(context, state.notifyEndMinutes),
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  onTap: () async {
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: _minutesToTimeOfDay(state.notifyEndMinutes),
                    );
                    if (picked == null || !context.mounted) return;
                    await context.read<SettingsCubit>().setNotifyEndMinutes(
                      picked.hour * 60 + picked.minute,
                    );
                  },
                ),
                const SizedBox(height: 8),
                BlocBuilder<WordsBloc, WordsState>(
                  buildWhen: (p, c) => p.words != c.words,
                  builder: (context, wordsState) {
                    return ElevatedButton.icon(
                      onPressed: () async {
                        final service = sl<NotificationsService>();
                        await service.requestPermissions();
                        await launchWorker(service, true);
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              l10n.notificationScheduleApplied(
                                state.wordsPerDay,
                              ),
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.notifications_active_outlined),
                      label: Text(l10n.applyNotificationSchedule),
                    );
                  },
                ),
                const SizedBox(height: 24),
                Text(
                  l10n.appLanguage,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                SegmentedButton<AppLanguage>(
                  segments: [
                    ButtonSegment(
                      value: AppLanguage.system,
                      label: Text(l10n.system),
                    ),
                    ButtonSegment(
                      value: AppLanguage.en,
                      label: Text(l10n.english),
                    ),
                    ButtonSegment(
                      value: AppLanguage.ar,
                      label: Text(l10n.arabic),
                    ),
                  ],
                  selected: {state.language},
                  onSelectionChanged: (s) =>
                      context.read<SettingsCubit>().setLanguage(s.first),
                ),
                const SizedBox(height: 24),
                Text(
                  l10n.ttsIterations,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Slider(
                        min: 1,
                        max: 5,
                        divisions: 4,
                        label: '${state.ttsIterations}',
                        value: state.ttsIterations.toDouble(),
                        onChanged: (v) => context
                            .read<SettingsCubit>()
                            .setTtsIterations(v.round()),
                      ),
                    ),
                    SizedBox(
                      width: 56,
                      child: Text(
                        '${state.ttsIterations}x',
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: Text(l10n.aboutTitle),
                  onTap: () => Navigator.of(context).pushNamed(AppRoutes.about),
                ),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: Text(l10n.drawerLogout),
                  onTap: () {
                    Navigator.of(context).pop();
                    context.read<AuthBloc>().add(const AuthLogoutRequested());
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

TimeOfDay _minutesToTimeOfDay(int minutes) {
  final m = minutes.clamp(0, 1439);
  return TimeOfDay(hour: m ~/ 60, minute: m % 60);
}

String _formatMinutes(BuildContext context, int minutes) {
  final tod = _minutesToTimeOfDay(minutes);
  return MaterialLocalizations.of(context).formatTimeOfDay(tod);
}
