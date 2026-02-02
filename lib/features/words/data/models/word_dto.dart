import 'package:drift/drift.dart';

import '../../../../core/db/app_database.dart';
import '../../domain/entities/word.dart';

class WordDto {
  final String id;
  final String en;
  final String ar;
  final bool isSaved;

  const WordDto({
    required this.id,
    required this.en,
    required this.ar,
    this.isSaved = false,
  });

  factory WordDto.fromRow(WordsTableData row) {
    return WordDto(id: row.id, en: row.en, ar: row.ar, isSaved: row.isSaved);
  }

  Word toDomain() => Word(id: id, en: en, ar: ar, isSaved: isSaved);

  WordsTableCompanion toInsertCompanion() {
    final now = DateTime.now();
    return WordsTableCompanion.insert(
      id: id,
      en: en,
      ar: ar,
      isSaved: Value(isSaved),
      createdAt: now,
      updatedAt: now,
    );
  }

  WordsTableCompanion toUpdateCompanion() {
    final now = DateTime.now();
    return WordsTableCompanion(
      en: Value(en),
      ar: Value(ar),
      isSaved: Value(isSaved),
      updatedAt: Value(now),
    );
  }
}
