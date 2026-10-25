import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'app_controller.dart';
import 'data/database.dart';
import 'data/open_database.dart';
import 'data/vocabulary_repository.dart';
import 'domain/models.dart';
import 'services/reminders.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final vocabulary = await VocabularyRepository.load();
  final services = AppServices(
    database: AppDatabase(openWortlyDatabase()),
    vocabulary: vocabulary,
    clock: const SystemClock(),
    reminders: LocalReminderService(),
  );
  runApp(
    ProviderScope(
      overrides: [servicesProvider.overrideWithValue(services)],
      child: const WortlyApp(),
    ),
  );
}
