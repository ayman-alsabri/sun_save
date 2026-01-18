import 'package:drift/drift.dart';

import '../../../../core/db/app_database.dart';
import '../../domain/entities/word.dart';

class WordDto {
  final String id;
  final String en;
  final String ar;

  const WordDto({required this.id, required this.en, required this.ar});

  factory WordDto.fromRow(WordsTableData row) {
    return WordDto(id: row.id, en: row.en, ar: row.ar);
  }

  Word toDomain() => Word(id: id, en: en, ar: ar);

  WordsTableCompanion toInsertCompanion() {
    final now = DateTime.now();
    return WordsTableCompanion.insert(
      id: id,
      en: en,
      ar: ar,
      createdAt: now,
      updatedAt: now,
    );
  }

  WordsTableCompanion toUpdateCompanion() {
    final now = DateTime.now();
    return WordsTableCompanion(
      en: Value(en),
      ar: Value(ar),
      updatedAt: Value(now),
    );
  }
}
