import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/router/app_router.dart';
import '../../../../core/services/app_settings.dart';
import '../bloc/settings_cubit.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: BlocBuilder<SettingsCubit, AppSettings>(
        builder: (context, state) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text('Theme', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              SegmentedButton<AppThemeMode>(
                segments: const [
                  ButtonSegment(
                    value: AppThemeMode.system,
                    label: Text('System'),
                  ),
                  ButtonSegment(
                    value: AppThemeMode.light,
                    label: Text('Light'),
                  ),
                  ButtonSegment(value: AppThemeMode.dark, label: Text('Dark')),
                ],
                selected: {state.themeMode},
                onSelectionChanged: (s) =>
                    context.read<SettingsCubit>().setThemeMode(s.first),
              ),
              const SizedBox(height: 24),
              Text(
                'App language',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              SegmentedButton<AppLanguage>(
                segments: const [
                  ButtonSegment(
                    value: AppLanguage.system,
                    label: Text('System'),
                  ),
                  ButtonSegment(value: AppLanguage.en, label: Text('English')),
                  ButtonSegment(value: AppLanguage.ar, label: Text('Arabic')),
                ],
                selected: {state.language},
                onSelectionChanged: (s) =>
                    context.read<SettingsCubit>().setLanguage(s.first),
              ),
              const SizedBox(height: 24),
              Text(
                'TTS iterations',
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
                title: const Text('About'),
                onTap: () => Navigator.of(context).pushNamed(AppRoutes.about),
              ),
            ],
          );
        },
      ),
    );
  }
}
