import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'support.dart';

void main() {
  late Harness h;
  setUp(() {
    h = Harness();
  });
  tearDown(() => h.db.close());
  test('only Sunday after the whole assignment unlocks the quiz', () async {
    await h.finish();
    expect(await h.quizzes.unlocked(), false);
    expect(h.quizzes.start, throwsStateError);
    h.clock.set('2026-10-25T09:00:00');
    final a = await h.learning.ensureToday();
    await h.learning.complete(a.wordIds.first, a.date);
    expect(await h.quizzes.unlocked(), false);
    await h.finish();
    expect(await h.quizzes.unlocked(), true);
  });
  test('finishing the corpus before Sunday still permits this week’s test without a new streak day', () async {
    final tiny = Harness(count: 4);
    addTearDown(tiny.db.close);
    await tiny.finish();
    tiny.clock.set('2026-10-20T09:00:00');
    await tiny.finish();
    tiny.clock.set('2026-10-25T09:00:00');
    expect((await tiny.learning.ensureToday()).wordIds, isEmpty);
    expect(await tiny.quizzes.unlocked(), true);
    expect((await tiny.quizzes.start()).questions, hasLength(4));
    expect(await tiny.learning.activity(), hasLength(2));
    expect((await tiny.learning.streak()).current, 2);
    tiny.clock.set('2026-11-01T09:00:00');
    expect(await tiny.quizzes.unlocked(), false);
  });
  test(
    'membership is distinct completions this local Monday through Sunday only',
    () async {
      h.clock.set('2026-10-18T09:00:00');
      final previous = await h.finish();
      h.clock.set('2026-10-19T09:00:00');
      final monday = await h.finish();
      h.clock.set('2026-10-25T09:00:00');
      final sunday = await h.finish();
      final quiz = await h.quizzes.start();
      final ids = quiz.questions.map((q) => q.wordId).toList();
      expect(ids.toSet(), {...monday.wordIds, ...sunday.wordIds});
      expect(ids.toSet().intersection(previous.wordIds.toSet()), isEmpty);
      expect(ids.toSet().length, ids.length);
    },
  );
  test('directions alternate and choices are distinct with exactly one correct answer', () async {
    h.clock.set('2026-10-25T09:00:00');
    await h.finish();
    final quiz = await h.quizzes.start();
    for (var i = 0; i < quiz.questions.length; i++) {
      final q = quiz.questions[i];
      final word = h.vocabulary.byId[q.wordId]!;
      expect(q.germanToEnglish, i.isEven);
      expect(q.choices, hasLength(4));
      expect(q.choices.toSet(), hasLength(4));
      expect(
        q.choices[q.correctIndex],
        i.isEven ? word.english.meaning : word.display,
      );
      expect(q.prompt, i.isEven ? word.display : word.english.meaning);
    }
    expect(
      (await h.quizzes.start()).questions.map((q) => q.toJson()),
      quiz.questions.map((q) => q.toJson()),
    );
  });
  test(
    'all curated equivalence groups are excluded from distractors',
    () async {
      // Run through the entire draft corpus in one week using normal goals.
      await h.goal(5);
      final db = h.db;
      final learned = h.vocabulary.words;
      for (final w in learned.take(100)) {
        await db.customStatement(
          'INSERT INTO learned_rows(word_id, day) VALUES (?, ?)',
          [w.id, '2026-10-19'],
        );
      }
      h.clock.set('2026-10-25T09:00:00');
      await h.finish();
      final quiz = await h.quizzes.start();
      for (final q in quiz.questions) {
        final correct = h.vocabulary.byId[q.wordId]!;
        final equivalents = h.vocabulary.words.where(
          (w) =>
              w.id != correct.id &&
              (w.answerKey == correct.answerKey ||
                  w.english.answerKey == correct.english.answerKey),
        );
        for (final w in equivalents) {
          final label = q.germanToEnglish ? w.english.meaning : w.display;
          if (label != q.choices[q.correctIndex]) {
            expect(q.choices, isNot(contains(label)));
          }
        }
      }
    },
  );
  test(
    'answer locks, feedback remains, explicit advance and stale taps are safe',
    () async {
      h.clock.set('2026-10-25T09:00:00');
      await h.finish();
      final q = await h.quizzes.start();
      await h.quizzes.advance(0);
      expect((await h.quizzes.session())!.cursor, 0);
      await h.quizzes.answer(0, q.current.correctIndex);
      await h.quizzes.answer(0, (q.current.correctIndex + 1) % 4);
      final answered = (await h.quizzes.session())!;
      expect(answered.cursor, 0);
      expect(answered.selected, q.current.correctIndex);
      await Future.wait([h.quizzes.advance(0), h.quizzes.advance(0)]);
      expect((await h.quizzes.session())!.cursor, 1);
      await h.quizzes.answer(0, 2);
      expect((await h.quizzes.session())!.selected, isNull);
    },
  );
  test('one final score per week and test never changes streak', () async {
    h.clock.set('2026-10-25T09:00:00');
    await h.finish();
    final streakBefore = await h.learning.streak();
    var quiz = await h.quizzes.start();
    while (!quiz.finished) {
      await h.quizzes.answer(
        quiz.cursor,
        quiz.cursor == 0
            ? (quiz.current.correctIndex + 1) % 4
            : quiz.current.correctIndex,
      );
      quiz = await h.quizzes.advance(quiz.cursor);
    }
    expect(quiz.score, quiz.questions.length - 1);
    await h.quizzes.start();
    await h.quizzes.advance(quiz.cursor);
    expect(await h.quizzes.scores(), hasLength(1));
    expect((await h.learning.streak()).current, streakBefore.current);
    expect(await h.learning.activity(), hasLength(1));
  });
  test(
    'incomplete test expires at Sunday end, without creating a score',
    () async {
      h.clock.set('2026-10-25T23:59:00');
      await h.finish();
      final started = await h.quizzes.start();
      await h.quizzes.answer(0, started.current.correctIndex);
      h.clock.set('2026-10-26T00:00:00');
      expect(await h.quizzes.session(), isNull);
      expect(await h.quizzes.scores(), isEmpty);
      expect((await h.db.select(h.db.quizRows).get()).single.expired, true);
      h.clock.set('2026-10-25T12:00:00');
      expect((await h.quizzes.session())!.expired, true);
      await h.quizzes.advance(0);
      expect((await h.quizzes.session())!.cursor, 0);
    },
  );
  test('completed scores remain after week rollover', () async {
    await h.goal(1);
    h.clock.set('2026-10-25T09:00:00');
    await h.finish();
    final quiz = await h.quizzes.start();
    await h.quizzes.answer(0, quiz.current.correctIndex);
    await h.quizzes.advance(0);
    h.clock.set('2026-11-02T09:00:00');
    await h.quizzes.session();
    expect((await h.quizzes.scores()).single.score, 1);
  });
  test(
    'file restart freezes answer order, chosen answer and current question',
    () async {
      final dir = await Directory.systemTemp.createTemp('wortly-quiz-');
      addTearDown(() => dir.delete(recursive: true));
      final file = File('${dir.path}/quiz.sqlite');
      var persisted = Harness(file: file, date: '2026-10-25T09:00:00');
      await persisted.finish();
      final before = await persisted.quizzes.start();
      await persisted.quizzes.answer(0, before.current.correctIndex);
      await persisted.db.close();
      persisted = Harness(file: file, date: '2026-10-25T10:00:00');
      final after = (await persisted.quizzes.session())!;
      expect(
        after.questions.map((q) => q.toJson()),
        before.questions.map((q) => q.toJson()),
      );
      expect(after.selected, before.current.correctIndex);
      expect(after.cursor, 0);
      await persisted.db.close();
    },
  );
}
