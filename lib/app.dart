import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_controller.dart';
import 'domain/models.dart';
import 'theme.dart';
import 'ui/common.dart';
import 'ui/onboarding.dart';
import 'ui/progress.dart';
import 'ui/quiz.dart';
import 'ui/settings.dart';
import 'ui/today.dart';

class WortlyApp extends ConsumerWidget {
  const WortlyApp({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) => MaterialApp(
    title: 'Wortly',
    debugShowCheckedModeBanner: false,
    theme: wortlyTheme(),
    darkTheme: wortlyTheme(brightness: Brightness.dark),
    themeMode: switch (ref
        .watch(appProvider)
        .asData
        ?.value
        .preferences
        .themeMode) {
      AppThemeMode.light => ThemeMode.light,
      AppThemeMode.dark => ThemeMode.dark,
      _ => ThemeMode.system,
    },
    home: const _AppRoot(),
  );
}

class _AppRoot extends ConsumerStatefulWidget {
  const _AppRoot();
  @override
  ConsumerState<_AppRoot> createState() => _AppRootState();
}

class _AppRootState extends ConsumerState<_AppRoot>
    with WidgetsBindingObserver {
  Timer? timer;
  LocalDate? date;
  int destination = 0;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    date = LocalDate.from(ref.read(servicesProvider).clock.now());
    timer = Timer.periodic(const Duration(seconds: 15), (_) => _recheck());
  }

  Future<void> _recheck({bool resume = false}) async {
    final next = LocalDate.from(ref.read(servicesProvider).clock.now());
    if (next != date || resume) {
      date = next;
      try {
        await ref
            .read(appProvider.notifier)
            .refresh(rescheduleReminders: resume);
      } catch (_) {
        /* Persisted data is retained; retry on the next resume. */
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) unawaited(_recheck(resume: true));
  }

  @override
  void dispose() {
    timer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ref
      .watch(appProvider)
      .when(
        loading: () =>
            const Scaffold(body: Center(child: CircularProgressIndicator())),
        error: (error, stack) => Scaffold(
          body: SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: EmptyMoment(
                  icon: Icons.spa_outlined,
                  title: 'Let’s try that again.',
                  description: 'Your saved progress is still here. We couldn’t open your lesson.',
                  action: FilledButton(
                    onPressed: () => ref.invalidate(appProvider),
                    child: const Text('Try again'),
                  ),
                ),
              ),
            ),
          ),
        ),
        data: (data) {
          if (!data.preferences.onboarded) return const OnboardingScreen();
          return Scaffold(
            appBar: AppBar(
              title: const Padding(
                padding: EdgeInsets.only(left: 8),
                child: Brand(),
              ),
              actions: [
                IconButton(
                  tooltip: 'Settings',
                  icon: const Icon(Icons.tune_rounded, size: 23),
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const SettingsScreen(),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
              ],
            ),
            body: SafeArea(
              bottom: false,
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: AnimatedSwitcher(
                    duration: MediaQuery.disableAnimationsOf(context)
                        ? Duration.zero
                        : const Duration(milliseconds: 180),
                    child: switch (destination) {
                      0 => TodayScreen(
                        key: ValueKey('today-${data.assignment?.date}'),
                        data: data,
                        onTest: () => setState(() => destination = 1),
                      ),
                      1 => QuizScreen(
                        key: const ValueKey('test'),
                        data: data,
                        onToday: () => setState(() => destination = 0),
                      ),
                      _ => ProgressScreen(
                        key: const ValueKey('progress'),
                        data: data,
                      ),
                    },
                  ),
                ),
              ),
            ),
            bottomNavigationBar: Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: context.colors.outlineVariant),
                ),
              ),
              child: NavigationBar(
                selectedIndex: destination,
                onDestinationSelected: (v) {
                  setState(() => destination = v);
                  unawaited(_recheck());
                },
                destinations: const [
                  NavigationDestination(
                    icon: Icon(Icons.wb_sunny_outlined),
                    selectedIcon: Icon(Icons.wb_sunny_rounded),
                    label: 'Today',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.style_outlined),
                    selectedIcon: Icon(Icons.style_rounded),
                    label: 'Test',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.spa_outlined),
                    selectedIcon: Icon(Icons.spa_rounded),
                    label: 'Progress',
                  ),
                ],
              ),
            ),
          );
        },
      );
}
