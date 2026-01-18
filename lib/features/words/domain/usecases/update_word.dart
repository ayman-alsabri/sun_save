import '../entities/word.dart';
import '../repositories/words_repository.dart';

class UpdateWord {
  final WordsRepository repository;
  const UpdateWord(this.repository);

  Future<void> call(Word word) => repository.updateWord(word);
}
