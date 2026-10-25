import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../app_controller.dart';
import '../domain/models.dart';
import '../theme.dart';
import 'common.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});
  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool busy = false;
  bool savingTheme = false;

  Future<void> _theme(AppThemeMode? mode) async {
    if (mode == null) return;
    setState(() => savingTheme = true);
    try {
      await ref.read(appProvider.notifier).setThemeMode(mode);
    } catch (_) {
      if (mounted) showMessage(context, 'Couldn’t save your theme. Try again.');
    } finally {
      if (mounted) setState(() => savingTheme = false);
    }
  }

  Future<void> _reminder(bool enabled, int hour, int minute) async {
    setState(() => busy = true);
    try {
      final granted = await ref
          .read(appProvider.notifier)
          .setReminder(enabled, hour, minute);
      if (!granted && mounted) {
        showMessage(
          context,
          'Allow notifications in your device settings to enable reminders.',
        );
      }
    } catch (_) {
      if (mounted) {
        showMessage(
          context,
          'Couldn’t schedule the reminder. Please try again.',
        );
      }
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(appProvider);
    final p = state.asData?.value.preferences;
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: p == null
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: ListView(
                  padding: const EdgeInsets.all(24),
                  children: [
                    Text(
                      'Make it your rhythm.',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    const SizedBox(height: 10),
                    const Text('A small habit, on your terms.'),
                    const SizedBox(height: 32),
                    const Eyebrow('Appearance'),
                    const SizedBox(height: 14),
                    DropdownButtonFormField<AppThemeMode>(
                      key: ValueKey(p.themeMode),
                      initialValue: p.themeMode,
                      decoration: const InputDecoration(
                        labelText: 'Theme',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: AppThemeMode.system,
                          child: Text('System'),
                        ),
                        DropdownMenuItem(
                          value: AppThemeMode.light,
                          child: Text('Light'),
                        ),
                        DropdownMenuItem(
                          value: AppThemeMode.dark,
                          child: Text('Dark'),
                        ),
                      ],
                      onChanged: savingTheme ? null : _theme,
                    ),
                    const SizedBox(height: 30),
                    const Eyebrow('Daily goal'),
                    const SizedBox(height: 14),
                    GoalPicker(
                      value: p.dailyGoal,
                      onChanged: (v) async {
                        try {
                          await ref.read(appProvider.notifier).setGoal(v);
                        } catch (_) {
                          if (context.mounted) {
                            showMessage(
                              context,
                              'Couldn’t save your goal. Try again.',
                            );
                          }
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Changes begin with tomorrow’s lesson. Today’s words stay as they are.',
                      style: TextStyle(fontSize: 12),
                    ),
                    const SizedBox(height: 30),
                    const Eyebrow('Translation language'),
                    const SizedBox(height: 14),
                    Panel(
                      padding: EdgeInsets.all(18),
                      child: Row(
                        children: [
                          Icon(Icons.translate, color: context.colors.primary),
                          SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              'English',
                              style: TextStyle(
                                color: context.colors.onSurface,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.check_circle_outline,
                            color: context.colors.primary,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Eyebrow('A gentle nudge'),
                    const SizedBox(height: 14),
                    Panel(
                      padding: EdgeInsets.zero,
                      child: Column(
                        children: [
                          SwitchListTile.adaptive(
                            title: const Text(
                              'Daily reminder',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: const Text(
                              'A little time for your German.',
                            ),
                            value: p.reminders,
                            onChanged: busy
                                ? null
                                : (v) => _reminder(
                                    v,
                                    p.reminderHour,
                                    p.reminderMinute,
                                  ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 8,
                            ),
                          ),
                          if (p.reminders) ...[
                            const Divider(height: 1),
                            ListTile(
                              title: const Text('Reminder time'),
                              subtitle: const Text(
                                'Follows your local timezone',
                              ),
                              trailing: Text(
                                TimeOfDay(
                                  hour: p.reminderHour,
                                  minute: p.reminderMinute,
                                ).format(context),
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: context.colors.primary,
                                ),
                              ),
                              onTap: busy
                                  ? null
                                  : () async {
                                      final time = await showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay(
                                          hour: p.reminderHour,
                                          minute: p.reminderMinute,
                                        ),
                                      );
                                      if (time != null && mounted) {
                                        await _reminder(
                                          true,
                                          time.hour,
                                          time.minute,
                                        );
                                      }
                                    },
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    Panel(
                      color: context.colors.surfaceContainerHigh,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.spa_outlined,
                            color: context.colors.primary,
                          ),
                          SizedBox(height: 14),
                          Text(
                            'A space that’s yours.',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: context.colors.onSurface,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'No accounts. No feeds. No internet needed. Your words and progress live on this device.',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),
                    const Center(child: Brand()),
                    const SizedBox(height: 8),
                    Text(
                      'Version 0.1.0 · Made for a little daily growth.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11,
                        color: context.colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
