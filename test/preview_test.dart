import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wortly/app.dart';
import 'package:wortly/app_controller.dart';

import 'support.dart';

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
  testWidgets('render actual bundled fonts for visual review', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final h = Harness(date: '2026-10-25T09:00:00');
    addTearDown(h.db.close);
    final key = GlobalKey();
    final container = ProviderContainer(
      overrides: [servicesProvider.overrideWithValue(h.services())],
    );
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: RepaintBoundary(key: key, child: const WortlyApp()),
      ),
    );
    await tester.pumpAndSettle();
    Future<void> capture(String name) async {
      final boundary =
          key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
      await tester.runAsync(() async {
        final image = await boundary.toImage(pixelRatio: 2);
        final bytes = (await image.toByteData(format: ui.ImageByteFormat.png))!;
        await Directory('output/previews').create(recursive: true);
        await File('output/previews/$name.png')
            .writeAsBytes(bytes.buffer.asUint8List());
        image.dispose();
      });
      debugPrint('Captured $name');
    }

    await capture('01-onboarding');
    await tester.scrollUntilVisible(find.text('Let’s begin'), 200);
    await tester.tap(find.text('Let’s begin'));
    await tester.pumpAndSettle();
    await capture('02-today');
    await tester.tap(find.text('Progress'));
    await tester.pumpAndSettle();
    await capture('03-progress');
    await tester.tap(find.byTooltip('Settings'));
    await tester.pumpAndSettle();
    await capture('04-settings');
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Today'));
    await tester.pumpAndSettle();
    for (var i = 0; i < 3; i++) {
      final button = find.text('I’ve learned this word').first;
      await tester.ensureVisible(button);
      await tester.pumpAndSettle();
      await tester.tap(button);
      await tester.pumpAndSettle();
    }
    await tester.tap(find.text('Test'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Start weekly test'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Start weekly test'));
    await tester.pumpAndSettle();
    await capture('05-quiz');
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });
}
