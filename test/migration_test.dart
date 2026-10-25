import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wortly/data/database.dart';

import 'support.dart';

void main() {
  for (final version in [1, 2]) {
    test('schema $version to 3 preserves history and defaults to system theme', () async {
      final dir = await Directory.systemTemp.createTemp('wortly-migration-');
      addTearDown(() => dir.delete(recursive: true));
      final file = File('${dir.path}/migration.sqlite');
      final original = Harness(file: file, date: '2026-10-25T09:00:00');
      await original.goal(1);
      final a = await original.finish();
      final quiz = await original.quizzes.start();
      await original.quizzes.answer(0, quiz.current.correctIndex);
      await original.quizzes.advance(0);
      // Reconstruct each shipped schema rather than only changing user_version.
      await original.db.customStatement(
        'ALTER TABLE preference_rows DROP COLUMN theme_mode',
      );
      if (version == 1) {
        await original.db.customStatement('DROP TABLE content_rows');
      } else {
        await original.db.customStatement(
          "INSERT INTO content_rows VALUES ('existing', 390)",
        );
      }
      await original.db.customStatement('PRAGMA user_version = $version');
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
      expect(
        await upgraded.select(upgraded.contentRows).get(),
        hasLength(version == 1 ? 0 : 1),
      );
      expect(
        (await upgraded.select(upgraded.preferenceRows).get()).single.themeMode,
        'system',
      );
      expect(
        (await upgraded.customSelect('PRAGMA user_version').getSingle())
            .data['user_version'],
        3,
      );
    });
  }
}
