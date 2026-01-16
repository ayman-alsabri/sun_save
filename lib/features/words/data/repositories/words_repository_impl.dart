import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/word.dart';
import '../../domain/repositories/words_repository.dart';
import '../datasources/words_local_data_source.dart';

class WordsRepositoryImpl implements WordsRepository {
  final WordsLocalDataSource local;
  const WordsRepositoryImpl(this.local);

  static const _customWordsKey = 'custom_words_v1';

  static const _words = <Word>[
    Word(id: 'sun', en: 'Sun', ar: 'الشمس'),
    Word(id: 'water', en: 'Water', ar: 'ماء'),
    Word(id: 'book', en: 'Book', ar: 'كتاب'),
    Word(id: 'house', en: 'House', ar: 'بيت'),
    Word(id: 'school', en: 'School', ar: 'مدرسة'),
    Word(id: 'car', en: 'Car', ar: 'سيارة'),
    Word(id: 'food', en: 'Food', ar: 'طعام'),
    Word(id: 'friend', en: 'Friend', ar: 'صديق'),
    Word(id: 'family', en: 'Family', ar: 'عائلة'),
    Word(id: 'work', en: 'Work', ar: 'عمل'),
    Word(id: 'time', en: 'Time', ar: 'وقت'),
    Word(id: 'love', en: 'Love', ar: 'حب'),
    Word(id: 'happy', en: 'Happy', ar: 'سعيد'),
    Word(id: 'hello', en: 'Hello', ar: 'مرحبا'),
    Word(id: 'good_morning', en: 'Good morning', ar: 'صباح الخير'),
  ];

  SharedPreferences _prefs() {
    final l = local;
    if (l is WordsLocalDataSourceImpl) return l.prefs;
    throw StateError('WordsLocalDataSourceImpl is required');
  }

  List<Word> _readCustomWords() {
    final raw = _prefs().getString(_customWordsKey);
    if (raw == null || raw.isEmpty) return const [];

    final decoded = jsonDecode(raw);
    if (decoded is! List) return const [];

    final out = <Word>[];
    for (final item in decoded) {
      if (item is Map) {
        final id = item['id'];
        final en = item['en'];
        final ar = item['ar'];
        if (id is String && en is String && ar is String) {
          out.add(Word(id: id, en: en, ar: ar));
        }
      }
    }
    return out;
  }

  Future<void> _writeCustomWords(List<Word> words) async {
    final encoded = words
        .map((w) => <String, dynamic>{'id': w.id, 'en': w.en, 'ar': w.ar})
        .toList();
    await _prefs().setString(_customWordsKey, jsonEncode(encoded));
  }

  @override
  Future<List<Word>> getWords() async {
    await Future<void>.delayed(const Duration(milliseconds: 120));
    final custom = _readCustomWords();

    final map = <String, Word>{
      for (final w in _words) w.id: w,
      for (final w in custom) w.id: w,
    };
    return map.values.toList();
  }

  @override
  Future<Set<String>> getSavedWordIds() async {
    return local.getSavedWords().toSet();
  }

  @override
  Future<void> setWordSaved({required String wordId, required bool saved}) async {
    final current = local.getSavedWords().toSet();
    if (saved) {
      current.add(wordId);
    } else {
      current.remove(wordId);
    }
    await local.saveSavedWords(current.toList());
  }

  @override
  Future<void> addWord(Word word) async {
    final current = _readCustomWords();
    final next = [...current];

    next.removeWhere((w) => w.id == word.id);
    next.add(word);
    await _writeCustomWords(next);
  }
}
