import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../app_controller.dart';
import '../theme.dart';
import 'common.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});
  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  int goal = 3;
  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 540),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(28, 24, 28, 32),
            children: [
              const Brand(),
              const SizedBox(height: 36),
              const _WelcomeArt(),
              const SizedBox(height: 32),
              const Eyebrow('A little, every day'),
              const SizedBox(height: 12),
              Text(
                'Small words.\nA world of possibility.',
                style: Theme.of(context).textTheme.displaySmall,
              ),
              const SizedBox(height: 16),
              Text(
                'Make German part of your day. A few useful words, a quiet moment, and a habit that grows with you.',
                style: TextStyle(
                  fontSize: 16,
                  height: 1.6,
                  color: context.colors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 28),
              const Text(
                'Your daily rhythm',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
              ),
              const SizedBox(height: 12),
              GoalPicker(
                value: goal,
                onChanged: (v) => setState(() => goal = v),
              ),
              const SizedBox(height: 20),
              Panel(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(
                      Icons.translate_rounded,
                      color: context.colors.primary,
                    ),
                    SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Learning German',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: context.colors.onSurface,
                            ),
                          ),
                          Text('With English translations'),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.check_circle,
                      size: 20,
                      color: context.colors.primary,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              AsyncButton(
                label: 'Let’s begin',
                icon: Icons.arrow_forward_rounded,
                onPressed: () => ref.read(appProvider.notifier).onboard(goal),
              ),
              const SizedBox(height: 16),
              Text(
                'Your pace. Your progress. Always offline.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: context.colors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class _WelcomeArt extends StatelessWidget {
  const _WelcomeArt();
  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: Container(
      height: 188,
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            right: 26,
            top: 25,
            child: Transform.rotate(
              angle: 0.3,
              child: Icon(
                Icons.eco_outlined,
                size: 90,
                color: context.colors.primary.withValues(alpha: 0.15),
              ),
            ),
          ),
          Transform.rotate(
            angle: -0.09,
            child: Container(
              width: 210,
              height: 130,
              decoration: BoxDecoration(
                color: context.colors.primaryContainer,
                borderRadius: BorderRadius.circular(18),
              ),
            ),
          ),
          Transform.rotate(
            angle: 0.05,
            child: Container(
              width: 210,
              height: 130,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: context.colors.primary,
                borderRadius: BorderRadius.circular(18),
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'der Anfang',
                      style: TextStyle(
                        fontFamily: 'Fraunces',
                        fontSize: 27,
                        color: context.colors.onPrimary,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'the beginning',
                      style: TextStyle(color: context.colors.onPrimary),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 22,
            bottom: 18,
            child: Icon(
              Icons.auto_awesome,
              size: 22,
              color: context.colors.primary,
            ),
          ),
        ],
      ),
    ),
  );
}
