import '../entities/word.dart';

abstract class WordsRepository {
  Future<List<Word>> getWords();

  /// Set of saved word ids.
  Future<Set<String>> getSavedWordIds();

  Future<void> setWordSaved({required String wordId, required bool saved});

  Future<void> addWord(Word word);
}
