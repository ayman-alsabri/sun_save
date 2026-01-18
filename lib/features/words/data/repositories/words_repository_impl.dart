import '../../domain/entities/word.dart';
import '../../domain/repositories/words_repository.dart';
import '../datasources/words_drift_data_source.dart';
import '../datasources/words_local_data_source.dart';

class WordsRepositoryImpl implements WordsRepository {
  final WordsLocalDataSource local;
  final WordsDriftDataSource drift;

  WordsRepositoryImpl(this.local, this.drift);

  @override
  Future<WordsPage> getWordsPage({
    required int limit,
    required int offset,
  }) async {
    final page = await drift.fetchPage(limit: limit, offset: offset);
    return WordsPage(items: page.words, totalCount: page.totalCount);
  }

  @override
  Future<Set<String>> getSavedWordIds() async {
    return local.getSavedWords().toSet();
  }

  @override
  Future<void> setWordSaved({
    required String wordId,
    required bool saved,
  }) async {
    final current = local.getSavedWords().toSet();
    if (saved) {
      current.add(wordId);
    } else {
      current.remove(wordId);
    }
    await local.saveSavedWords(current.toList());
  }

  @override
  Future<void> addWord(Word word) async {
    await drift.addWord(word);
  }

  @override
  Future<void> updateWord(Word word) async {
    await drift.updateWord(word);
  }

  @override
  Future<void> deleteWord(String id) async {
    await drift.deleteWord(id);
  }
}
