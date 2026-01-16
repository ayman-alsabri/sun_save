import '../repositories/words_repository.dart';

@Deprecated('Use SetWordSaved instead.')
class AddSavedWord {
  final WordsRepository repository;
  const AddSavedWord(this.repository);

  Future<void> call(String wordId) =>
      repository.setWordSaved(wordId: wordId, saved: true);
}
