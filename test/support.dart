import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:drift/native.dart';
import 'package:wortly/app_controller.dart';
import 'package:wortly/data/database.dart';
import 'package:wortly/data/learning_repository.dart';
import 'package:wortly/data/preferences_repository.dart';
import 'package:wortly/data/quiz_repository.dart';
import 'package:wortly/data/vocabulary_repository.dart';
import 'package:wortly/domain/models.dart';
import 'package:wortly/services/reminders.dart';

class MutableClock implements AppClock {
  DateTime value;
  MutableClock(this.value);
  @override
  DateTime now() => value;
  void set(String value) => this.value = DateTime.parse(value);
}

class FakeReminders implements ReminderService {
  bool granted = true;
  int permissionRequests = 0;
  @override
  Future<bool> configure(
    UserPreferences preferences, {
    bool requestPermission = false,
  }) async {
    if (requestPermission) permissionRequests++;
    return !preferences.reminders || granted;
  }
}

VocabularyRepository fixture({int? count}) {
  final json = jsonDecode(
    File('assets/content/vocabulary.json').readAsStringSync(),
  ) as Map<String, dynamic>;
  final words = (json['words'] as List)
      .map((j) => Word.fromJson(j as Map<String, dynamic>))
      .toList();
  return VocabularyRepository(
    'test',
    count == null ? words : words.take(count).toList(),
  );
}

class Harness {
  final AppDatabase db;
  final MutableClock clock;
  final VocabularyRepository vocabulary;
  late final preferences = PreferencesRepository(db);
  late final learning = LearningRepository(db, vocabulary, preferences, clock);
  late final quizzes = QuizRepository(
    db,
    vocabulary,
    learning,
    clock,
    random: Random(42),
  );
  Harness({String date = '2026-10-19T09:00:00', File? file, int? count})
    : db = AppDatabase(
        file == null ? NativeDatabase.memory() : NativeDatabase(file),
      ),
      clock = MutableClock(DateTime.parse(date)),
      vocabulary = fixture(count: count);
  Future<void> goal(int value) =>
      preferences.save(UserPreferences(dailyGoal: value, onboarded: true));
  Future<DayAssignment> finish() async {
    final assignment = await learning.ensureToday();
    for (final id in assignment.wordIds) {
      await learning.complete(id, assignment.date);
    }
    return learning.ensureToday();
  }

  AppServices services({FakeReminders? reminders}) => AppServices(
    database: db,
    vocabulary: vocabulary,
    clock: clock,
    reminders: reminders ?? FakeReminders(),
  );
}
