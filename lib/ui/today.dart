import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../app_controller.dart';
import '../domain/models.dart';
import '../theme.dart';
import 'common.dart';

class TodayScreen extends ConsumerStatefulWidget {
  final AppSnapshot data;
  final VoidCallback onTest;
  const TodayScreen({super.key, required this.data, required this.onTest});
  @override
  ConsumerState<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends ConsumerState<TodayScreen> {
  late PageController pages;
  int page = 0;
  bool reviewing = false;
  @override
  void initState() {
    super.initState();
    final a = widget.data.assignment!;
    final next = a.wordIds.indexWhere((id) => !a.completedIds.contains(id));
    page = max(0, next);
    pages = PageController(initialPage: page);
  }

  @override
  void dispose() {
    pages.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final a = widget.data.assignment!;
    final now = ref.read(servicesProvider).clock.now();
    final greeting = now.hour < 12
        ? 'Guten Morgen.'
        : now.hour < 18
        ? 'Guten Tag.'
        : 'Guten Abend.';
    final vocab = ref.read(servicesProvider).vocabulary;
    final scale = MediaQuery.textScalerOf(context).scale(16) / 16;
    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      children: [
        Eyebrow(DateFormat('EEEE, d MMMM', 'en_US').format(now)),
        const SizedBox(height: 10),
        Text(greeting, style: Theme.of(context).textTheme.displaySmall),
        const SizedBox(height: 8),
        Text(
          a.isComplete
              ? 'A little more German, a little more you.'
              : 'A fresh day. A few new possibilities.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: muted),
        ),
        const SizedBox(height: 24),
        Panel(
          color: sage,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              const Icon(
                Icons.local_fire_department_outlined,
                color: amber,
                size: 30,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${widget.data.streak.current} day${widget.data.streak.current == 1 ? '' : 's'} in a row',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: ink,
                      ),
                    ),
                    Text(
                      a.isComplete
                          ? 'You showed up for yourself today.'
                          : 'Small steps make lasting habits.',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.spa_outlined, color: forest, size: 25),
            ],
          ),
        ),
        const SizedBox(height: 28),
        if (widget.data.curriculumComplete && !reviewing)
          EmptyMoment(
            icon: Icons.park_outlined,
            title: 'Look how far you’ve grown.',
            description:
                'You’ve learned all ${vocab.words.length} words in this collection. Your final streak is yours to keep.',
            action: widget.data.quizAvailable
                ? FilledButton(
                    onPressed: widget.onTest,
                    child: const Text('Take your weekly test'),
                  )
                : a.wordIds.isNotEmpty
                ? OutlinedButton(
                    onPressed: () => setState(() => reviewing = true),
                    child: const Text('Revisit today’s words'),
                  )
                : null,
          )
        else if (a.isComplete && !reviewing) ...[
          EmptyMoment(
            icon: Icons.check_rounded,
            title: 'Today, beautifully done.',
            description:
                '${a.wordIds.length} new word${a.wordIds.length == 1 ? '' : 's'} to take into your world. Come back tomorrow for a fresh lesson.',
            action: now.weekday == DateTime.sunday
                ? FilledButton(
                    onPressed: widget.onTest,
                    child: const Text('Take your weekly test'),
                  )
                : null,
          ),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: () => setState(() => reviewing = true),
            child: const Text('Revisit today’s words'),
          ),
        ] else if (a.wordIds.isEmpty)
          const EmptyMoment(
            icon: Icons.eco_outlined,
            title: 'A moment to pause.',
            description: 'There are no new words to learn today.',
          )
        else ...[
          Row(
            children: [
              const Expanded(child: Eyebrow('Your daily words')),
              Text(
                '${a.completed} of ${a.wordIds.length} learned',
                style: const TextStyle(fontSize: 12, color: muted),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: a.completed / a.wordIds.length,
              minHeight: 5,
              backgroundColor: line,
              color: forest,
              semanticsLabel: 'Today’s learning progress',
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: max(
              584,
              590 * scale + (MediaQuery.sizeOf(context).width < 370 ? 90 : 0),
            ),
            child: PageView.builder(
              controller: pages,
              itemCount: a.wordIds.length,
              onPageChanged: (v) => setState(() => page = v),
              itemBuilder: (context, index) {
                final word = vocab.byId[a.wordIds[index]];
                if (word == null) {
                  return const Panel(
                    child: Text(
                      'This word is missing from the content update. Please restore the previous corpus.',
                    ),
                  );
                }
                final learned = a.completedIds.contains(word.id);
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: WordCard(
                    word: word,
                    index: index,
                    total: a.wordIds.length,
                    learned: learned,
                    onComplete: () async {
                      final accepted = await ref
                          .read(appProvider.notifier)
                          .complete(word.id, a.date);
                      if (!context.mounted) return;
                      if (!accepted) {
                        showMessage(
                          context,
                          'A new day has begun. Here are today’s words.',
                        );
                        return;
                      }
                      final next = a.wordIds.indexWhere(
                        (id) => id != word.id && !a.completedIds.contains(id),
                      );
                      if (next >= 0 && pages.hasClients) {
                        await pages.animateToPage(
                          next,
                          duration: const Duration(milliseconds: 280),
                          curve: Curves.easeOutCubic,
                        );
                      }
                    },
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                tooltip: 'Previous word',
                onPressed: page > 0
                    ? () => pages.previousPage(
                        duration: const Duration(milliseconds: 220),
                        curve: Curves.easeOut,
                      )
                    : null,
                icon: const Icon(Icons.arrow_back_rounded, size: 20),
              ),
              for (var i = 0; i < a.wordIds.length; i++)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Semantics(
                    label: 'Word ${i + 1}${page == i ? ', current' : ''}',
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      width: page == i ? 22 : 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: page == i ? forest : line,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                ),
              IconButton(
                tooltip: 'Next word',
                onPressed: page < a.wordIds.length - 1
                    ? () => pages.nextPage(
                        duration: const Duration(milliseconds: 220),
                        curve: Curves.easeOut,
                      )
                    : null,
                icon: const Icon(Icons.arrow_forward_rounded, size: 20),
              ),
            ],
          ),
        ],
        const SizedBox(height: 24),
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cloud_off_outlined, size: 14, color: muted),
            SizedBox(width: 8),
            Flexible(
              child: Text(
                'A quiet space to grow. Fully offline.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11, color: muted),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class WordCard extends StatelessWidget {
  final Word word;
  final int index;
  final int total;
  final bool learned;
  final Future<void> Function() onComplete;
  const WordCard({
    super.key,
    required this.word,
    required this.index,
    required this.total,
    required this.learned,
    required this.onComplete,
  });
  @override
  Widget build(BuildContext context) => Panel(
    padding: EdgeInsets.zero,
    child: SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: sage,
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Eyebrow(word.type, color: forest),
              ),
              const Spacer(),
              Text(
                '${(index + 1).toString().padLeft(2, '0')} / ${total.toString().padLeft(2, '0')}',
                style: const TextStyle(
                  fontSize: 11,
                  color: muted,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 26),
          Semantics(
            label: 'German: ${word.display}',
            child: Text(
              word.display,
              style: Theme.of(context).textTheme.displaySmall
                  ?.copyWith(fontSize: 36),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            word.english.meaning,
            style: const TextStyle(fontSize: 20, color: muted),
          ),
          if (word.plural != null) ...[
            const SizedBox(height: 10),
            Text(
              'Plural: ${word.plural}',
              style: const TextStyle(fontSize: 12, color: muted),
            ),
          ],
          const SizedBox(height: 24),
          const Divider(height: 1),
          const SizedBox(height: 24),
          const Eyebrow('In everyday life'),
          const SizedBox(height: 16),
          for (var i = 0; i < word.examples.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      '${i + 1}.',
                      style: const TextStyle(fontSize: 11, color: muted),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          word.examples[i].german,
                          style: const TextStyle(
                            fontSize: 16,
                            height: 1.5,
                            color: ink,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          word.examples[i].english,
                          style: const TextStyle(
                            fontSize: 13,
                            color: muted,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: learned
                ? Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: sage,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          size: 20,
                          color: forest,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Word learned',
                          style: TextStyle(
                            color: forest,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  )
                : AsyncButton(
                    onPressed: onComplete,
                    label: 'I’ve learned this word',
                    icon: Icons.check_rounded,
                  ),
          ),
        ],
      ),
    ),
  );
}
