import '../entities/word.dart';
import '../repositories/words_repository.dart';

class GetWords {
  final WordsRepository repository;
  const GetWords(this.repository);

  Future<List<Word>> call(GetWordsParams params) async {
    final page = await repository.getWordsPage(
      limit: params.limit,
      offset: params.offset,
    );
    return page.items;
  }
}

class GetWordsParams {
  final int limit;
  final int offset;

  const GetWordsParams({required this.limit, required this.offset});
}
