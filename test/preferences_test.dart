import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wortly/app_controller.dart';
import 'package:wortly/domain/models.dart';

import 'support.dart';

void main() {
  test('theme survives preference changes and a database reopen', () async {
    final dir = await Directory.systemTemp.createTemp('wortly-theme-');
    addTearDown(() => dir.delete(recursive: true));
    final file = File('${dir.path}/preferences.sqlite');
    final h = Harness(file: file);
    final container = ProviderContainer(
      overrides: [servicesProvider.overrideWithValue(h.services())],
    );
    await container.read(appProvider.future);
    final controller = container.read(appProvider.notifier);
    expect((await h.preferences.read()).themeMode, AppThemeMode.system);
    await controller.setThemeMode(AppThemeMode.dark);
    await controller.onboard(3);
    await controller.setGoal(5);
    await controller.setReminder(true, 8, 30);
    expect((await h.preferences.read()).themeMode, AppThemeMode.dark);
    container.dispose();
    await h.db.close();

    final reopened = Harness(file: file);
    addTearDown(reopened.db.close);
    final p = await reopened.preferences.read();
    expect(p.themeMode, AppThemeMode.dark);
    expect(p.dailyGoal, 5);
    expect(p.onboarded, isTrue);
    expect(p.reminders, isTrue);
    expect(p.reminderHour, 8);
    expect(p.reminderMinute, 30);
    expect((await reopened.learning.ensureToday()).goal, 3);
  });
  test(
    'goal change at midnight snapshots the old goal for today first',
    () async {
      final h = Harness();
      addTearDown(h.db.close);
      final container = ProviderContainer(
        overrides: [servicesProvider.overrideWithValue(h.services())],
      );
      addTearDown(container.dispose);
      await container.read(appProvider.future);
      await container.read(appProvider.notifier).onboard(3);
      h.clock.set('2026-10-20T00:00:01');
      await container.read(appProvider.notifier).setGoal(5);
      expect((await h.learning.ensureToday()).goal, 3);
      h.clock.set('2026-10-21T09:00:00');
      expect((await h.learning.ensureToday()).goal, 5);
    },
  );
  test(
    'reminders default off; startup and goal changes never request permission',
    () async {
      final h = Harness();
      addTearDown(h.db.close);
      final reminders = FakeReminders();
      final container = ProviderContainer(
        overrides: [
          servicesProvider.overrideWithValue(h.services(reminders: reminders)),
        ],
      );
      addTearDown(container.dispose);
      await container.read(appProvider.future);
      expect((await h.preferences.read()).reminders, false);
      await container.read(appProvider.notifier).onboard(3);
      await container.read(appProvider.notifier).setGoal(5);
      await container
          .read(appProvider.notifier)
          .refresh(rescheduleReminders: true);
      expect(reminders.permissionRequests, 0);
    },
  );
  test(
    'permission denied leaves reminders disabled, enabling persists time',
    () async {
      final h = Harness();
      addTearDown(h.db.close);
      final reminders = FakeReminders()..granted = false;
      final container = ProviderContainer(
        overrides: [
          servicesProvider.overrideWithValue(h.services(reminders: reminders)),
        ],
      );
      addTearDown(container.dispose);
      await container.read(appProvider.future);
      final controller = container.read(appProvider.notifier);
      expect(await controller.setReminder(true, 8, 30), false);
      expect((await h.preferences.read()).reminders, false);
      reminders.granted = true;
      expect(await controller.setReminder(true, 8, 30), true);
      expect((await h.preferences.read()).reminderHour, 8);
      expect((await h.preferences.read()).reminderMinute, 30);
      final requests = reminders.permissionRequests;
      await controller.setReminder(true, 10, 15);
      await controller.refresh(rescheduleReminders: true);
      await controller.setReminder(false, 10, 15);
      expect(reminders.permissionRequests, requests);
      expect((await h.preferences.read()).reminders, false);
    },
  );
}
