import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../app_controller.dart';
import '../domain/models.dart';
import '../theme.dart';
import 'common.dart';

class QuizScreen extends ConsumerWidget {
  final AppSnapshot data;
  final VoidCallback onToday;
  const QuizScreen({super.key, required this.data, required this.onToday});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = ref.read(servicesProvider).clock.now();
    final sunday = now.weekday == DateTime.sunday;
    final unlocked = data.quizAvailable;
    final quiz = data.quiz;
    final finished = quiz?.finished ?? false;
    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      children: [
        const Eyebrow('A moment to remember'),
        const SizedBox(height: 10),
        Text(
          'Your weekly test.',
          style: Theme.of(context).textTheme.displaySmall,
        ),
        const SizedBox(height: 10),
        Text(
          'See how much has stayed with you.',
          style: TextStyle(
            fontSize: 16,
            color: context.colors.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 28),
        if (finished)
          _Score(session: quiz!)
        else if (quiz?.expired ?? false)
          const EmptyMoment(
            icon: Icons.hourglass_empty_rounded,
            title: 'A fresh start next Sunday.',
            description: 'This test has expired. Your next test will include the words you learn in the new week.',
          )
        else if (sunday && data.curriculumComplete && !unlocked)
          const EmptyMoment(
            icon: Icons.park_outlined,
            title: 'Your collection is complete.',
            description: 'There are no new words to test this week. Your past results are saved in Progress.',
          )
        else if (!unlocked) ...[
          EmptyMoment(
            icon: Icons.wb_sunny_outlined,
            title: sunday
                ? 'One small step first.'
                : 'Sundays are for looking back.',
            description: sunday
                ? 'Finish today’s words to unlock your weekly test. Every word learned since Monday will be here.'
                : 'Your test opens on Sunday after your daily lesson. Until then, keep growing your vocabulary.',
            action: FilledButton(
              onPressed: onToday,
              child: Text(
                sunday ? 'Finish today’s lesson' : 'Go to today’s words',
              ),
            ),
          ),
          const SizedBox(height: 24),
          const _QuizNotes(),
        ] else if (quiz == null) ...[
          EmptyMoment(
            icon: Icons.auto_awesome_outlined,
            title: 'Let’s see what’s growing.',
            description: 'A question for every word you learned this week. Take your time; there’s no timer.',
            action: AsyncButton(
              label: 'Start weekly test',
              icon: Icons.arrow_forward_rounded,
              onPressed: () => ref.read(appProvider.notifier).startQuiz(),
            ),
          ),
          const SizedBox(height: 24),
          const _QuizNotes(),
        ] else
          _Question(session: quiz),
        if (sunday && !finished) ...[
          const SizedBox(height: 24),
          Text(
            'Available until the end of today. Your place is saved as you go.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: context.colors.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }
}

class _QuizNotes extends StatelessWidget {
  const _QuizNotes();
  @override
  Widget build(BuildContext context) => Panel(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Eyebrow('How it works'),
        SizedBox(height: 16),
        Text(
          'German ↔ English',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: context.colors.onSurface,
          ),
        ),
        SizedBox(height: 6),
        Text('Two directions. Four choices. One word at a time.'),
        SizedBox(height: 18),
        Text(
          'Learning over perfection',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: context.colors.onSurface,
          ),
        ),
        SizedBox(height: 6),
        Text(
          'See the answer after every question. Your score never changes your streak.',
        ),
      ],
    ),
  );
}

