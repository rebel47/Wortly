import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/database.dart';
import 'data/learning_repository.dart';
import 'data/preferences_repository.dart';
import 'data/quiz_repository.dart';
import 'data/vocabulary_repository.dart';
import 'domain/models.dart';
import 'services/reminders.dart';

class AppServices {
  final AppDatabase database;
  final VocabularyRepository vocabulary;
  final AppClock clock;
  final ReminderService reminders;
  late final preferences = PreferencesRepository(database);
  late final learning = LearningRepository(
    database,
    vocabulary,
    preferences,
    clock,
  );
  late final quizzes = QuizRepository(database, vocabulary, learning, clock);
  AppServices({
    required this.database,
    required this.vocabulary,
    required this.clock,
    required this.reminders,
  });
}

final servicesProvider = Provider<AppServices>(
  (ref) => throw UnimplementedError('Inject AppServices'),
);
final appProvider = AsyncNotifierProvider<AppController, AppSnapshot>(
  AppController.new,
);

class AppSnapshot {
  final UserPreferences preferences;
  final DayAssignment? assignment;
  final Streak streak;
  final Set<String> learned;
  final List<LocalDate> activity;
  final WeeklyTestSession? quiz;
  final List<WeeklyTestSession> scores;
  final bool curriculumComplete;
  final bool quizAvailable;
  const AppSnapshot({
    required this.preferences,
    required this.assignment,
    required this.streak,
    required this.learned,
    required this.activity,
    required this.quiz,
    required this.scores,
    required this.curriculumComplete,
    required this.quizAvailable,
  });
}

class AppController extends AsyncNotifier<AppSnapshot> {
  AppServices get services => ref.read(servicesProvider);
  @override
  Future<AppSnapshot> build() async {
    await services.database
        .into(services.database.contentRows)
        .insert(
          ContentRowsCompanion.insert(
            version: services.vocabulary.version,
            recordCount: services.vocabulary.words.length,
          ),
          mode: InsertMode.insertOrIgnore,
        );
    final p = await services.preferences.read();
    // Permission dialogs are never triggered by startup or resume.
    try {
      await services.reminders.configure(p);
    } catch (_) {
      /* Retry from Settings. */
    }
    return _read();
  }

  Future<AppSnapshot> _read() async {
    final p = await services.preferences.read();
    final assignment = p.onboarded
        ? await services.learning.ensureToday()
        : null;
    return AppSnapshot(
      preferences: p,
      assignment: assignment,
      streak: await services.learning.streak(),
      learned: await services.learning.learnedIds(),
      activity: await services.learning.activity(),
      quiz: await services.quizzes.session(),
      scores: await services.quizzes.scores(),
      curriculumComplete: await services.learning.curriculumComplete(),
      quizAvailable: p.onboarded && await services.quizzes.unlocked(),
    );
  }

  Future<void> refresh({bool rescheduleReminders = false}) async {
    final next = await _read();
    state = AsyncData(next);
    if (rescheduleReminders) {
      try {
        await services.reminders.configure(next.preferences);
      } catch (_) {
        /* Settings permits retry. */
      }
    }
  }

  Future<void> onboard(int goal) async {
    final p = await services.preferences.read();
    await services.preferences.save(
      p.copyWith(dailyGoal: goal, onboarded: true),
    );
    await refresh();
  }

  Future<bool> complete(String id, LocalDate date) async {
    final accepted = await services.learning.complete(id, date);
    await refresh();
    return accepted;
  }

  Future<void> setGoal(int goal) async {
    final p = await services.preferences.read();
    // Snapshot the current date before changing preferences, including a
    // midnight rollover while Settings is already open.
    if (p.onboarded) await services.learning.ensureToday();
    await services.preferences.save(p.copyWith(dailyGoal: goal));
    await refresh();
  }

  Future<bool> setReminder(bool enabled, int hour, int minute) async {
    final old = await services.preferences.read();
    final next = old.copyWith(
      reminders: enabled,
      reminderHour: hour,
      reminderMinute: minute,
    );
    final granted = await services.reminders.configure(
      next,
      requestPermission: enabled && !old.reminders,
    );
    if (!granted && enabled) return false;
    await services.preferences.save(next);
    await refresh();
    return true;
  }

  Future<void> setThemeMode(AppThemeMode mode) async {
    final p = await services.preferences.read();
    await services.preferences.save(p.copyWith(themeMode: mode));
    await refresh();
  }

  Future<void> startQuiz() async {
    await services.quizzes.start();
    await refresh();
  }

  Future<void> answer(int index, int choice) async {
    await services.quizzes.answer(index, choice);
    await refresh();
  }

  Future<void> advance(int index) async {
    await services.quizzes.advance(index);
    await refresh();
  }
}
