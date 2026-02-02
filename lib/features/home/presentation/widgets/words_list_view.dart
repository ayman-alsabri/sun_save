import 'package:flutter/material.dart';
import 'package:sun_save/l10n/app_localizations.dart';

import '../../../words/domain/entities/word.dart';
import 'words_list_item.dart';

class WordsListView extends StatelessWidget {
  final List<Word> words;
  final bool isSavedTab;

  const WordsListView({
    super.key,
    required this.words,
    required this.isSavedTab,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (words.isEmpty) {
      return Center(
        child: Text(isSavedTab ? l10n.noSavedWords : l10n.noUnsavedWords),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: words.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final word = words[index];
        return WordsListItem(word: word, isSaved: word.isSaved);
      },
    );
  }
}
