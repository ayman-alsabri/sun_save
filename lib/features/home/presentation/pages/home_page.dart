import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/router/app_router.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../words/presentation/bloc/words_bloc.dart';
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
            if (msg != null && msg.isNotEmpty) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(msg)));
            }
          },
        ),
      ],
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Words'),
            bottom: const TabBar(
              tabs: [
                Tab(text: 'Unsaved'),
                Tab(text: 'Saved'),
              ],
            ),
            actions: [
              const WordsAppBarMenu(),
              IconButton(
                tooltip: 'Settings',
                icon: const Icon(Icons.settings_outlined),
                onPressed: () =>
                    Navigator.of(context).pushNamed(AppRoutes.settings),
              ),
              IconButton(
                tooltip: 'Logout',
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
                      return Center(
                        child: Text(state.message ?? 'Failed to load'),
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
          floatingActionButton: Builder(
            builder: (context) {
              final controller = DefaultTabController.of(context);
              return FloatingActionButton.extended(
                onPressed: () =>
                    _addWordFlow(addToSaved: controller.index == 1),
                label: const Text('Add a word'),
                icon: const Icon(Icons.add),
              );
            },
          ),
        ),
      ),
    );
  }
}
