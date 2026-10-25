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
        const Text(
          'Every small step leaves a mark.',
          style: TextStyle(fontSize: 16, color: muted),
        ),
        const SizedBox(height: 28),
        Panel(
          color: forest,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Eyebrow('Words in your world', color: Color(0xFFD5DFC8)),
              const SizedBox(height: 16),
              Text(
                '${data.learned.length}',
                style: const TextStyle(
                  fontFamily: 'Fraunces',
                  fontSize: 56,
                  color: paper,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'of $total words learned',
                style: const TextStyle(color: Color(0xFFE2E9D9)),
              ),
              const SizedBox(height: 20),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: total == 0 ? 0 : data.learned.length / total,
                  minHeight: 6,
                  color: const Color(0xFFCADBB2),
                  backgroundColor: const Color(0xFF466754),
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
          const Panel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.auto_awesome_outlined, color: forest),
                SizedBox(height: 12),
                Text(
                  'Your story is just beginning.',
                  style: TextStyle(fontWeight: FontWeight.w600, color: ink),
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
                    const Icon(
                      Icons.assignment_turned_in_outlined,
                      color: forest,
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Week of ${DateFormat('d MMM y').format(DateTime(score.week.year, score.week.month, score.week.day))}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: ink,
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
                      style: const TextStyle(
                        fontFamily: 'Fraunces',
                        fontSize: 23,
                        color: forest,
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
        Icon(icon, color: amber, size: 24),
        const SizedBox(height: 16),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.end,
          spacing: 6,
          children: [
            Text(
              value,
              style: const TextStyle(
                fontFamily: 'Fraunces',
                fontSize: 34,
                color: forest,
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
                      style: const TextStyle(fontSize: 11, color: muted),
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
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.circle, color: forest, size: 9),
              SizedBox(width: 7),
              Flexible(
                child: Text(
                  'Daily goal completed · last 5 weeks',
                  style: TextStyle(fontSize: 11, color: muted),
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
                ? forest
                : future
                ? paper
                : sage,
            border: Border.all(
              color: date == today ? forest : Colors.transparent,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ExcludeSemantics(
            child: Text(
              '${date.day}',
              style: TextStyle(
                fontSize: 11,
                color: done
                    ? paper
                    : future
                    ? const Color(0xFF949C90)
                    : muted,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
