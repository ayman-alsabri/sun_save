import '../repositories/words_repository.dart';

class GetWordsPage {
  final WordsRepository repository;
  const GetWordsPage(this.repository);

  Future<WordsPage> call({required int limit, required int offset}) {
    return repository.getWordsPage(limit: limit, offset: offset);
  }
}
