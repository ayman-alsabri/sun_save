import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_save/l10n/app_localizations.dart';

import '../../../../app/di/injection_container.dart';
import '../../../../app/router/app_router.dart';
import '../../../../core/services/app_settings.dart';
import '../../../../core/services/notifications_service.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../settings/presentation/bloc/settings_cubit.dart';
import '../../../words/presentation/bloc/words_bloc.dart';
import '../../../words/presentation/bloc/words_message_localization.dart';
import '../widgets/add_word_bottom_sheet.dart';
import '../widgets/tts_controls_bar.dart';
import '../widgets/words_app_bar_menu.dart';
import '../widgets/words_list_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _didInitialSchedule = false;
  int _scheduleToken = 0;

  Future<void> _scheduleNotificationsIfNeeded(
    AppLocalizations l10n,
    WordsState wordsState,
    AppSettings settings,
  ) async {
    if (settings.wordsPerDay <= 0) {
      await sl<NotificationsService>().cancelAllScheduled();
      return;
    }

    final unsavedWords = wordsState.words
        .where((w) => !wordsState.savedIds.contains(w.id))
        .toList(growable: false);

    if (unsavedWords.isEmpty) {
      await sl<NotificationsService>().cancelAllScheduled();
      return;
    }

    await sl<NotificationsService>().requestPermissions();
    await sl<NotificationsService>().scheduleDailyWords(
      count: settings.wordsPerDay,
      startMinutes: settings.notifyStartMinutes,
      endMinutes: settings.notifyEndMinutes,
      unsavedWords: unsavedWords,
      l10n: l10n,
    );
  }

  void _debouncedReschedule(
    AppLocalizations l10n,
    WordsState wordsState,
    AppSettings settings,
  ) {
    // Very small debounce so multiple rapid events (edit/delete/save) only
    // trigger one reschedule.
    final token = ++_scheduleToken;
    Future<void>.delayed(const Duration(milliseconds: 300)).then((_) {
      if (!mounted) return Future.value();
      if (token != _scheduleToken) return Future.value();
      return _scheduleNotificationsIfNeeded(l10n, wordsState, settings);
    });
  }

  @override
  void initState() {
    super.initState();
    context.read<WordsBloc>().add(const WordsRequested());
  }

  Future<void> _addWordFlow({required bool addToSaved}) async {
    final result = await AddWordBottomSheet.show(
      context,
      addToSaved: addToSaved,
    );
    if (!mounted || result == null) return;

    context.read<WordsBloc>().add(
      WordAdded(en: result.en, ar: result.ar, addToSaved: result.addToSaved),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return MultiBlocListener(
      listeners: [
        BlocListener<AuthBloc, AuthState>(
          listenWhen: (p, c) => p.status != c.status,
          listener: (context, state) {
            if (state.status == AuthStatus.unauthenticated) {
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil(AppRoutes.login, (_) => false);
            }
          },
        ),
        BlocListener<WordsBloc, WordsState>(
          listenWhen: (p, c) => p.message != c.message,
          listener: (context, state) {
            final msg = state.message;
            if (msg == null) return;

            final text = msg.localize(l10n);
            if (text.trim().isEmpty) return;

            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(text)));
          },
        ),
        // Auto-reschedule notifications when words or savedIds change.
        BlocListener<WordsBloc, WordsState>(
          listenWhen: (prev, cur) =>
              prev.words != cur.words || prev.savedIds != cur.savedIds,
          listener: (context, state) async {
            final settings = context.read<SettingsCubit>().state;

            // Schedule once after initial load, then debounce subsequent changes.
            if (!_didInitialSchedule) {
              _didInitialSchedule = true;
              await _scheduleNotificationsIfNeeded(l10n, state, settings);
              return;
            }

            _debouncedReschedule(l10n, state, settings);
          },
        ),
      ],
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text(l10n.wordsTitle),
            bottom: TabBar(
              tabs: [
                Tab(text: l10n.unsavedTab),
                Tab(text: l10n.savedTab),
              ],
            ),
            actions: [
              const WordsAppBarMenu(),
              IconButton(
                tooltip: l10n.settingsTitle,
                icon: const Icon(Icons.settings_outlined),
                onPressed: () =>
                    Navigator.of(context).pushNamed(AppRoutes.settings),
              ),
              IconButton(
                tooltip: l10n.logout,
                onPressed: () =>
                    context.read<AuthBloc>().add(const AuthLogoutRequested()),
                icon: const Icon(Icons.logout),
              ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: BlocBuilder<WordsBloc, WordsState>(
                  builder: (context, state) {
                    if (state.status == WordsStatus.loading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state.status == WordsStatus.failure) {
                      final msg = state.message;
                      return Center(
                        child: Text(msg == null ? '' : msg.localize(l10n)),
                      );
                    }

                    final all = state.words;
                    final savedIds = state.savedIds;
                    final unsaved = all
                        .where((w) => !savedIds.contains(w.id))
                        .toList();
                    final saved = all
                        .where((w) => savedIds.contains(w.id))
                        .toList();

                    return TabBarView(
                      children: [
                        WordsListView(
                          words: unsaved,
                          savedIds: savedIds,
                          isSavedTab: false,
                        ),
                        WordsListView(
                          words: saved,
                          savedIds: savedIds,
                          isSavedTab: true,
                        ),
                      ],
                    );
                  },
                ),
              ),
              const TtsControlsBar(),
            ],
          ),
          floatingActionButton: BlocBuilder<WordsBloc, WordsState>(
            builder: (context, state) {
              final controller = DefaultTabController.of(context);
              return state.speakingStatus != SpeakingStatus.idle
                  ? const SizedBox()
                  : FloatingActionButton.extended(
                      onPressed: () =>
                          _addWordFlow(addToSaved: controller.index == 1),
                      label: Text(l10n.addWordFab),
                      icon: const Icon(Icons.add),
                    );
            },
          ),
        ),
      ),
    );
  }
}
