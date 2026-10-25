import 'dart:convert';
import 'dart:math';

import 'package:drift/drift.dart';

import '../domain/models.dart';
import 'database.dart';
import 'learning_repository.dart';
import 'vocabulary_repository.dart';

class QuizRepository {
  final AppDatabase db;
  final VocabularyRepository vocabulary;
  final LearningRepository learning;
  final AppClock clock;
  final Random random;
  QuizRepository(
    this.db,
    this.vocabulary,
    this.learning,
    this.clock, {
    Random? random,
  }) : random = random ?? Random.secure();
  LocalDate get today => LocalDate.from(clock.now());
  WeeklyTestSession _decode(QuizRow row) => WeeklyTestSession(
    week: LocalDate.parse(row.week),
    questions: (jsonDecode(row.questions) as List)
        .map((q) => QuizQuestion.fromJson(q as Map<String, dynamic>))
        .toList(),
    answers: WeeklyTestSession.decodeAnswers(row.answers),
    cursor: row.cursor,
    expired: row.expired,
    score: row.score,
  );

  Future<void> expireOldSessions() async {
    // Expiry is permanent. Leaving a session's Sunday never creates a score.
    await (db.update(
          db.quizRows,
        )..where((t) => t.score.isNull() & t.week.isNotValue(today.monday.key)))
        .write(const QuizRowsCompanion(expired: Value(true)));
    if (today.weekday != DateTime.sunday) {
      await (db.update(db.quizRows)..where((t) => t.score.isNull())).write(
        const QuizRowsCompanion(expired: Value(true)),
      );
    }
  }

  Future<WeeklyTestSession?> session() async {
    await expireOldSessions();
    final row = await (db.select(
      db.quizRows,
    )..where((t) => t.week.equals(today.monday.key))).getSingleOrNull();
    return row == null ? null : _decode(row);
  }

  Future<bool> unlocked() async {
    final date = today;
    if (date.weekday != DateTime.sunday) return false;
    final assignment = await learning.ensureToday();
    final finishedCollection =
        assignment.wordIds.isEmpty && await learning.curriculumComplete();
    if (!assignment.isComplete && !finishedCollection) return false;
    final learnedThisWeek =
        await (db.select(db.learnedRows)
              ..where((t) => t.day.isBetweenValues(date.monday.key, date.key))
              ..limit(1))
            .get();
    return learnedThisWeek.isNotEmpty;
  }

  Future<WeeklyTestSession> start() => db.transaction(() async {
    final existing = await session();
    if (existing != null) return existing;
    if (!await unlocked()) {
      throw StateError('Finish Sunday’s lesson to unlock your test.');
    }
    final date = today;
    final rows =
        await (db.select(db.learnedRows)
              ..where((t) => t.day.isBetweenValues(date.monday.key, date.key))
              ..orderBy([
                (t) => OrderingTerm.asc(t.day),
                (t) => OrderingTerm.asc(t.wordId),
              ]))
            .get();
    final questions = <QuizQuestion>[];
    for (final row in rows) {
      final word = vocabulary.byId[row.wordId];
      if (word == null) {
        throw StateError('Content update removed a learned word.');
      }
      final toEnglish = questions.length.isEven;
      String label(Word w) => toEnglish ? w.english.meaning : w.display;
      String key(Word w) => toEnglish ? w.english.answerKey : w.answerKey;
      final pool = [...vocabulary.words]..shuffle(random);
      final usedLabels = {label(word).toLowerCase().trim()};
      final usedKeys = {key(word)};
      final choices = <String>[label(word)];
      for (final candidate in pool) {
        if (candidate.id == word.id ||
            candidate.answerKey == word.answerKey ||
            candidate.english.answerKey == word.english.answerKey ||
            usedLabels.contains(label(candidate).toLowerCase().trim()) ||
            usedKeys.contains(key(candidate))) {
          continue;
        }
        usedLabels.add(label(candidate).toLowerCase().trim());
        usedKeys.add(key(candidate));
        choices.add(label(candidate));
        if (choices.length == 4) break;
      }
      if (choices.length != 4) {
        throw StateError('Not enough distinct quiz answers.');
      }
      choices.shuffle(random);
      questions.add(
        QuizQuestion(
          wordId: word.id,
          germanToEnglish: toEnglish,
          prompt: toEnglish ? word.display : word.english.meaning,
          choices: choices,
          correctIndex: choices.indexOf(label(word)),
        ),
      );
    }
    if (questions.isEmpty) throw StateError('No words learned this week.');
    await db
        .into(db.quizRows)
        .insert(
          QuizRowsCompanion.insert(
            week: date.monday.key,
            questions: jsonEncode(questions.map((q) => q.toJson()).toList()),
          ),
          mode: InsertMode.insertOrIgnore,
        );
    return (await session())!;
  });
  Future<WeeklyTestSession> answer(int questionIndex, int choice) =>
      db.transaction(() async {
        final current = await session();
        if (current == null) throw StateError('Start a test first.');
        if (current.expired || current.finished) return current;
        if (!await unlocked()) {
          throw StateError('This test is no longer available.');
        }
        if (current.cursor != questionIndex || current.selected != null) {
          return current;
        }
        if (choice < 0 || choice > 3) throw RangeError.range(choice, 0, 3);
        final answers = {...current.answers, questionIndex: choice};
        await (db.update(
          db.quizRows,
        )..where((t) => t.week.equals(current.week.key))).write(
          QuizRowsCompanion(
            answers: Value(
              jsonEncode(answers.map((k, v) => MapEntry(k.toString(), v))),
            ),
          ),
        );
        return (await session())!;
      });
  Future<WeeklyTestSession> advance(int questionIndex) =>
      db.transaction(() async {
        final current = await session();
        if (current == null) throw StateError('Start a test first.');
        if (current.expired ||
            current.finished ||
            current.cursor != questionIndex ||
            current.selected == null) {
          return current;
        }
        if (!await unlocked()) {
          throw StateError('This test is no longer available.');
        }
        if (current.cursor == current.questions.length - 1) {
          final score = current.answers.entries
              .where((e) => current.questions[e.key].correctIndex == e.value)
              .length;
          await (db.update(db.quizRows)
                ..where((t) => t.week.equals(current.week.key)))
              .write(QuizRowsCompanion(score: Value(score)));
        } else {
          await (db.update(db.quizRows)
                ..where((t) => t.week.equals(current.week.key)))
              .write(QuizRowsCompanion(cursor: Value(current.cursor + 1)));
        }
        return (await session())!;
      });
  Future<List<WeeklyTestSession>> scores() async =>
      (await (db.select(db.quizRows)
                ..where((t) => t.score.isNotNull())
                ..orderBy([(t) => OrderingTerm.desc(t.week)]))
              .get())
          .map(_decode)
          .toList();
}
