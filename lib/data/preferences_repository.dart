import 'package:drift/drift.dart';

import '../domain/models.dart';
import 'database.dart';

class PreferencesRepository {
  final AppDatabase db;
  PreferencesRepository(this.db);
  Future<UserPreferences> read() async {
    final row = await (db.select(
      db.preferenceRows,
    )..where((t) => t.id.equals(1))).getSingleOrNull();
    if (row == null) return const UserPreferences();
    return UserPreferences(
      dailyGoal: row.dailyGoal,
      onboarded: row.onboarded,
      reminders: row.reminders,
      reminderHour: row.reminderHour,
      reminderMinute: row.reminderMinute,
    );
  }

  Future<void> save(UserPreferences p) async {
    if (![1, 3, 5].contains(p.dailyGoal) ||
        p.reminderHour < 0 ||
        p.reminderHour > 23 ||
        p.reminderMinute < 0 ||
        p.reminderMinute > 59) {
      throw ArgumentError('Invalid preferences');
    }
    await db
        .into(db.preferenceRows)
        .insertOnConflictUpdate(
          PreferenceRowsCompanion.insert(
            id: const Value(1),
            dailyGoal: Value(p.dailyGoal),
            onboarded: Value(p.onboarded),
            reminders: Value(p.reminders),
            reminderHour: Value(p.reminderHour),
            reminderMinute: Value(p.reminderMinute),
          ),
        );
  }
}
