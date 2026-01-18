import '../entities/word.dart';

class WordsPage {
  final List<Word> items;
  final int totalCount;

  const WordsPage({required this.items, required this.totalCount});

  bool get hasMore => items.length < totalCount;
}

abstract class WordsRepository {
  /// Page-based fetch. Use this to avoid loading the full DB.
  Future<WordsPage> getWordsPage({required int limit, required int offset});

  /// Set of saved word ids.
  Future<Set<String>> getSavedWordIds();

  Future<void> setWordSaved({required String wordId, required bool saved});

  Future<void> addWord(Word word);

  Future<void> updateWord(Word word);

  Future<void> deleteWord(String id);
}
