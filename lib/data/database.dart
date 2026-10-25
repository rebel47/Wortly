import 'package:drift/drift.dart';
part 'database.g.dart';

class PreferenceRows extends Table {
  IntColumn get id => integer().withDefault(const Constant(1))();
  IntColumn get dailyGoal => integer().withDefault(const Constant(3))();
  BoolColumn get onboarded => boolean().withDefault(const Constant(false))();
  BoolColumn get reminders => boolean().withDefault(const Constant(false))();
  IntColumn get reminderHour => integer().withDefault(const Constant(9))();
  IntColumn get reminderMinute => integer().withDefault(const Constant(0))();
  @override
  Set<Column> get primaryKey => {id};
}

class AssignmentRows extends Table {
  TextColumn get day => text()();
  IntColumn get goal => integer()();
  TextColumn get wordIds => text()();
  @override
  Set<Column> get primaryKey => {day};
}

class LearnedRows extends Table {
  TextColumn get wordId => text()();
  TextColumn get day => text()();
  @override
  Set<Column> get primaryKey => {wordId};
}

class ActivityRows extends Table {
  TextColumn get day => text()();
  @override
  Set<Column> get primaryKey => {day};
}

class QuizRows extends Table {
  TextColumn get week => text()();
  TextColumn get questions => text()();
  TextColumn get answers => text().withDefault(const Constant('{}'))();
  IntColumn get cursor => integer().withDefault(const Constant(0))();
  BoolColumn get expired => boolean().withDefault(const Constant(false))();
  IntColumn get score => integer().nullable()();
  @override
  Set<Column> get primaryKey => {week};
}

/// Added in v2; importing content never replaces any user-history tables.
class ContentRows extends Table {
  TextColumn get version => text()();
  IntColumn get recordCount => integer()();
  @override
  Set<Column> get primaryKey => {version};
}

@DriftDatabase(
  tables: [
    PreferenceRows,
    AssignmentRows,
    LearnedRows,
    ActivityRows,
    QuizRows,
    ContentRows,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);
  @override
  int get schemaVersion => 2;
  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      if (from < 2) await m.createTable(contentRows);
    },
    beforeOpen: (_) async {
      await customStatement('PRAGMA foreign_keys = ON');
      await customStatement('PRAGMA busy_timeout = 5000');
    },
  );
}
