import 'package:drift/drift.dart';

import '../../../../core/db/app_database.dart';
import '../models/word_dto.dart';

class WordsPageDto {
  final List<WordDto> items;
  final int totalCount;

  const WordsPageDto({required this.items, required this.totalCount});
}

/// Feature DAO responsible for words queries (clean architecture).
class WordsDriftDao {
  final AppDatabase db;

  WordsDriftDao(this.db);

  Future<int> count() async {
    final res = await db
        .customSelect(
          'SELECT COUNT(*) AS c FROM words_table',
          readsFrom: {db.wordsTable},
        )
        .getSingle();
    return (res.data['c'] as int?) ?? 0;
  }

  Future<List<WordsTableData>> fetchPageRows({
    required int limit,
    required int offset,
  }) {
    return (db.select(db.wordsTable)
          ..orderBy([
            (t) =>
                OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc),
          ])
          ..limit(limit, offset: offset))
        .get();
  }

  Future<WordsPageDto> fetchPage({
    required int limit,
    required int offset,
  }) async {
    final rows = await fetchPageRows(limit: limit, offset: offset);
    final total = await count();
    return WordsPageDto(
      items: rows.map(WordDto.fromRow).toList(),
      totalCount: total,
    );
  }

  Future<void> upsert(WordDto dto) async {
    await db
        .into(db.wordsTable)
        .insert(dto.toInsertCompanion(), mode: InsertMode.insertOrReplace);
  }

  Future<void> updateById(WordDto dto) async {
    await (db.update(
      db.wordsTable,
    )..where((t) => t.id.equals(dto.id))).write(dto.toUpdateCompanion());
  }

  Future<void> deleteById(String id) async {
    await (db.delete(db.wordsTable)..where((t) => t.id.equals(id))).go();
  }
}
