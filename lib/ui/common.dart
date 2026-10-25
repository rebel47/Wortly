import 'package:flutter/material.dart';

import '../theme.dart';

class Brand extends StatelessWidget {
  const Brand({super.key});
  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: forest,
          borderRadius: BorderRadius.circular(11),
        ),
        child: const Icon(Icons.eco_outlined, color: paper, size: 23),
      ),
      const SizedBox(width: 10),
      const Text(
        'wortly',
        textScaler: TextScaler.noScaling,
        style: TextStyle(
          fontFamily: 'Fraunces',
          fontSize: 27,
          fontWeight: FontWeight.w600,
          color: forest,
          letterSpacing: -1,
        ),
      ),
    ],
  );
}

class Eyebrow extends StatelessWidget {
  final String text;
  final Color color;
  const Eyebrow(this.text, {super.key, this.color = muted});
  @override
  Widget build(BuildContext context) => Text(
    text.toUpperCase(),
    style: TextStyle(
      color: color,
      fontSize: 11,
      letterSpacing: 1.8,
      fontWeight: FontWeight.w700,
    ),
  );
}

class Panel extends StatelessWidget {
  final Widget child;
  final Color color;
  final EdgeInsets padding;
  const Panel({
    super.key,
    required this.child,
    this.color = Colors.white,
    this.padding = const EdgeInsets.all(24),
  });
  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(24),
      border: Border.all(color: line),
    ),
    child: Material(
      type: MaterialType.transparency,
      borderRadius: BorderRadius.circular(24),
      child: Padding(padding: padding, child: child),
    ),
  );
}

class GoalPicker extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;
  const GoalPicker({super.key, required this.value, required this.onChanged});
  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      for (final goal in [1, 3, 5])
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: goal == 5 ? 0 : 10),
            child: Semantics(
              selected: value == goal,
              button: true,
              label: '$goal ${goal == 1 ? 'word' : 'words'} per day',
              child: InkWell(
                onTap: () => onChanged(goal),
                borderRadius: BorderRadius.circular(18),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 4,
                  ),
                  decoration: BoxDecoration(
                    color: value == goal ? forest : Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: value == goal ? forest : line),
                  ),
                  child: ExcludeSemantics(
                    child: Column(
                      children: [
                        Text(
                          '$goal',
                          style: TextStyle(
                            fontFamily: 'Fraunces',
                            fontSize: 30,
                            color: value == goal ? Colors.white : forest,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          goal == 1 ? 'word / day' : 'words / day',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 11,
                            color: value == goal ? Colors.white : muted,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Icon(
                          value == goal
                              ? Icons.check_circle
                              : Icons.circle_outlined,
                          size: 18,
                          color: value == goal ? const Color(0xFFCCDDB6) : line,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
    ],
  );
}

class AsyncButton extends StatefulWidget {
  final Future<void> Function() onPressed;
  final String label;
  final IconData? icon;
  const AsyncButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.icon,
  });
  @override
  State<AsyncButton> createState() => _AsyncButtonState();
}

class _AsyncButtonState extends State<AsyncButton> {
  bool busy = false;
  @override
  Widget build(BuildContext context) => FilledButton(
    onPressed: busy
        ? null
        : () async {
            setState(() => busy = true);
            try {
              await widget.onPressed();
            } catch (e) {
              if (context.mounted) {
                showMessage(
                  context,
                  'Couldn’t save that change. Please try again.',
                );
              }
            } finally {
              if (mounted) setState(() => busy = false);
            }
          },
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (busy)
          const SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        else if (widget.icon != null)
          Icon(widget.icon, size: 20),
        if (busy || widget.icon != null) const SizedBox(width: 10),
        Flexible(child: Text(widget.label, textAlign: TextAlign.center)),
      ],
    ),
  );
}

void showMessage(BuildContext context, String message) =>
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));

class EmptyMoment extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Widget? action;
  const EmptyMoment({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.action,
  });
  @override
  Widget build(BuildContext context) => Panel(
    color: sage,
    child: Column(
      children: [
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(22),
          decoration: const BoxDecoration(color: paper, shape: BoxShape.circle),
          child: Icon(icon, color: forest, size: 42),
        ),
        const SizedBox(height: 24),
        Text(
          title,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 12),
        Text(
          description,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        if (action != null) ...[const SizedBox(height: 24), action!],
        const SizedBox(height: 16),
      ],
    ),
  );
}
