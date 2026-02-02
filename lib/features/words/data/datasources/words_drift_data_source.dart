import '../../../../core/db/app_database.dart';
import '../../domain/entities/word.dart';
import '../models/word_dto.dart';
import 'words_drift_dao.dart';

class WordsPageResult {
  final List<Word> words;
  final int totalCount;

  const WordsPageResult({required this.words, required this.totalCount});
}

abstract class WordsDriftDataSource {
  Future<void> seedIfEmpty(List<Word> seed);

  Future<WordsPageResult> fetchPage({required int limit, required int offset});

  Future<Set<String>> getSavedWordIds();

  Future<void> setWordSaved({required String wordId, required bool saved});

  Future<void> addWord(Word word);

  Future<void> updateWord(Word word);

  Future<void> deleteWord(String id);
}

class WordsDriftDataSourceImpl implements WordsDriftDataSource {
  final AppDatabase db;
  final WordsDriftDao dao;

  WordsDriftDataSourceImpl(this.db) : dao = WordsDriftDao(db);

  @override
  Future<void> seedIfEmpty(List<Word> seed) async {
    final count = await dao.count();
    if (count > 0) return;

    for (final w in seed) {
      await dao.upsert(WordDto(id: w.id, en: w.en, ar: w.ar));
    }
  }

  @override
  Future<WordsPageResult> fetchPage({
    required int limit,
    required int offset,
  }) async {
    final page = await dao.fetchPage(limit: limit, offset: offset);

    return WordsPageResult(
      words: page.items.map((d) => d.toDomain()).toList(),
      totalCount: page.totalCount,
    );
  }

  @override
  Future<Set<String>> getSavedWordIds() {
    return dao.getSavedIds();
  }

  @override
  Future<void> setWordSaved({required String wordId, required bool saved}) {
    return dao.setSaved(wordId: wordId, saved: saved);
  }

  @override
  Future<void> addWord(Word word) {
    return dao.upsert(
      WordDto(id: word.id, en: word.en, ar: word.ar, isSaved: word.isSaved),
    );
  }

  @override
  Future<void> updateWord(Word word) {
    return dao.updateById(
      WordDto(id: word.id, en: word.en, ar: word.ar, isSaved: word.isSaved),
    );
  }

  @override
  Future<void> deleteWord(String id) {
    return dao.deleteById(id);
  }
}
