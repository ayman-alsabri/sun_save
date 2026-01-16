import '../repositories/words_repository.dart';

class SetWordSaved {
  final WordsRepository repository;
  const SetWordSaved(this.repository);

  Future<void> call({required String wordId, required bool saved}) {
    return repository.setWordSaved(wordId: wordId, saved: saved);
  }
}
