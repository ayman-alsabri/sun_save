import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

class WordsTable extends Table {
  // Keep ids compatible with current app model.
  TextColumn get id => text()();

  TextColumn get en => text()();

  TextColumn get ar => text()();

  // Persist saved status in DB (replaces SharedPreferences saved_words list)
  BoolColumn get isSaved => boolean().withDefault(const Constant(false))();

  DateTimeColumn get createdAt => dateTime()();

  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [WordsTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.addColumn(
          wordsTable,
          wordsTable.isSaved as GeneratedColumn<Object>,
        );
      }
    },
  );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'sun_save.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
