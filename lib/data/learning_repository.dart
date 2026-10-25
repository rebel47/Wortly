import 'dart:convert';

import 'package:drift/drift.dart';

import '../domain/models.dart';
import 'database.dart';
import 'preferences_repository.dart';
import 'vocabulary_repository.dart';

class LearningRepository {
  final AppDatabase db;
  final VocabularyRepository vocabulary;
  final PreferencesRepository preferences;
  final AppClock clock;
  LearningRepository(this.db, this.vocabulary, this.preferences, this.clock);
  LocalDate get today => LocalDate.from(clock.now());
  Future<Set<String>> learnedIds() async =>
      (await db.select(db.learnedRows).get()).map((r) => r.wordId).toSet();

  Future<DayAssignment> ensureToday() => db.transaction(() async {
    final date = today;
    var row = await (db.select(
      db.assignmentRows,
    )..where((t) => t.day.equals(date.key))).getSingleOrNull();
    final learned = await learnedIds();
    if (row == null) {
      final goal = (await preferences.read()).dailyGoal;
      final previous = await (db.select(
        db.assignmentRows,
      )..orderBy([(t) => OrderingTerm.asc(t.day)])).get();
      final pending = <String>{};
      for (final old in previous) {
        for (final id in List<String>.from(jsonDecode(old.wordIds) as List)) {
          if (!learned.contains(id) && vocabulary.byId.containsKey(id)) {
            pending.add(id);
          }
        }
      }
      final ids = <String>[...pending];
      ids.addAll(
        vocabulary.words
            .where((w) => !learned.contains(w.id) && !pending.contains(w.id))
            .map((w) => w.id),
      );
      await db
          .into(db.assignmentRows)
          .insert(
            AssignmentRowsCompanion.insert(
              day: date.key,
              goal: goal,
              wordIds: jsonEncode(ids.take(goal).toList()),
            ),
            mode: InsertMode.insertOrIgnore,
          );
      row = await (db.select(
        db.assignmentRows,
      )..where((t) => t.day.equals(date.key))).getSingle();
    }
    return DayAssignment(
      date: date,
      goal: row.goal,
      wordIds: List<String>.from(jsonDecode(row.wordIds) as List),
      completedIds: learned,
    );
  });

  /// Reject stale cards after midnight. The caller then refreshes the lesson.
  Future<bool> complete(String id, LocalDate displayedDate) =>
      db.transaction(() async {
        if (today != displayedDate) return false;
        final assignment = await ensureToday();
        if (assignment.date != displayedDate || today != displayedDate) {
          return false;
        }
        if (!assignment.wordIds.contains(id)) return false;
        // A carried word completed on a later date must not backfill a missed
        // streak day when the clock/timezone revisits an old assignment.
        if (assignment.completedIds.contains(id)) return true;
        await db
            .into(db.learnedRows)
            .insert(
              LearnedRowsCompanion.insert(wordId: id, day: displayedDate.key),
              mode: InsertMode.insertOrIgnore,
            );
        final learned = await learnedIds();
        if (assignment.wordIds.every(learned.contains)) {
          await db
              .into(db.activityRows)
              .insert(
                ActivityRowsCompanion.insert(day: displayedDate.key),
                mode: InsertMode.insertOrIgnore,
              );
        }
        return true;
      });

  Future<List<LocalDate>> activity() async =>
      (await (db.select(
            db.activityRows,
          )..orderBy([(t) => OrderingTerm.asc(t.day)])).get())
          .map((r) => LocalDate.parse(r.day))
          .toList();
  Future<bool> curriculumComplete() async =>
      (await learnedIds()).containsAll(vocabulary.byId.keys);

  Future<Streak> streak() async {
    final days = await activity();
    if (days.isEmpty) return const Streak(0, 0);
    var longest = 0;
    var run = 0;
    LocalDate? previous;
    for (final day in days) {
      run = previous?.daysUntil(day) == 1 ? run + 1 : 1;
      if (run > longest) longest = run;
      previous = day;
    }
    final eligible = days.where((d) => d.compareTo(today) <= 0).toList();
    if (await curriculumComplete()) return Streak(run, longest);
    if (eligible.isEmpty || eligible.last.daysUntil(today) > 1) {
      return Streak(0, longest);
    }
    var current = 1;
    for (var i = eligible.length - 1; i > 0; i--) {
      if (eligible[i - 1].daysUntil(eligible[i]) != 1) break;
      current++;
    }
    return Streak(current, longest);
  }
}
