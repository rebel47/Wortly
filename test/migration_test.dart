import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wortly/data/database.dart';

import 'support.dart';

void main() {
  test('schema 1 to 2 adds content imports without clearing history', () async {
    final dir = await Directory.systemTemp.createTemp('wortly-migration-');
    addTearDown(() => dir.delete(recursive: true));
    final file = File('${dir.path}/migration.sqlite');
    final original = Harness(file: file, date: '2026-10-25T09:00:00');
    await original.goal(1);
    final a = await original.finish();
    final quiz = await original.quizzes.start();
    await original.quizzes.answer(0, quiz.current.correctIndex);
    await original.quizzes.advance(0);
    // v1 is exactly v2 without the additive content_rows metadata table.
    await original.db.customStatement('DROP TABLE content_rows');
    await original.db.customStatement('PRAGMA user_version = 1');
    await original.db.close();
    final upgraded = AppDatabase(NativeDatabase(file));
    addTearDown(upgraded.close);
    expect(
      (await upgraded.select(upgraded.preferenceRows).get()).single.dailyGoal,
      1,
    );
    expect(
      (await upgraded.select(upgraded.assignmentRows).get()).single.day,
      a.date.key,
    );
    expect(
      (await upgraded.select(upgraded.learnedRows).get()).single.wordId,
      a.wordIds.first,
    );
    expect(await upgraded.select(upgraded.activityRows).get(), hasLength(1));
    expect((await upgraded.select(upgraded.quizRows).get()).single.score, 1);
    expect(await upgraded.select(upgraded.contentRows).get(), isEmpty);
    expect(
      (await upgraded.customSelect('PRAGMA user_version').getSingle())
          .data['user_version'],
      2,
    );
  });
}
