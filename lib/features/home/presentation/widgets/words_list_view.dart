import 'package:flutter/material.dart';

import '../../../words/domain/entities/word.dart';
import 'words_list_item.dart';

class WordsListView extends StatelessWidget {
  final List<Word> words;
  final Set<String> savedIds;
  final bool isSavedTab;

  const WordsListView({
    super.key,
    required this.words,
    required this.savedIds,
    required this.isSavedTab,
  });

  @override
  Widget build(BuildContext context) {
    if (words.isEmpty) {
      return Center(
        child: Text(isSavedTab ? 'No saved words' : 'No unsaved words'),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: words.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final word = words[index];
        final isSaved = savedIds.contains(word.id);
        return WordsListItem(word: word, isSaved: isSaved);
      },
    );
  }
}
