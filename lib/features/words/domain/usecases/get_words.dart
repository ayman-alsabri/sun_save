import '../entities/word.dart';
import '../repositories/words_repository.dart';

class GetWords {
  final WordsRepository repository;
  const GetWords(this.repository);

  Future<List<Word>> call() async {
    // Compatibility: fetch first page.
    final page = await repository.getWordsPage(limit: 50, offset: 0);
    return page.items;
  }
}
