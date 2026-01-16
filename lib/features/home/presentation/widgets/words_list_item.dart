import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../words/domain/entities/word.dart';
import '../../../words/presentation/bloc/words_bloc.dart';

class WordsListItem extends StatelessWidget {
  final Word word;
  final bool isSaved;

  const WordsListItem({super.key, required this.word, required this.isSaved});

  @override
  Widget build(BuildContext context) {
    final state = context.select((WordsBloc b) => b.state);

    final showEn = state.showEnById[word.id] ?? state.showEn;
    final showAr = state.showArById[word.id] ?? state.showAr;
    final isSpeaking = state.speakingWordId == word.id;

    final speakingColor = Theme.of(context).colorScheme.primary.withAlpha(25);

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
            color: isSpeaking ? Theme.of(context).colorScheme.primary : null,
          ),
          onPressed: () =>
              context.read<WordsBloc>().add(SpeakWordRequested(word.id)),
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
                WordShowEnToggled(wordId: word.id, show: !showEn),
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
                WordShowArToggled(wordId: word.id, show: !showAr),
              ),
            ),
            IconButton(
              tooltip: isSaved ? 'Unsave' : 'Save',
              icon: Icon(
                isSaved ? Icons.bookmark : Icons.bookmark_add_outlined,
              ),
              onPressed: () => context.read<WordsBloc>().add(
                WordSavedToggled(wordId: word.id, saved: !isSaved),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
