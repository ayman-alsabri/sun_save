import '../repositories/words_repository.dart';

class GetSavedWordIds {
  final WordsRepository repository;
  const GetSavedWordIds(this.repository);

  Future<Set<String>> call() => repository.getSavedWordIds();
}
