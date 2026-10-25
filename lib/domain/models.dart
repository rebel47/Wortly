import 'dart:convert';

/// A civil date, not an instant. UTC component arithmetic avoids DST errors.
class LocalDate implements Comparable<LocalDate> {
  final int year;
  final int month;
  final int day;
  const LocalDate(this.year, this.month, this.day);
  factory LocalDate.from(DateTime date) =>
      LocalDate(date.year, date.month, date.day);
  factory LocalDate.parse(String value) {
    final result = LocalDate.from(DateTime.parse(value));
    if (result.key != value) throw FormatException('Invalid date key: $value');
    return result;
  }
  DateTime get _civil => DateTime.utc(year, month, day);
  String get key =>
      '${year.toString().padLeft(4, '0')}-'
      '${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';
  int get weekday => _civil.weekday;
  LocalDate plusDays(int days) =>
      LocalDate.from(DateTime.utc(year, month, day + days));
  LocalDate get monday => plusDays(1 - weekday);
  int daysUntil(LocalDate other) => other._civil.difference(_civil).inDays;
  @override
  int compareTo(LocalDate other) => key.compareTo(other.key);
  @override
  bool operator ==(Object other) => other is LocalDate && key == other.key;
  @override
  int get hashCode => key.hashCode;
  @override
  String toString() => key;
}

abstract interface class AppClock {
  DateTime now();
}

class SystemClock implements AppClock {
  const SystemClock();
  @override
  DateTime now() => DateTime.now();
}

class Translation {
  final String language;
  final String meaning;

  /// Equivalent senses share this key and never distract one another.
  final String answerKey;
  const Translation(this.language, this.meaning, this.answerKey);
  factory Translation.fromJson(Map<String, dynamic> j) => Translation(
    j['language'] as String,
    j['meaning'] as String,
    j['answerKey'] as String,
  );
}

class Example {
  final String german;
  final Map<String, String> translations;
  const Example(this.german, this.translations);
  factory Example.fromJson(Map<String, dynamic> j) => Example(
    j['german'] as String,
    Map<String, String>.from(j['translations'] as Map),
  );
  String get english => translations['en']!;
}

class Word {
  final String id;
  final String german;
  final String type;
  final String? article;
  final String? plural;
  final int rank;
  final String answerKey;
  final List<Translation> translations;
  final List<Example> examples;
  const Word({
    required this.id,
    required this.german,
    required this.type,
    this.article,
    this.plural,
    required this.rank,
    required this.answerKey,
    required this.translations,
    required this.examples,
  });
  factory Word.fromJson(Map<String, dynamic> j) => Word(
    id: j['id'] as String,
    german: j['german'] as String,
    type: j['type'] as String,
    article: j['article'] as String?,
    plural: j['plural'] as String?,
    rank: j['rank'] as int,
    answerKey: j['answerKey'] as String,
    translations: (j['translations'] as List)
        .map((e) => Translation.fromJson(e as Map<String, dynamic>))
        .toList(),
    examples: (j['examples'] as List)
        .map((e) => Example.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
  Translation get english => translations.firstWhere((t) => t.language == 'en');
  String get display => article == null ? german : '$article $german';
}

class UserPreferences {
  final int dailyGoal;
  final bool onboarded;
  final bool reminders;
  final int reminderHour;
  final int reminderMinute;
  const UserPreferences({
    this.dailyGoal = 3,
    this.onboarded = false,
    this.reminders = false,
    this.reminderHour = 9,
    this.reminderMinute = 0,
  });
}

class DayAssignment {
  final LocalDate date;
  final int goal;
  final List<String> wordIds;
  final Set<String> completedIds;
  const DayAssignment({
    required this.date,
    required this.goal,
    required this.wordIds,
    required this.completedIds,
  });
  int get completed => wordIds.where(completedIds.contains).length;
  bool get isComplete => wordIds.isNotEmpty && completed == wordIds.length;
}

class QuizQuestion {
  final String wordId;
  final bool germanToEnglish;
  final String prompt;
  final List<String> choices;
  final int correctIndex;
  const QuizQuestion({
    required this.wordId,
    required this.germanToEnglish,
    required this.prompt,
    required this.choices,
    required this.correctIndex,
  });
  factory QuizQuestion.fromJson(Map<String, dynamic> j) => QuizQuestion(
    wordId: j['wordId'] as String,
    germanToEnglish: j['germanToEnglish'] as bool,
    prompt: j['prompt'] as String,
    choices: List<String>.from(j['choices'] as List),
    correctIndex: j['correctIndex'] as int,
  );
  Map<String, dynamic> toJson() => {
    'wordId': wordId,
    'germanToEnglish': germanToEnglish,
    'prompt': prompt,
    'choices': choices,
    'correctIndex': correctIndex,
  };
}

class WeeklyTestSession {
  final LocalDate week;
  final List<QuizQuestion> questions;
  final Map<int, int> answers;
  final int cursor;
  final bool expired;
  final int? score;
  const WeeklyTestSession({
    required this.week,
    required this.questions,
    required this.answers,
    required this.cursor,
    required this.expired,
    required this.score,
  });
  bool get finished => score != null;
  QuizQuestion get current => questions[cursor];
  int? get selected => answers[cursor];
  static Map<int, int> decodeAnswers(String json) =>
      (jsonDecode(json) as Map<String, dynamic>).map(
        (k, v) => MapEntry(int.parse(k), v as int),
      );
}

class Streak {
  final int current;
  final int longest;
  const Streak(this.current, this.longest);
}
