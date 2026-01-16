import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../words/presentation/bloc/words_bloc.dart';

class WordsAppBarMenu extends StatelessWidget {
  const WordsAppBarMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WordsBloc, WordsState>(
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
    );
  }
}
