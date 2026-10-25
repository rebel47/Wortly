import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../app_controller.dart';
import '../domain/models.dart';
import '../theme.dart';
import 'common.dart';

class ProgressScreen extends ConsumerWidget {
  final AppSnapshot data;
  const ProgressScreen({super.key, required this.data});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final services = ref.read(servicesProvider);
    final total = services.vocabulary.words.length;
    final today = LocalDate.from(services.clock.now());
    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      children: [
        const Eyebrow('Little by little'),
        const SizedBox(height: 10),
        Text(
          'Look at you grow.',
          style: Theme.of(context).textTheme.displaySmall,
        ),
        const SizedBox(height: 10),
        Text(
          'Every small step leaves a mark.',
          style: TextStyle(
            fontSize: 16,
            color: context.colors.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 28),
        Panel(
          color: context.colors.primary,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Eyebrow('Words in your world', color: context.colors.onPrimary),
              const SizedBox(height: 16),
              Text(
                '${data.learned.length}',
                style: TextStyle(
                  fontFamily: 'Fraunces',
                  fontSize: 56,
                  color: context.colors.onPrimary,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'of $total words learned',
                style: TextStyle(color: context.colors.onPrimary),
              ),
              const SizedBox(height: 20),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: total == 0 ? 0 : data.learned.length / total,
                  minHeight: 6,
                  color: context.colors.onPrimary,
                  backgroundColor: context.colors.onPrimary.withValues(
                    alpha: 0.2,
                  ),
                  semanticsLabel: 'Curriculum progress',
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _Stat(
                value: '${data.streak.current}',
                label: 'Current streak',
                icon: Icons.local_fire_department_outlined,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _Stat(
                value: '${data.streak.longest}',
                label: 'Longest streak',
                icon: Icons.emoji_events_outlined,
              ),
            ),
          ],
        ),
        const SizedBox(height: 28),
        const Eyebrow('Showing up, day by day'),
        const SizedBox(height: 14),
        ActivityCalendar(today: today, activity: data.activity.toSet()),
        const SizedBox(height: 28),
        const Eyebrow('Your weekly reflections'),
        const SizedBox(height: 14),
        if (data.scores.isEmpty)
          Panel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.auto_awesome_outlined,
                  color: context.colors.primary,
                ),
                SizedBox(height: 12),
                Text(
                  'Your story is just beginning.',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: context.colors.onSurface,
                  ),
                ),
                SizedBox(height: 6),
                Text('Complete a Sunday test to see your results here.'),
              ],
            ),
          )
        else
          for (final score in data.scores)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Panel(
                padding: const EdgeInsets.all(18),
                child: Row(
                  children: [
                    Icon(
                      Icons.assignment_turned_in_outlined,
                      color: context.colors.primary,
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Week of ${DateFormat('d MMM y').format(DateTime(score.week.year, score.week.month, score.week.day))}',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: context.colors.onSurface,
                            ),
                          ),
                          Text(
                            '${score.questions.length} words revisited',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '${score.score}/${score.questions.length}',
                      style: TextStyle(
                        fontFamily: 'Fraunces',
                        fontSize: 23,
                        color: context.colors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  const _Stat({required this.value, required this.label, required this.icon});
  @override
  Widget build(BuildContext context) => Panel(
    padding: const EdgeInsets.all(20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: context.colors.tertiary, size: 24),
        const SizedBox(height: 16),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.end,
          spacing: 6,
          children: [
            Text(
              value,
              style: TextStyle(
                fontFamily: 'Fraunces',
                fontSize: 34,
                color: context.colors.primary,
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 5),
              child: Text('days', style: TextStyle(fontSize: 12)),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    ),
  );
}

class ActivityCalendar extends StatelessWidget {
  final LocalDate today;
  final Set<LocalDate> activity;
  const ActivityCalendar({
    super.key,
    required this.today,
    required this.activity,
  });
  @override
  Widget build(BuildContext context) {
    final start = today.monday.plusDays(-28);
    return Panel(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              for (final day in ['M', 'T', 'W', 'T', 'F', 'S', 'S'])
                Expanded(
                  child: Center(
                    child: Text(
                      day,
                      style: TextStyle(
                        fontSize: 11,
                        color: context.colors.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          for (var week = 0; week < 5; week++)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  for (var day = 0; day < 7; day++)
                    Expanded(
                      child: _CalendarDay(
                        date: start.plusDays(week * 7 + day),
                        today: today,
                        activity: activity,
                      ),
                    ),
                ],
              ),
            ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.circle, color: context.colors.primary, size: 9),
              SizedBox(width: 7),
              Flexible(
                child: Text(
                  'Daily goal completed · last 5 weeks',
                  style: TextStyle(
                    fontSize: 11,
                    color: context.colors.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CalendarDay extends StatelessWidget {
  final LocalDate date;
  final LocalDate today;
  final Set<LocalDate> activity;
  const _CalendarDay({
    required this.date,
    required this.today,
    required this.activity,
  });
  @override
  Widget build(BuildContext context) {
    final done = activity.contains(date);
    final future = date.compareTo(today) > 0;
    return Semantics(
      label:
          '${date.key}, ${done
              ? 'daily goal completed'
              : future
              ? 'upcoming'
              : 'no completed goal'}',
      child: Tooltip(
        message: '${date.key}${done ? ' · goal complete' : ''}',
        child: Container(
          margin: const EdgeInsets.all(3),
          constraints: const BoxConstraints(minHeight: 32),
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: done
                ? context.colors.primary
                : future
                ? context.colors.surface
                : context.colors.surfaceContainerHigh,
            border: Border.all(
              color: date == today
                  ? context.colors.primary
                  : Colors.transparent,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ExcludeSemantics(
            child: Text(
              '${date.day}',
              style: TextStyle(
                fontSize: 11,
                color: done
                    ? context.colors.onPrimary
                    : future
                    ? context.colors.onSurfaceVariant.withValues(alpha: 0.7)
                    : context.colors.onSurfaceVariant,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
