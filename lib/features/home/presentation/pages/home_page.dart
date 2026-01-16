import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/router/app_router.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../words/domain/entities/word.dart';
import '../../../words/presentation/bloc/words_bloc.dart';

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

  void _toggleSave(Word word, bool saved) {
    context.read<WordsBloc>().add(
      WordSavedToggled(wordId: word.id, saved: saved),
    );
  }

  Future<void> _openAddWordSheet({required bool addToSaved}) async {
    final bloc = context.read<WordsBloc>();
    final formKey = GlobalKey<FormState>();
    final enController = TextEditingController();
    final arController = TextEditingController();

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 12,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
          ),
          child: StatefulBuilder(
            builder: (ctx, setState) {
              final hasEnglish = enController.text.trim().isNotEmpty;
              return Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Add a word',
                      style: Theme.of(ctx).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: enController,
                      decoration: const InputDecoration(
                        labelText: 'English',
                        prefixIcon: Icon(Icons.abc),
                      ),
                      textInputAction: TextInputAction.next,
                      onChanged: (_) => setState(() {}),
                      validator: (v) {
                        final value = (v ?? '').trim();
                        if (value.isEmpty) return 'English word is required';
                        if (value.length < 2) return 'Too short';
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: arController,
                      decoration: const InputDecoration(
                        labelText: 'Arabic',
                        prefixIcon: Icon(Icons.translate),
                      ),
                      textInputAction: TextInputAction.done,
                      validator: (v) {
                        final value = (v ?? '').trim();
                        if (value.isEmpty) {
                          return 'Arabic translation is required';
                        }
                        if (value.length < 2) return 'Too short';
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                    if (hasEnglish)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(
                              context,
                            ).pushNamed(AppRoutes.autoTranslate);
                          },
                          child: const Text('Auto translate'),
                        ),
                      ),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: () {
                        if (!formKey.currentState!.validate()) return;
                        bloc.add(
                          WordAdded(
                            en: enController.text,
                            ar: arController.text,
                            addToSaved: addToSaved,
                          ),
                        );
                        Navigator.of(ctx).pop();
                      },
                      icon: const Icon(Icons.add),
                      label: Text(
                        addToSaved ? 'Add to Saved' : 'Add to Unsaved',
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );

    enController.dispose();
    arController.dispose();
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
              BlocBuilder<WordsBloc, WordsState>(
                buildWhen: (p, c) =>
                    p.showEn != c.showEn ||
                    p.showAr != c.showAr ||
                    p.isShuffled != c.isShuffled,
                builder: (context, state) {
                  return PopupMenuButton<String>(
                    tooltip: 'Options',
                    itemBuilder: (context) => [
                      CheckedPopupMenuItem<String>(
                        value: 'toggle_en',
                        checked: state.showEn,
                        child: const Text('Show English'),
                      ),
                      CheckedPopupMenuItem<String>(
                        value: 'toggle_ar',
                        checked: state.showAr,
                        child: const Text('Show Arabic'),
                      ),
                      const PopupMenuDivider(),
                      PopupMenuItem<String>(
                        value: 'shuffle',
                        child: Text(state.isShuffled ? 'Reshuffle' : 'Shuffle'),
                      ),
                      PopupMenuItem<String>(
                        value: 'reset_order',
                        enabled: state.isShuffled,
                        child: const Text('Reset order'),
                      ),
                      const PopupMenuDivider(),
                      const PopupMenuItem<String>(
                        value: 'speak_unsaved',
                        child: Text('Speak Unsaved'),
                      ),
                      const PopupMenuItem<String>(
                        value: 'speak_saved',
                        child: Text('Speak Saved'),
                      ),
                    ],
                    onSelected: (value) {
                      final bloc = context.read<WordsBloc>();
                      switch (value) {
                        case 'toggle_en':
                          bloc.add(WordsShowEnToggled(!state.showEn));
                          break;
                        case 'toggle_ar':
                          bloc.add(WordsShowArToggled(!state.showAr));
                          break;
                        case 'shuffle':
                          bloc.add(const WordsShuffleRequested());
                          break;
                        case 'reset_order':
                          bloc.add(const WordsResetOrderRequested());
                          break;
                        case 'speak_unsaved':
                          bloc.add(const SpeakListRequested(savedOnly: false));
                          break;
                        case 'speak_saved':
                          bloc.add(const SpeakListRequested(savedOnly: true));
                          break;
                      }
                    },
                  );
                },
              ),
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
          body: BlocBuilder<WordsBloc, WordsState>(
            builder: (context, state) {
              if (state.status == WordsStatus.loading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state.status == WordsStatus.failure) {
                return Center(child: Text(state.message ?? 'Failed to load'));
              }
              final all = state.words;
              final savedIds = state.savedIds;
              final unsaved = all
                  .where((w) => !savedIds.contains(w.id))
                  .toList();
              final saved = all.where((w) => savedIds.contains(w.id)).toList();

              Widget buildList(List<Word> words, bool isSavedTab) {
                if (words.isEmpty) {
                  return Center(
                    child: Text(
                      isSavedTab ? 'No saved words' : 'No unsaved words',
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: words.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final word = words[index];
                    final isSaved = savedIds.contains(word.id);

                    final showEn = state.showEnById[word.id] ?? state.showEn;
                    final showAr = state.showArById[word.id] ?? state.showAr;
                    final isSpeaking = state.speakingWordId == word.id;

                    final speakingColor = Theme.of(
                      context,
                    ).colorScheme.primary.withAlpha(25);

                    return Card(
                      color: isSpeaking ? speakingColor : null,
                      child: ListTile(
                        title: Text(
                          showEn ? word.en : '\u2022\u2022\u2022',
                          style: isSpeaking
                              ? TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Theme.of(context).colorScheme.primary,
                                )
                              : null,
                        ),
                        subtitle: Text(showAr ? word.ar : '\u2022\u2022\u2022'),
                        leading: IconButton(
                          tooltip: 'Speak',
                          icon: Icon(
                            Icons.volume_up_outlined,
                            color: isSpeaking
                                ? Theme.of(context).colorScheme.primary
                                : null,
                          ),
                          onPressed: () => context.read<WordsBloc>().add(
                            SpeakWordRequested(word.id),
                          ),
                        ),
                        trailing: Wrap(
                          spacing: 4,
                          children: [
                            IconButton(
                              tooltip: showEn ? 'Hide English' : 'Show English',
                              icon: Icon(
                                showEn
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                              ),
                              onPressed: () => context.read<WordsBloc>().add(
                                WordShowEnToggled(
                                  wordId: word.id,
                                  show: !showEn,
                                ),
                              ),
                            ),
                            IconButton(
                              tooltip: showAr ? 'Hide Arabic' : 'Show Arabic',
                              icon: Icon(
                                showAr
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                              ),
                              onPressed: () => context.read<WordsBloc>().add(
                                WordShowArToggled(
                                  wordId: word.id,
                                  show: !showAr,
                                ),
                              ),
                            ),
                            IconButton(
                              tooltip: isSaved ? 'Unsave' : 'Save',
                              icon: Icon(
                                isSaved
                                    ? Icons.bookmark
                                    : Icons.bookmark_add_outlined,
                              ),
                              onPressed: () => _toggleSave(word, !isSaved),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }

              return TabBarView(
                children: [buildList(unsaved, false), buildList(saved, true)],
              );
            },
          ),
          floatingActionButton: Builder(
            builder: (context) {
              final controller = DefaultTabController.of(context);
              return FloatingActionButton.extended(
                onPressed: () {
                  final addToSaved = controller.index == 1;
                  _openAddWordSheet(addToSaved: addToSaved);
                },
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
