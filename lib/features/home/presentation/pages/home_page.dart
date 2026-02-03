import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_save/l10n/app_localizations.dart';

import '../../../../app/router/app_router.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
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
          listener: (context, state) {
            if (state.status == AuthStatus.unauthenticated) {
              Navigator.of(context).pushNamedAndRemoveUntil(
                AppRoutes.login,
                (route) => route.isFirst,
              );
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
      ],
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: DefaultTextStyle(
              style: Theme.of(context).textTheme.titleSmall!,
              child: BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  final username = state.user?.name ?? '';
                  final now = DateTime.now();
                  if (now.weekday == DateTime.friday) {
                    return Text(l10n.greetingFriday(username));
                  } else if (now.hour < 12) {
                    return Text(l10n.greetingMorning(username));
                  } else {
                    return Text(l10n.greetingAfternoon(username));
                  }
                },
              ),
            ),
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
                icon: const Icon(Icons.settings),
                onPressed: () {
                  Navigator.of(context).pushNamed(AppRoutes.settings);
                },
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
                    final unsaved = all.where((w) => !w.isSaved).toList();
                    final saved = all.where((w) => w.isSaved).toList();

                    return TabBarView(
                      children: [
                        WordsListView(words: unsaved, isSavedTab: false),
                        WordsListView(words: saved, isSavedTab: true),
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