class _Question extends ConsumerWidget {
  final WeeklyTestSession session;
  const _Question({required this.session});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final q = session.current;
    final selected = session.selected;
    final correct = selected == q.correctIndex;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Eyebrow(
                'Question ${session.cursor + 1} of ${session.questions.length}',
              ),
            ),
            Icon(Icons.spa_outlined, color: context.colors.primary, size: 21),
          ],
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: session.cursor / session.questions.length,
            minHeight: 5,
            backgroundColor: context.colors.outlineVariant,
            color: context.colors.primary,
            semanticsLabel: 'Weekly test progress',
          ),
        ),
        const SizedBox(height: 24),
        Panel(
          color: context.colors.surfaceContainerHigh,
          child: Column(
            children: [
              Eyebrow(
                q.germanToEnglish
                    ? 'What does this mean in English?'
                    : 'How do you say this in German?',
              ),
              const SizedBox(height: 24),
              Text(
                q.prompt,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
        const SizedBox(height: 20),
        for (var i = 0; i < q.choices.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _Choice(
              label: q.choices[i],
              index: i,
              selected: selected == i,
              isCorrect: i == q.correctIndex,
              revealed: selected != null,
              onTap: selected == null
                  ? () async {
                      try {
                        await ref
                            .read(appProvider.notifier)
                            .answer(session.cursor, i);
                      } catch (_) {
                        if (context.mounted) {
                          showMessage(
                            context,
                            'Couldn’t save your answer. Try again.',
                          );
                        }
                      }
                    }
                  : null,
            ),
          ),
        if (selected != null) ...[
          const SizedBox(height: 12),
          Semantics(
            liveRegion: true,
            child: Panel(
              color: correct
                  ? context.colors.surfaceContainerHigh
                  : context.colors.tertiaryContainer,
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    correct
                        ? 'That’s right. Schön gemacht!'
                        : 'A little more practice, a little more progress.',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: context.colors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Correct answer: ${q.choices[q.correctIndex]}',
                    style: TextStyle(color: context.colors.onSurface),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          AsyncButton(
            label: session.cursor == session.questions.length - 1
                ? 'See my results'
                : 'Next question',
            icon: Icons.arrow_forward_rounded,
            onPressed: () =>
                ref.read(appProvider.notifier).advance(session.cursor),
          ),
        ],
      ],
    );
  }
}

class _Choice extends StatelessWidget {
  final String label;
  final int index;
  final bool selected;
  final bool isCorrect;
  final bool revealed;
  final VoidCallback? onTap;
  const _Choice({
    required this.label,
    required this.index,
    required this.selected,
    required this.isCorrect,
    required this.revealed,
    this.onTap,
  });
  @override
  Widget build(BuildContext context) => Semantics(
    selected: selected,
    button: true,
    label:
        '$label${revealed && isCorrect
            ? ', correct answer'
            : selected
            ? ', your answer'
            : ''}',
    child: Material(
      color: revealed && isCorrect
          ? context.colors.surfaceContainerHigh
          : selected
          ? context.colors.tertiaryContainer
          : context.colors.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: revealed && isCorrect
              ? context.colors.primary
              : selected
              ? context.colors.tertiary
              : context.colors.outlineVariant,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: ExcludeSemantics(
            child: Row(
              children: [
                Text(
                  String.fromCharCode(65 + index),
                  style: TextStyle(
                    fontSize: 12,
                    color: context.colors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 16,
                      color: context.colors.onSurface,
                    ),
                  ),
                ),
                if (revealed && isCorrect)
                  Icon(
                    Icons.check_circle_outline,
                    color: context.colors.primary,
                    size: 22,
                  )
                else if (selected)
                  Icon(
                    Icons.close_rounded,
                    color: context.colors.tertiary,
                    size: 22,
                  ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

class _Score extends StatelessWidget {
  final WeeklyTestSession session;
  const _Score({required this.session});
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Panel(
        color: context.colors.surfaceContainerHigh,
        child: Column(
          children: [
            Icon(
              Icons.workspace_premium_outlined,
              size: 48,
              color: context.colors.primary,
            ),
            const SizedBox(height: 18),
            const Eyebrow('Week complete'),
            const SizedBox(height: 18),
            Text(
              '${session.score} / ${session.questions.length}',
              style: Theme.of(context).textTheme.displaySmall
                  ?.copyWith(fontSize: 52),
            ),
            const SizedBox(height: 14),
            Text(
              'Look at all you’ve learned.',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 10),
            const Text(
              'Every word is a step forward. Your results are saved in Progress.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
      const SizedBox(height: 28),
      Eyebrow(
        'Week of ${DateFormat('d MMM').format(DateTime(session.week.year, session.week.month, session.week.day))}',
      ),
      const SizedBox(height: 14),
      for (var i = 0; i < session.questions.length; i++)
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Panel(
            padding: const EdgeInsets.all(18),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  session.answers[i] == session.questions[i].correctIndex
                      ? Icons.check_circle_outline
                      : Icons.refresh_rounded,
                  color: session.answers[i] == session.questions[i].correctIndex
                      ? context.colors.primary
                      : context.colors.tertiary,
                  size: 20,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        session.questions[i].prompt,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: context.colors.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        session.questions[i].choices[session
                            .questions[i]
                            .correctIndex],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
    ],
  );
}
