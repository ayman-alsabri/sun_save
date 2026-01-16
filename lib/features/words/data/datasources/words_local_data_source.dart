import 'package:shared_preferences/shared_preferences.dart';

abstract class WordsLocalDataSource {
  List<String> getSavedWords();
  Future<void> saveSavedWords(List<String> words);
}

class WordsLocalDataSourceImpl implements WordsLocalDataSource {
  static const _savedWordsKey = 'saved_words';

  final SharedPreferences prefs;
  const WordsLocalDataSourceImpl(this.prefs);

  @override
  List<String> getSavedWords() {
    return prefs.getStringList(_savedWordsKey) ?? <String>[];
  }

  @override
  Future<void> saveSavedWords(List<String> words) async {
    await prefs.setStringList(_savedWordsKey, words);
  }
}
