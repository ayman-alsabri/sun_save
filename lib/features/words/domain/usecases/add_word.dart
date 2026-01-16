import '../entities/word.dart';
import '../repositories/words_repository.dart';

class AddWord {
  final WordsRepository repository;
  const AddWord(this.repository);

  Future<void> call(Word word) => repository.addWord(word);
}
