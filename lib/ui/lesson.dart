import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../app_controller.dart';
import '../domain/models.dart';
import '../theme.dart';
import 'common.dart';

class LessonScreen extends ConsumerStatefulWidget {
  final LocalDate date;
  final bool review;
  const LessonScreen({super.key, required this.date, this.review = false});

  @override
  ConsumerState<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends ConsumerState<LessonScreen> {
  late final PageController pages;
  int page = 0;

  @override
  void initState() {
    super.initState();
    final a = ref.read(appProvider).asData?.value.assignment;
    if (!widget.review && a != null && a.date == widget.date) {
      final next = a.wordIds.indexWhere((id) => !a.completedIds.contains(id));
      if (next >= 0) page = next;
    }
    pages = PageController(initialPage: page);
  }

  @override
  void dispose() {
    pages.dispose();
    super.dispose();
  }

  Future<void> _goTo(int index) async {
    if (!pages.hasClients) return;
    if (MediaQuery.disableAnimationsOf(context)) {
      pages.jumpToPage(index);
    } else {
      await pages.animateToPage(
        index,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
      );
    }
  }

  int _nextUnlearned(DayAssignment a) {
    for (var offset = 1; offset <= a.wordIds.length; offset++) {
      final index = (page + offset) % a.wordIds.length;
      if (!a.completedIds.contains(a.wordIds[index])) return index;
    }
    return page;
  }

  Future<void> _complete(String id) async {
    final accepted = await ref
        .read(appProvider.notifier)
        .complete(id, widget.date);
    if (!mounted || ModalRoute.of(context)?.isCurrent != true) return;
    final a = ref.read(appProvider).asData?.value.assignment;
    if (!accepted || a == null || a.date != widget.date) {
      Navigator.of(context).pop();
      showMessage(context, 'A new day has begun. Here are today’s words.');
      return;
    }
    if (a.isComplete) {
      Navigator.of(context).pop();
    } else {
      await _goTo(_nextUnlearned(a));
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(appProvider).asData?.value;
    final a = data?.assignment;
    final valid = a != null && a.date == widget.date && a.wordIds.isNotEmpty;
    final word = valid
        ? ref.read(servicesProvider).vocabulary.byId[a.wordIds[page]]
        : null;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Close lesson',
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close_rounded),
        ),
        title: Text(widget.review ? 'Today’s words' : 'Your daily lesson'),
      ),
      body: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: data == null
                ? const Center(child: CircularProgressIndicator())
                : !valid
                ? Padding(
                    padding: const EdgeInsets.all(24),
                    child: EmptyMoment(
                      icon: Icons.wb_sunny_outlined,
                      title: 'A new day, a fresh lesson.',
                      description: 'Your progress is saved. Head back to Today for your next words.',
                      action: FilledButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Back to Today'),
                      ),
                    ),
                  )
                : Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Wrap(
                              alignment: WrapAlignment.spaceBetween,
                              spacing: 12,
                              runSpacing: 6,
                              children: [
                                Eyebrow(
                                  'Word ${page + 1} of ${a.wordIds.length}',
                                ),
                                Text(
                                  '${a.completed} learned',
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: LinearProgressIndicator(
                                value: a.completed / a.wordIds.length,
                                minHeight: 4,
                                color: context.colors.primary,
                                backgroundColor: context.colors.outlineVariant,
                                semanticsLabel: 'Today’s learning progress',
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: PageView.builder(
                          controller: pages,
                          allowImplicitScrolling: true,
                          itemCount: a.wordIds.length,
                          onPageChanged: (value) =>
                              setState(() => page = value),
                          itemBuilder: (context, index) {
                            final word = ref
                                .read(servicesProvider)
                                .vocabulary
                                .byId[a.wordIds[index]];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: word == null
                                  ? const Panel(
                                      child: Text(
                                        'We couldn’t open this word. Your progress is safe.',
                                      ),
                                    )
                                  : WordCard(
                                      key: ValueKey(word.id),
                                      word: word,
                                      learned: a.completedIds.contains(word.id),
                                    ),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (a.wordIds.length > 1)
                              Row(
                                children: [
                                  IconButton(
                                    tooltip: 'Previous word',
                                    onPressed: page > 0
                                        ? () => _goTo(page - 1)
                                        : null,
                                    icon: const Icon(Icons.arrow_back_rounded),
                                  ),
                                  Expanded(
                                    child: Text(
                                      'Swipe between words',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: context.colors.onSurfaceVariant,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    tooltip: 'Next word',
                                    onPressed: page < a.wordIds.length - 1
                                        ? () => _goTo(page + 1)
                                        : null,
                                    icon: const Icon(
                                      Icons.arrow_forward_rounded,
                                    ),
                                  ),
                                ],
                              ),
                            const SizedBox(height: 8),
                            SizedBox(
                              width: double.infinity,
                              child:
                                  word == null ||
                                      a.completedIds.contains(word.id)
                                  ? OutlinedButton.icon(
                                      onPressed: a.isComplete || word == null
                                          ? () => Navigator.of(context).pop()
                                          : () => _goTo(_nextUnlearned(a)),
                                      icon: const Icon(
                                        Icons.check_circle_outline,
                                        size: 20,
                                      ),
                                      label: Text(
                                        a.isComplete || word == null
                                            ? 'Back to Today'
                                            : 'Next unlearned word',
                                      ),
                                    )
                                  : AsyncButton(
                                      onPressed: () => _complete(word.id),
                                      label: 'I’ve learned this word',
                                      icon: Icons.check_rounded,
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class WordCard extends StatefulWidget {
  final Word word;
  final bool learned;
  const WordCard({super.key, required this.word, required this.learned});

  @override
  State<WordCard> createState() => _WordCardState();
}

class _WordCardState extends State<WordCard> {
  final scroll = ScrollController();
  @override
  void dispose() {
    scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final word = widget.word;
    return Panel(
      padding: EdgeInsets.zero,
      child: Scrollbar(
        controller: scroll,
        child: SingleChildScrollView(
          key: ValueKey('word-content-${word.id}'),
          controller: scroll,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: context.colors.surfaceContainerHigh,
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: Eyebrow(
                          word.type,
                          color: context.colors.primary,
                        ),
                      ),
                    ),
                  ),
                  if (widget.learned)
                    Icon(
                      Icons.check_circle_outline,
                      color: context.colors.primary,
                      semanticLabel: 'Word learned',
                    ),
                ],
              ),
              const SizedBox(height: 24),
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
                style: TextStyle(
                  fontSize: 20,
                  color: context.colors.onSurfaceVariant,
                ),
              ),
              if (word.plural != null) ...[
                const SizedBox(height: 10),
                Text(
                  'Plural: ${word.plural}',
                  style: TextStyle(
                    fontSize: 12,
                    color: context.colors.onSurfaceVariant,
                  ),
                ),
              ],
              const SizedBox(height: 24),
              const Divider(height: 1),
              const SizedBox(height: 24),
              const Eyebrow('In everyday life'),
              const SizedBox(height: 16),
              for (var i = 0; i < word.examples.length; i++)
                Padding(
                  padding: EdgeInsets.only(
                    bottom: i == word.examples.length - 1 ? 0 : 20,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          '${i + 1}.',
                          style: TextStyle(
                            fontSize: 11,
                            color: context.colors.onSurfaceVariant,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              word.examples[i].german,
                              style: TextStyle(
                                fontSize: 16,
                                height: 1.5,
                                color: context.colors.onSurface,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              word.examples[i].english,
                              style: TextStyle(
                                fontSize: 13,
                                height: 1.5,
                                color: context.colors.onSurfaceVariant,
                              ),
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
      ),
    );
  }
}
