import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wortly/app.dart';
import 'package:wortly/app_controller.dart';

import 'support.dart';

Future<void> openApp(
  WidgetTester tester,
  Harness h, {
  double scale = 1,
  Size size = const Size(390, 844),
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [servicesProvider.overrideWithValue(h.services())],
      child: MediaQuery(
        data: MediaQueryData(textScaler: TextScaler.linear(scale)),
        child: const WortlyApp(),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    for (final entry in {
      'Fraunces': 'assets/fonts/Fraunces.ttf',
      'DMSans': 'assets/fonts/DMSans.ttf',
      'MaterialIcons': 'fonts/MaterialIcons-Regular.otf',
    }.entries) {
      await (FontLoader(
        entry.key,
      )..addFont(rootBundle.load(entry.value))).load();
    }
  });
  testWidgets('onboarding chooses goal and immediately opens today', (
    tester,
  ) async {
    final h = Harness();
    addTearDown(h.db.close);
    await openApp(tester, h);
    expect(find.text('Small words.\nA world of possibility.'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('With English translations'),
      250,
    );
    expect(find.text('With English translations'), findsOneWidget);
    await tester.ensureVisible(find.bySemanticsLabel('1 word per day'));
    await tester.tap(find.bySemanticsLabel('1 word per day'));
    await tester.scrollUntilVisible(find.text('Let’s begin'), 200);
    await tester.tap(find.text('Let’s begin'));
    await tester.pumpAndSettle();
    expect(find.text('Guten Morgen.'), findsOneWidget);
    expect((await h.learning.ensureToday()).wordIds, hasLength(1));
    final button = find.text('I’ve learned this word').first;
    await tester.ensureVisible(button);
    await tester.pumpAndSettle();
    await tester.tap(button);
    await tester.pumpAndSettle();
    expect(find.text('Today, beautifully done.'), findsOneWidget);
    expect((await h.learning.streak()).current, 1);
  });
  testWidgets(
    'settings persists next-day goal and English, and progress has empty state',
    (tester) async {
      final h = Harness();
      addTearDown(h.db.close);
      await h.goal(3);
      await openApp(tester, h);
      await tester.tap(find.byTooltip('Settings'));
      await tester.pumpAndSettle();
      await tester.tap(find.bySemanticsLabel('5 words per day'));
      await tester.pumpAndSettle();
      expect((await h.preferences.read()).dailyGoal, 5);
      expect((await h.learning.ensureToday()).goal, 3);
      expect(find.text('English'), findsOneWidget);
      await tester.pageBack();
      await tester.pumpAndSettle();
      await tester.tap(find.text('Progress'));
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(
        find.text('Your story is just beginning.'),
        250,
      );
      expect(find.text('Your story is just beginning.'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets('Sunday test requires explicit next and saves score through UI', (
    tester,
  ) async {
    final h = Harness(date: '2026-10-25T09:00:00');
    addTearDown(h.db.close);
    await h.goal(1);
    await h.finish();
    await openApp(tester, h);
    await tester.tap(find.text('Test'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Start weekly test'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Start weekly test'));
    await tester.pumpAndSettle();
    final quiz = (await h.quizzes.session())!;
    await tester.ensureVisible(
      find.text(quiz.current.choices[quiz.current.correctIndex]),
    );
    await tester.tap(
      find.text(quiz.current.choices[quiz.current.correctIndex]),
    );
    await tester.pumpAndSettle();
    expect(find.text('That’s right. Schön gemacht!'), findsOneWidget);
    expect((await h.quizzes.session())!.score, isNull);
    await tester.ensureVisible(find.text('See my results'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('See my results'));
    await tester.pumpAndSettle();
    expect(find.text('1 / 1'), findsOneWidget);
    expect((await h.quizzes.scores()).single.score, 1);
  });
  testWidgets(
    'small screen with large text can navigate and read all primary screens',
    (tester) async {
      final h = Harness();
      addTearDown(h.db.close);
      await h.goal(3);
      await openApp(tester, h, scale: 2, size: const Size(320, 740));
      expect(tester.takeException(), isNull);
      await tester.tap(find.text('Test'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await tester.tap(find.text('Progress'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await tester.tap(find.byTooltip('Settings'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets('screen-reader labels and touch targets are available', (
    tester,
  ) async {
    final h = Harness();
    addTearDown(h.db.close);
    await h.goal(3);
    await openApp(tester, h);
    final semantics = tester.ensureSemantics();
    expect(find.byTooltip('Settings'), findsOneWidget);
    expect(find.bySemanticsLabel('Today’s learning progress'), findsOneWidget);
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    semantics.dispose();
  });
  testWidgets('collection complete screen links to the final Sunday test', (
    tester,
  ) async {
    final h = Harness(count: 4);
    addTearDown(h.db.close);
    await h.goal(3);
    await h.finish();
    h.clock.set('2026-10-20T09:00:00');
    await h.finish();
    h.clock.set('2026-10-25T09:00:00');
    await openApp(tester, h);
    expect(find.text('Look how far you’ve grown.'), findsOneWidget);
    await tester.ensureVisible(find.text('Take your weekly test'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Take your weekly test'));
    await tester.pumpAndSettle();
    expect(find.text('Start weekly test'), findsOneWidget);
    expect((await h.learning.streak()).current, 2);
  });
}
