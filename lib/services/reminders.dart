import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import '../domain/models.dart';

abstract interface class ReminderService {
  Future<bool> configure(
    UserPreferences preferences, {
    bool requestPermission = false,
  });
}

class LocalReminderService implements ReminderService {
  final FlutterLocalNotificationsPlugin plugin;
  bool _initialized = false;
  LocalReminderService({FlutterLocalNotificationsPlugin? plugin})
    : plugin = plugin ?? FlutterLocalNotificationsPlugin();
  Future<void> _initialize() async {
    if (_initialized) return;
    tzdata.initializeTimeZones();
    await plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('ic_notification'),
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        ),
      ),
    );
    _initialized = true;
  }

  @override
  Future<bool> configure(
    UserPreferences p, {
    bool requestPermission = false,
  }) async {
    if (!Platform.isAndroid && !Platform.isIOS) return !p.reminders;
    await _initialize();
    await plugin.cancel(id: 1);
    if (!p.reminders) return true;
    if (requestPermission) {
      final granted = Platform.isAndroid
          ? await plugin
                .resolvePlatformSpecificImplementation<
                  AndroidFlutterLocalNotificationsPlugin
                >()
                ?.requestNotificationsPermission()
          : await plugin
                .resolvePlatformSpecificImplementation<
                  IOSFlutterLocalNotificationsPlugin
                >()
                ?.requestPermissions(alert: true, badge: false, sound: true);
      if (granted != true) return false;
    } else {
      if (Platform.isAndroid) {
        final enabled = await plugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >()
            ?.areNotificationsEnabled();
        if (enabled != true) return false;
      }
    }
    final zone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(zone.identifier));
    final now = tz.TZDateTime.now(tz.local);
    var next = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      p.reminderHour,
      p.reminderMinute,
    );
    if (!next.isAfter(now)) {
      next = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day + 1,
        p.reminderHour,
        p.reminderMinute,
      );
    }
    await plugin.zonedSchedule(
      id: 1,
      title: 'A little German, every day.',
      body: 'Your words are waiting. Take a moment with Wortly.',
      scheduledDate: next,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_words',
          'Daily words',
          channelDescription: 'Your optional daily vocabulary reminder',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
    return true;
  }
}
