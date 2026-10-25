import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wortly/app.dart';
import 'package:wortly/app_controller.dart';
import 'package:wortly/data/database.dart';
import 'package:wortly/data/vocabulary_repository.dart';
import 'package:wortly/domain/models.dart';
import 'package:wortly/services/reminders.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets(
    'native SQLite survives closing and reopening the app services offline',
    (tester) async {
      final directory = await getApplicationSupportDirectory();
      final file = File('${directory.path}/wortly-integration.sqlite');
      if (await file.exists()) await file.delete();
      final vocabulary = await VocabularyRepository.load();
      AppServices create() => AppServices(
        database: AppDatabase(NativeDatabase(file)),
        vocabulary: vocabulary,
        clock: const SystemClock(),
        reminders: LocalReminderService(),
      );
      var services = create();
      Future<void> mount() async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [servicesProvider.overrideWithValue(services)],
            child: const WortlyApp(),
          ),
        );
        await tester.pumpAndSettle();
      }

      await mount();
      await tester.ensureVisible(find.bySemanticsLabel('1 word per day'));
      await tester.pumpAndSettle();
      await tester.tap(find.bySemanticsLabel('1 word per day'));
      await tester.ensureVisible(find.text('Let’s begin'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Let’s begin'));
      await tester.pumpAndSettle();
      await tester.tap(find.text("Learn today's word"));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('I’ve learned this word').first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('I’ve learned this word').first);
      await tester.pumpAndSettle();
      expect(find.text('Today, beautifully done.'), findsOneWidget);
      final ids = (await services.learning.ensureToday()).wordIds;
      await tester.pumpWidget(const SizedBox());
      await services.database.close();
      services = create();
      await mount();
      expect(find.text('Today, beautifully done.'), findsOneWidget);
      expect((await services.learning.ensureToday()).wordIds, ids);
      expect((await services.learning.learnedIds()).length, 1);
      expect((await services.learning.streak()).current, 1);
      expect((await services.preferences.read()).dailyGoal, 1);
      await tester.pumpWidget(const SizedBox());
      await services.database.close();
      await file.delete();
    },
  );
}
