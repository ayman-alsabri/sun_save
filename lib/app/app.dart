import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../core/services/app_settings.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';
import '../features/settings/presentation/bloc/settings_cubit.dart';
import '../features/words/presentation/bloc/words_bloc.dart';
import '../l10n/app_localizations.dart';
import 'di/injection_container.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';

class SunSaveApp extends StatelessWidget {
  const SunSaveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (_) => sl<AuthBloc>()),
        BlocProvider<WordsBloc>(create: (_) => sl<WordsBloc>()),
        BlocProvider<SettingsCubit>(create: (_) => sl<SettingsCubit>()..load()),
      ],
      child: BlocBuilder<SettingsCubit, AppSettings>(
        builder: (context, settings) {
          final ThemeMode mode = switch (settings.themeMode) {
            AppThemeMode.system => ThemeMode.system,
            AppThemeMode.light => ThemeMode.light,
            AppThemeMode.dark => ThemeMode.dark,
          };

          final Locale? locale = switch (settings.language) {
            AppLanguage.system => null,
            AppLanguage.en => const Locale('en'),
            AppLanguage.ar => const Locale('ar'),
          };

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Sun Save',
            theme: AppTheme.light(seedColor: settings.seedColor),
            darkTheme: AppTheme.dark(seedColor: settings.seedColor),
            themeMode: mode,
            locale: locale,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            initialRoute: AppRoutes.splash,
            onGenerateRoute: AppRouter.onGenerateRoute,
          );
        },
      ),
    );
  }
}
