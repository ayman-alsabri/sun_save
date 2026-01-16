import '../entities/word.dart';
import '../repositories/words_repository.dart';

class GetWords {
  final WordsRepository repository;
  const GetWords(this.repository);

  Future<List<Word>> call() => repository.getWords();
}
