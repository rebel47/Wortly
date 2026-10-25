import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:wortly/domain/models.dart';
import 'package:wortly/data/learning_repository.dart';

import 'support.dart';

class RolloverClock implements AppClock {
  var reads = 0;
  @override
  DateTime now() => DateTime(2026, 10, reads++ == 0 ? 19 : 20);
}

void main() {
  late Harness h;
  setUp(() {
    h = Harness();
  });
  tearDown(() => h.db.close());
  test('defaults to three words ordered by usefulness', () async {
    final a = await h.learning.ensureToday();
    expect(a.goal, 3);
    expect(a.wordIds, h.vocabulary.words.take(3).map((w) => w.id));
    expect(a.completed, 0);
  });
  test(
    'concurrent assignment attempts produce one immutable assignment',
    () async {
      final days = await Future.wait(
        List.generate(12, (_) => h.learning.ensureToday()),
      );
      expect(days.map((a) => a.wordIds.join(',')).toSet().length, 1);
      expect(await h.db.select(h.db.assignmentRows).get(), hasLength(1));
    },
  );
  test('partial progress persists immediately and awards no streak', () async {
    final a = await h.learning.ensureToday();
    await h.learning.complete(a.wordIds[0], a.date);
    expect((await h.learning.ensureToday()).completed, 1);
    expect(await h.learning.activity(), isEmpty);
  });
  test('repeated and concurrent completion taps are idempotent', () async {
    final a = await h.learning.ensureToday();
    await Future.wait(
      List.generate(5, (_) => h.learning.complete(a.wordIds[0], a.date)),
    );
    expect((await h.learning.learnedIds()).length, 1);
    await h.finish();
    await h.finish();
    expect(await h.learning.activity(), hasLength(1));
    expect((await h.learning.streak()).current, 1);
  });
  test('goal changes only affect the following calendar date', () async {
    final a = await h.learning.ensureToday();
    await h.goal(5);
    expect((await h.learning.ensureToday()).wordIds, a.wordIds);
    expect((await h.learning.ensureToday()).goal, 3);
    h.clock.set('2026-10-20T09:00:00');
    expect((await h.learning.ensureToday()).goal, 5);
  });
  test(
    'carry unfinished words forward oldest first, then fill unseen',
    () async {
      final first = await h.learning.ensureToday();
      await h.learning.complete(first.wordIds[0], first.date);
      h.clock.set('2026-10-20T09:00:00');
      await h.goal(1);
      final second = await h.learning.ensureToday();
      expect(second.wordIds, [first.wordIds[1]]);
      await h.finish();
      h.clock.set('2026-10-21T09:00:00');
      await h.goal(3);
      final third = await h.learning.ensureToday();
      expect(third.wordIds, [
        first.wordIds[2],
        h.vocabulary.words[3].id,
        h.vocabulary.words[4].id,
      ]);
      expect(third.wordIds, isNot(contains(first.wordIds[0])));
    },
  );
  test('completion rejects non-assigned words', () async {
    final a = await h.learning.ensureToday();
    expect(
      await h.learning.complete(h.vocabulary.words.last.id, a.date),
      false,
    );
    expect(await h.learning.learnedIds(), isEmpty);
  });
  test('midnight rejects stale cards and snapshots a new assignment', () async {
    final a = await h.learning.ensureToday();
    h.clock.set('2026-10-20T00:00:01');
    expect(await h.learning.complete(a.wordIds.first, a.date), false);
    expect(await h.learning.learnedIds(), isEmpty);
    expect((await h.learning.ensureToday()).date.key, '2026-10-20');
  });
  test(
    'midnight during assignment lookup rejects the old completion',
    () async {
      final a = await h.learning.ensureToday();
      final changing = LearningRepository(
        h.db,
        h.vocabulary,
        h.preferences,
        RolloverClock(),
      );
      expect(await changing.complete(a.wordIds.first, a.date), false);
      expect(await h.learning.learnedIds(), isEmpty);
      expect(await h.learning.activity(), isEmpty);
    },
  );
  test(
    'consecutive calendar days grow streak; missing a day resets it',
    () async {
      await h.finish();
      h.clock.set('2026-10-20T23:59:00');
      expect((await h.learning.streak()).current, 1);
      await h.finish();
      expect((await h.learning.streak()).current, 2);
      h.clock.set('2026-10-22T09:00:00');
      expect((await h.learning.streak()).current, 0);
      await h.finish();
      expect((await h.learning.streak()).current, 1);
      expect((await h.learning.streak()).longest, 2);
    },
  );
  test(
    'revisiting an existing date does not replace its lesson or award twice',
    () async {
      final first = await h.finish();
      h.clock.set('2026-10-20T10:00:00');
      await h.finish();
      h.clock.set('2026-10-19T11:00:00');
      final revisited = await h.finish();
      expect(revisited.wordIds, first.wordIds);
      expect(await h.learning.activity(), hasLength(2));
    },
  );
  test(
    'revisiting a missed date cannot backfill its streak using carried words',
    () async {
      final missed = await h.learning.ensureToday();
      h.clock.set('2026-10-20T10:00:00');
      await h.finish();
      h.clock.set('2026-10-19T11:00:00');
      await h.learning.complete(missed.wordIds.first, missed.date);
      expect((await h.learning.activity()).map((d) => d.key), ['2026-10-20']);
    },
  );
  test('month and year boundary streak arithmetic', () async {
    h.clock.set('2026-12-31T23:55:00');
    await h.finish();
    h.clock.set('2027-01-01T00:05:00');
    await h.finish();
    expect((await h.learning.streak()).current, 2);
    expect(
      const LocalDate(2026, 12, 31).plusDays(1),
      const LocalDate(2027, 1, 1),
    );
  });
  test('invalid preferences cannot enter persistence', () async {
    expect(() => h.goal(2), throwsArgumentError);
  });
  test('remainder assignment, exhaustion and permanent final streak', () async {
    final tiny = Harness(count: 4);
    addTearDown(tiny.db.close);
    await tiny.finish();
    tiny.clock.set('2026-10-20T10:00:00');
    final last = await tiny.learning.ensureToday();
    expect(last.goal, 3);
    expect(last.wordIds, hasLength(1));
    await tiny.finish();
    expect(await tiny.learning.curriculumComplete(), true);
    tiny.clock.set('2027-03-01T10:00:00');
    expect((await tiny.learning.ensureToday()).wordIds, isEmpty);
    expect((await tiny.learning.streak()).current, 2);
    expect(await tiny.learning.activity(), hasLength(2));
  });
  test(
    'file-backed restart preserves lesson, preferences and partial progress',
    () async {
      final directory = await Directory.systemTemp.createTemp(
        'wortly-restart-',
      );
      addTearDown(() => directory.delete(recursive: true));
      final file = File('${directory.path}/test.sqlite');
      var persisted = Harness(file: file);
      await persisted.goal(5);
      final before = await persisted.learning.ensureToday();
      await persisted.learning.complete(before.wordIds.first, before.date);
      await persisted.db.close();
      persisted = Harness(file: file);
      final after = await persisted.learning.ensureToday();
      expect(after.wordIds, before.wordIds);
      expect(after.completed, 1);
      expect((await persisted.preferences.read()).dailyGoal, 5);
      await persisted.db.close();
    },
  );
}
