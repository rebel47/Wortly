import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../app_controller.dart';
import '../theme.dart';
import 'common.dart';
import 'lesson.dart';

class TodayScreen extends ConsumerWidget {
  final AppSnapshot data;
  final VoidCallback onTest;
  const TodayScreen({super.key, required this.data, required this.onTest});

  void _openLesson(BuildContext context, {bool review = false}) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (_) =>
            LessonScreen(date: data.assignment!.date, review: review),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final a = data.assignment!;
    final now = ref.read(servicesProvider).clock.now();
    final total = a.wordIds.length;
    final greeting = now.hour < 12
        ? 'Guten Morgen.'
        : now.hour < 18
        ? 'Guten Tag.'
        : 'Guten Abend.';
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
            children: [
              Eyebrow(DateFormat('EEEE, d MMMM', 'en_US').format(now)),
              const SizedBox(height: 10),
              Text(greeting, style: Theme.of(context).textTheme.displaySmall),
              const SizedBox(height: 8),
              Text(
                a.isComplete
                    ? 'A little more German, a little more you.'
                    : 'A little room for German, every day.',
                style: Theme.of(context).textTheme.bodyLarge
                    ?.copyWith(color: context.colors.onSurfaceVariant),
              ),
              const SizedBox(height: 28),
              if (data.curriculumComplete)
                EmptyMoment(
                  icon: Icons.park_outlined,
                  title: 'Look how far you’ve grown.',
                  description:
                      'You’ve learned all ${ref.read(servicesProvider).vocabulary.words.length} words in this collection. Your final streak is yours to keep.',
                  action: data.quizAvailable
                      ? FilledButton(
                          onPressed: onTest,
                          child: const Text('Take your weekly test'),
                        )
                      : null,
                )
              else if (a.isComplete)
                EmptyMoment(
                  icon: Icons.check_rounded,
                  title: 'Today, beautifully done.',
                  description:
                      '$total new word${total == 1 ? '' : 's'} to take into your world. Come back tomorrow for a fresh lesson.',
                  action: data.quizAvailable
                      ? FilledButton(
                          onPressed: onTest,
                          child: const Text('Take your weekly test'),
                        )
                      : null,
                )
              else if (total == 0)
                const EmptyMoment(
                  icon: Icons.eco_outlined,
                  title: 'A moment to pause.',
                  description: 'There are no new words to learn today.',
                )
              else
                Panel(
                  color: context.colors.surfaceContainerHigh,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Expanded(child: Eyebrow('Your daily lesson')),
                          Icon(
                            Icons.auto_stories_outlined,
                            color: context.colors.primary,
                            size: 28,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        a.completed == 0
                            ? '$total useful word${total == 1 ? '' : 's'}.'
                            : '${total - a.completed} word${total - a.completed == 1 ? '' : 's'} to go.',
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        a.completed == 0
                            ? 'One small step for your German.'
                            : 'Pick up right where you left off.',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 28),
                      Semantics(
                        container: true,
                        label: 'Today’s learning progress',
                        value: '${a.completed} of $total learned',
                        child: ExcludeSemantics(
                          child: Row(
                            children: [
                              for (var i = 0; i < total; i++)
                                Expanded(
                                  child: Container(
                                    height: 6,
                                    margin: EdgeInsets.only(
                                      right: i == total - 1 ? 0 : 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: i < a.completed
                                          ? context.colors.primary
                                          : context.colors.primary.withValues(
                                              alpha: 0.15,
                                            ),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '${a.completed} of $total learned',
                        style: TextStyle(
                          color: context.colors.onSurfaceVariant,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 16),
              Panel(
                padding: const EdgeInsets.all(18),
                child: Row(
                  children: [
                    Icon(
                      Icons.local_fire_department_outlined,
                      color: context.colors.tertiary,
                      size: 28,
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${data.streak.current} day${data.streak.current == 1 ? '' : 's'} in a row',
                            style: TextStyle(
                              color: context.colors.onSurface,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            a.isComplete
                                ? 'You showed up for yourself today.'
                                : 'Small steps make lasting habits.',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (total > 0)
          SafeArea(
            top: false,
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
              child: SizedBox(
                width: double.infinity,
                child: a.isComplete
                    ? OutlinedButton.icon(
                        onPressed: () => _openLesson(context, review: true),
                        icon: const Icon(Icons.replay_rounded, size: 20),
                        label: const Text('Revisit today’s words'),
                      )
                    : FilledButton(
                        onPressed: () => _openLesson(context),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Text(
                                a.completed > 0
                                    ? 'Continue learning'
                                    : "Learn today's word${total == 1 ? '' : 's'}",
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Icon(Icons.arrow_forward_rounded, size: 20),
                          ],
                        ),
                      ),
              ),
            ),
          ),
      ],
    );
  }
}
