import 'dart:convert';

import 'package:flutter/services.dart';

import '../domain/models.dart';

class VocabularyRepository {
  final String version;
  final List<Word> words;
  late final Map<String, Word> byId = {for (final w in words) w.id: w};
  VocabularyRepository(this.version, List<Word> records)
    : words = List.unmodifiable(
        [...records]..sort((a, b) => a.rank.compareTo(b.rank)),
      );
  static Future<VocabularyRepository> load() async {
    final json = jsonDecode(
      await rootBundle.loadString('assets/content/vocabulary.json'),
    ) as Map<String, dynamic>;
    return VocabularyRepository(
      json['version'] as String,
      (json['words'] as List)
          .map((w) => Word.fromJson(w as Map<String, dynamic>))
          .toList(),
    );
  }
}
