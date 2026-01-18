import '../repositories/words_repository.dart';

class DeleteWord {
  final WordsRepository repository;
  const DeleteWord(this.repository);

  Future<void> call(String id) => repository.deleteWord(id);
}
