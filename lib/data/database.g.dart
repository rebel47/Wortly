// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $PreferenceRowsTable extends PreferenceRows
    with TableInfo<$PreferenceRowsTable, PreferenceRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PreferenceRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _dailyGoalMeta = const VerificationMeta(
    'dailyGoal',
  );
  @override
  late final GeneratedColumn<int> dailyGoal = GeneratedColumn<int>(
    'daily_goal',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(3),
  );
  static const VerificationMeta _onboardedMeta = const VerificationMeta(
    'onboarded',
  );
  @override
  late final GeneratedColumn<bool> onboarded = GeneratedColumn<bool>(
    'onboarded',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("onboarded" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _remindersMeta = const VerificationMeta(
    'reminders',
  );
  @override
  late final GeneratedColumn<bool> reminders = GeneratedColumn<bool>(
    'reminders',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("reminders" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _reminderHourMeta = const VerificationMeta(
    'reminderHour',
  );
  @override
  late final GeneratedColumn<int> reminderHour = GeneratedColumn<int>(
    'reminder_hour',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(9),
  );
  static const VerificationMeta _reminderMinuteMeta = const VerificationMeta(
    'reminderMinute',
  );
  @override
  late final GeneratedColumn<int> reminderMinute = GeneratedColumn<int>(
    'reminder_minute',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _themeModeMeta = const VerificationMeta(
    'themeMode',
  );
  @override
  late final GeneratedColumn<String> themeMode = GeneratedColumn<String>(
    'theme_mode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('system'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    dailyGoal,
    onboarded,
    reminders,
    reminderHour,
    reminderMinute,
    themeMode,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'preference_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<PreferenceRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('daily_goal')) {
      context.handle(
        _dailyGoalMeta,
        dailyGoal.isAcceptableOrUnknown(data['daily_goal']!, _dailyGoalMeta),
      );
    }
    if (data.containsKey('onboarded')) {
      context.handle(
        _onboardedMeta,
        onboarded.isAcceptableOrUnknown(data['onboarded']!, _onboardedMeta),
      );
    }
    if (data.containsKey('reminders')) {
      context.handle(
        _remindersMeta,
        reminders.isAcceptableOrUnknown(data['reminders']!, _remindersMeta),
      );
    }
    if (data.containsKey('reminder_hour')) {
      context.handle(
        _reminderHourMeta,
        reminderHour.isAcceptableOrUnknown(
          data['reminder_hour']!,
          _reminderHourMeta,
        ),
      );
    }
    if (data.containsKey('reminder_minute')) {
      context.handle(
        _reminderMinuteMeta,
        reminderMinute.isAcceptableOrUnknown(
          data['reminder_minute']!,
          _reminderMinuteMeta,
        ),
      );
    }
    if (data.containsKey('theme_mode')) {
      context.handle(
        _themeModeMeta,
        themeMode.isAcceptableOrUnknown(data['theme_mode']!, _themeModeMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PreferenceRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PreferenceRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      dailyGoal: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}daily_goal'],
      )!,
      onboarded: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}onboarded'],
      )!,
      reminders: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}reminders'],
      )!,
      reminderHour: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reminder_hour'],
      )!,
      reminderMinute: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reminder_minute'],
      )!,
      themeMode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}theme_mode'],
      )!,
    );
  }

  @override
  $PreferenceRowsTable createAlias(String alias) {
    return $PreferenceRowsTable(attachedDatabase, alias);
  }
}

class PreferenceRow extends DataClass implements Insertable<PreferenceRow> {
  final int id;
  final int dailyGoal;
  final bool onboarded;
  final bool reminders;
  final int reminderHour;
  final int reminderMinute;
  final String themeMode;
  const PreferenceRow({
    required this.id,
    required this.dailyGoal,
    required this.onboarded,
    required this.reminders,
    required this.reminderHour,
    required this.reminderMinute,
    required this.themeMode,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['daily_goal'] = Variable<int>(dailyGoal);
    map['onboarded'] = Variable<bool>(onboarded);
    map['reminders'] = Variable<bool>(reminders);
    map['reminder_hour'] = Variable<int>(reminderHour);
    map['reminder_minute'] = Variable<int>(reminderMinute);
    map['theme_mode'] = Variable<String>(themeMode);
    return map;
  }

  PreferenceRowsCompanion toCompanion(bool nullToAbsent) {
    return PreferenceRowsCompanion(
      id: Value(id),
      dailyGoal: Value(dailyGoal),
      onboarded: Value(onboarded),
      reminders: Value(reminders),
      reminderHour: Value(reminderHour),
      reminderMinute: Value(reminderMinute),
      themeMode: Value(themeMode),
    );
  }

  factory PreferenceRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PreferenceRow(
      id: serializer.fromJson<int>(json['id']),
      dailyGoal: serializer.fromJson<int>(json['dailyGoal']),
      onboarded: serializer.fromJson<bool>(json['onboarded']),
      reminders: serializer.fromJson<bool>(json['reminders']),
      reminderHour: serializer.fromJson<int>(json['reminderHour']),
      reminderMinute: serializer.fromJson<int>(json['reminderMinute']),
      themeMode: serializer.fromJson<String>(json['themeMode']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'dailyGoal': serializer.toJson<int>(dailyGoal),
      'onboarded': serializer.toJson<bool>(onboarded),
      'reminders': serializer.toJson<bool>(reminders),
      'reminderHour': serializer.toJson<int>(reminderHour),
      'reminderMinute': serializer.toJson<int>(reminderMinute),
      'themeMode': serializer.toJson<String>(themeMode),
    };
  }

  PreferenceRow copyWith({
    int? id,
    int? dailyGoal,
    bool? onboarded,
    bool? reminders,
    int? reminderHour,
    int? reminderMinute,
    String? themeMode,
  }) => PreferenceRow(
    id: id ?? this.id,
    dailyGoal: dailyGoal ?? this.dailyGoal,
    onboarded: onboarded ?? this.onboarded,
    reminders: reminders ?? this.reminders,
    reminderHour: reminderHour ?? this.reminderHour,
    reminderMinute: reminderMinute ?? this.reminderMinute,
    themeMode: themeMode ?? this.themeMode,
  );
  PreferenceRow copyWithCompanion(PreferenceRowsCompanion data) {
    return PreferenceRow(
      id: data.id.present ? data.id.value : this.id,
      dailyGoal: data.dailyGoal.present ? data.dailyGoal.value : this.dailyGoal,
      onboarded: data.onboarded.present ? data.onboarded.value : this.onboarded,
      reminders: data.reminders.present ? data.reminders.value : this.reminders,
      reminderHour: data.reminderHour.present
          ? data.reminderHour.value
          : this.reminderHour,
      reminderMinute: data.reminderMinute.present
          ? data.reminderMinute.value
          : this.reminderMinute,
      themeMode: data.themeMode.present ? data.themeMode.value : this.themeMode,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PreferenceRow(')
          ..write('id: $id, ')
          ..write('dailyGoal: $dailyGoal, ')
          ..write('onboarded: $onboarded, ')
          ..write('reminders: $reminders, ')
          ..write('reminderHour: $reminderHour, ')
          ..write('reminderMinute: $reminderMinute, ')
          ..write('themeMode: $themeMode')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    dailyGoal,
    onboarded,
    reminders,
    reminderHour,
    reminderMinute,
    themeMode,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PreferenceRow &&
          other.id == this.id &&
          other.dailyGoal == this.dailyGoal &&
          other.onboarded == this.onboarded &&
          other.reminders == this.reminders &&
          other.reminderHour == this.reminderHour &&
          other.reminderMinute == this.reminderMinute &&
          other.themeMode == this.themeMode);
}

class PreferenceRowsCompanion extends UpdateCompanion<PreferenceRow> {
  final Value<int> id;
  final Value<int> dailyGoal;
  final Value<bool> onboarded;
  final Value<bool> reminders;
  final Value<int> reminderHour;
  final Value<int> reminderMinute;
  final Value<String> themeMode;
  const PreferenceRowsCompanion({
    this.id = const Value.absent(),
    this.dailyGoal = const Value.absent(),
    this.onboarded = const Value.absent(),
    this.reminders = const Value.absent(),
    this.reminderHour = const Value.absent(),
    this.reminderMinute = const Value.absent(),
    this.themeMode = const Value.absent(),
  });
  PreferenceRowsCompanion.insert({
    this.id = const Value.absent(),
    this.dailyGoal = const Value.absent(),
    this.onboarded = const Value.absent(),
    this.reminders = const Value.absent(),
    this.reminderHour = const Value.absent(),
    this.reminderMinute = const Value.absent(),
    this.themeMode = const Value.absent(),
  });
  static Insertable<PreferenceRow> custom({
    Expression<int>? id,
    Expression<int>? dailyGoal,
    Expression<bool>? onboarded,
    Expression<bool>? reminders,
    Expression<int>? reminderHour,
    Expression<int>? reminderMinute,
    Expression<String>? themeMode,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (dailyGoal != null) 'daily_goal': dailyGoal,
      if (onboarded != null) 'onboarded': onboarded,
      if (reminders != null) 'reminders': reminders,
      if (reminderHour != null) 'reminder_hour': reminderHour,
      if (reminderMinute != null) 'reminder_minute': reminderMinute,
      if (themeMode != null) 'theme_mode': themeMode,
    });
  }

  PreferenceRowsCompanion copyWith({
    Value<int>? id,
    Value<int>? dailyGoal,
    Value<bool>? onboarded,
    Value<bool>? reminders,
    Value<int>? reminderHour,
    Value<int>? reminderMinute,
    Value<String>? themeMode,
  }) {
    return PreferenceRowsCompanion(
      id: id ?? this.id,
      dailyGoal: dailyGoal ?? this.dailyGoal,
      onboarded: onboarded ?? this.onboarded,
      reminders: reminders ?? this.reminders,
      reminderHour: reminderHour ?? this.reminderHour,
      reminderMinute: reminderMinute ?? this.reminderMinute,
      themeMode: themeMode ?? this.themeMode,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (dailyGoal.present) {
      map['daily_goal'] = Variable<int>(dailyGoal.value);
    }
    if (onboarded.present) {
      map['onboarded'] = Variable<bool>(onboarded.value);
    }
    if (reminders.present) {
      map['reminders'] = Variable<bool>(reminders.value);
    }
    if (reminderHour.present) {
      map['reminder_hour'] = Variable<int>(reminderHour.value);
    }
    if (reminderMinute.present) {
      map['reminder_minute'] = Variable<int>(reminderMinute.value);
    }
    if (themeMode.present) {
      map['theme_mode'] = Variable<String>(themeMode.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PreferenceRowsCompanion(')
          ..write('id: $id, ')
          ..write('dailyGoal: $dailyGoal, ')
          ..write('onboarded: $onboarded, ')
          ..write('reminders: $reminders, ')
          ..write('reminderHour: $reminderHour, ')
          ..write('reminderMinute: $reminderMinute, ')
          ..write('themeMode: $themeMode')
          ..write(')'))
        .toString();
  }
}

class $AssignmentRowsTable extends AssignmentRows
    with TableInfo<$AssignmentRowsTable, AssignmentRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AssignmentRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _dayMeta = const VerificationMeta('day');
  @override
  late final GeneratedColumn<String> day = GeneratedColumn<String>(
    'day',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _goalMeta = const VerificationMeta('goal');
  @override
  late final GeneratedColumn<int> goal = GeneratedColumn<int>(
    'goal',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _wordIdsMeta = const VerificationMeta(
    'wordIds',
  );
  @override
  late final GeneratedColumn<String> wordIds = GeneratedColumn<String>(
    'word_ids',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [day, goal, wordIds];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'assignment_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<AssignmentRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('day')) {
      context.handle(
        _dayMeta,
        day.isAcceptableOrUnknown(data['day']!, _dayMeta),
      );
    } else if (isInserting) {
      context.missing(_dayMeta);
    }
    if (data.containsKey('goal')) {
      context.handle(
        _goalMeta,
        goal.isAcceptableOrUnknown(data['goal']!, _goalMeta),
      );
    } else if (isInserting) {
      context.missing(_goalMeta);
    }
    if (data.containsKey('word_ids')) {
      context.handle(
        _wordIdsMeta,
        wordIds.isAcceptableOrUnknown(data['word_ids']!, _wordIdsMeta),
      );
    } else if (isInserting) {
      context.missing(_wordIdsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {day};
  @override
  AssignmentRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AssignmentRow(
      day: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}day'],
      )!,
      goal: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}goal'],
      )!,
      wordIds: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}word_ids'],
      )!,
    );
  }

  @override
  $AssignmentRowsTable createAlias(String alias) {
    return $AssignmentRowsTable(attachedDatabase, alias);
  }
}

class AssignmentRow extends DataClass implements Insertable<AssignmentRow> {
  final String day;
  final int goal;
  final String wordIds;
  const AssignmentRow({
    required this.day,
    required this.goal,
    required this.wordIds,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['day'] = Variable<String>(day);
    map['goal'] = Variable<int>(goal);
    map['word_ids'] = Variable<String>(wordIds);
    return map;
  }

  AssignmentRowsCompanion toCompanion(bool nullToAbsent) {
    return AssignmentRowsCompanion(
      day: Value(day),
      goal: Value(goal),
      wordIds: Value(wordIds),
    );
  }

  factory AssignmentRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AssignmentRow(
      day: serializer.fromJson<String>(json['day']),
      goal: serializer.fromJson<int>(json['goal']),
      wordIds: serializer.fromJson<String>(json['wordIds']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'day': serializer.toJson<String>(day),
      'goal': serializer.toJson<int>(goal),
      'wordIds': serializer.toJson<String>(wordIds),
    };
  }

  AssignmentRow copyWith({String? day, int? goal, String? wordIds}) =>
      AssignmentRow(
        day: day ?? this.day,
        goal: goal ?? this.goal,
        wordIds: wordIds ?? this.wordIds,
      );
  AssignmentRow copyWithCompanion(AssignmentRowsCompanion data) {
    return AssignmentRow(
      day: data.day.present ? data.day.value : this.day,
      goal: data.goal.present ? data.goal.value : this.goal,
      wordIds: data.wordIds.present ? data.wordIds.value : this.wordIds,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AssignmentRow(')
          ..write('day: $day, ')
          ..write('goal: $goal, ')
          ..write('wordIds: $wordIds')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(day, goal, wordIds);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AssignmentRow &&
          other.day == this.day &&
          other.goal == this.goal &&
          other.wordIds == this.wordIds);
}

class AssignmentRowsCompanion extends UpdateCompanion<AssignmentRow> {
  final Value<String> day;
  final Value<int> goal;
  final Value<String> wordIds;
  final Value<int> rowid;
  const AssignmentRowsCompanion({
    this.day = const Value.absent(),
    this.goal = const Value.absent(),
    this.wordIds = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AssignmentRowsCompanion.insert({
    required String day,
    required int goal,
    required String wordIds,
    this.rowid = const Value.absent(),
  }) : day = Value(day),
       goal = Value(goal),
       wordIds = Value(wordIds);
  static Insertable<AssignmentRow> custom({
    Expression<String>? day,
    Expression<int>? goal,
    Expression<String>? wordIds,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (day != null) 'day': day,
      if (goal != null) 'goal': goal,
      if (wordIds != null) 'word_ids': wordIds,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AssignmentRowsCompanion copyWith({
    Value<String>? day,
    Value<int>? goal,
    Value<String>? wordIds,
    Value<int>? rowid,
  }) {
    return AssignmentRowsCompanion(
      day: day ?? this.day,
      goal: goal ?? this.goal,
      wordIds: wordIds ?? this.wordIds,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (day.present) {
      map['day'] = Variable<String>(day.value);
    }
    if (goal.present) {
      map['goal'] = Variable<int>(goal.value);
    }
    if (wordIds.present) {
      map['word_ids'] = Variable<String>(wordIds.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AssignmentRowsCompanion(')
          ..write('day: $day, ')
          ..write('goal: $goal, ')
          ..write('wordIds: $wordIds, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LearnedRowsTable extends LearnedRows
    with TableInfo<$LearnedRowsTable, LearnedRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LearnedRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _wordIdMeta = const VerificationMeta('wordId');
  @override
  late final GeneratedColumn<String> wordId = GeneratedColumn<String>(
    'word_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dayMeta = const VerificationMeta('day');
  @override
  late final GeneratedColumn<String> day = GeneratedColumn<String>(
    'day',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [wordId, day];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'learned_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<LearnedRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('word_id')) {
      context.handle(
        _wordIdMeta,
        wordId.isAcceptableOrUnknown(data['word_id']!, _wordIdMeta),
      );
    } else if (isInserting) {
      context.missing(_wordIdMeta);
    }
    if (data.containsKey('day')) {
      context.handle(
        _dayMeta,
        day.isAcceptableOrUnknown(data['day']!, _dayMeta),
      );
    } else if (isInserting) {
      context.missing(_dayMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {wordId};
  @override
  LearnedRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LearnedRow(
      wordId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}word_id'],
      )!,
      day: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}day'],
      )!,
    );
  }

  @override
  $LearnedRowsTable createAlias(String alias) {
    return $LearnedRowsTable(attachedDatabase, alias);
  }
}

class LearnedRow extends DataClass implements Insertable<LearnedRow> {
  final String wordId;
  final String day;
  const LearnedRow({required this.wordId, required this.day});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['word_id'] = Variable<String>(wordId);
    map['day'] = Variable<String>(day);
    return map;
  }

  LearnedRowsCompanion toCompanion(bool nullToAbsent) {
    return LearnedRowsCompanion(wordId: Value(wordId), day: Value(day));
  }

  factory LearnedRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LearnedRow(
      wordId: serializer.fromJson<String>(json['wordId']),
      day: serializer.fromJson<String>(json['day']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'wordId': serializer.toJson<String>(wordId),
      'day': serializer.toJson<String>(day),
    };
  }

  LearnedRow copyWith({String? wordId, String? day}) =>
      LearnedRow(wordId: wordId ?? this.wordId, day: day ?? this.day);
  LearnedRow copyWithCompanion(LearnedRowsCompanion data) {
    return LearnedRow(
      wordId: data.wordId.present ? data.wordId.value : this.wordId,
      day: data.day.present ? data.day.value : this.day,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LearnedRow(')
          ..write('wordId: $wordId, ')
          ..write('day: $day')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(wordId, day);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LearnedRow &&
          other.wordId == this.wordId &&
          other.day == this.day);
}

class LearnedRowsCompanion extends UpdateCompanion<LearnedRow> {
  final Value<String> wordId;
  final Value<String> day;
  final Value<int> rowid;
  const LearnedRowsCompanion({
    this.wordId = const Value.absent(),
    this.day = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LearnedRowsCompanion.insert({
    required String wordId,
    required String day,
    this.rowid = const Value.absent(),
  }) : wordId = Value(wordId),
       day = Value(day);
  static Insertable<LearnedRow> custom({
    Expression<String>? wordId,
    Expression<String>? day,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (wordId != null) 'word_id': wordId,
      if (day != null) 'day': day,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LearnedRowsCompanion copyWith({
    Value<String>? wordId,
    Value<String>? day,
    Value<int>? rowid,
  }) {
    return LearnedRowsCompanion(
      wordId: wordId ?? this.wordId,
      day: day ?? this.day,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (wordId.present) {
      map['word_id'] = Variable<String>(wordId.value);
    }
    if (day.present) {
      map['day'] = Variable<String>(day.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LearnedRowsCompanion(')
          ..write('wordId: $wordId, ')
          ..write('day: $day, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ActivityRowsTable extends ActivityRows
    with TableInfo<$ActivityRowsTable, ActivityRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ActivityRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _dayMeta = const VerificationMeta('day');
  @override
  late final GeneratedColumn<String> day = GeneratedColumn<String>(
    'day',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [day];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'activity_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<ActivityRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('day')) {
      context.handle(
        _dayMeta,
        day.isAcceptableOrUnknown(data['day']!, _dayMeta),
      );
    } else if (isInserting) {
      context.missing(_dayMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {day};
  @override
  ActivityRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ActivityRow(
      day: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}day'],
      )!,
    );
  }

  @override
  $ActivityRowsTable createAlias(String alias) {
    return $ActivityRowsTable(attachedDatabase, alias);
  }
}

class ActivityRow extends DataClass implements Insertable<ActivityRow> {
  final String day;
  const ActivityRow({required this.day});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['day'] = Variable<String>(day);
    return map;
  }

  ActivityRowsCompanion toCompanion(bool nullToAbsent) {
    return ActivityRowsCompanion(day: Value(day));
  }

  factory ActivityRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ActivityRow(day: serializer.fromJson<String>(json['day']));
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{'day': serializer.toJson<String>(day)};
  }

  ActivityRow copyWith({String? day}) => ActivityRow(day: day ?? this.day);
  ActivityRow copyWithCompanion(ActivityRowsCompanion data) {
    return ActivityRow(day: data.day.present ? data.day.value : this.day);
  }

  @override
  String toString() {
    return (StringBuffer('ActivityRow(')
          ..write('day: $day')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => day.hashCode;
  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is ActivityRow && other.day == this.day);
}

class ActivityRowsCompanion extends UpdateCompanion<ActivityRow> {
  final Value<String> day;
  final Value<int> rowid;
  const ActivityRowsCompanion({
    this.day = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ActivityRowsCompanion.insert({
    required String day,
    this.rowid = const Value.absent(),
  }) : day = Value(day);
  static Insertable<ActivityRow> custom({
    Expression<String>? day,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (day != null) 'day': day,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ActivityRowsCompanion copyWith({Value<String>? day, Value<int>? rowid}) {
    return ActivityRowsCompanion(
      day: day ?? this.day,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (day.present) {
      map['day'] = Variable<String>(day.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ActivityRowsCompanion(')
          ..write('day: $day, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $QuizRowsTable extends QuizRows with TableInfo<$QuizRowsTable, QuizRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuizRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _weekMeta = const VerificationMeta('week');
  @override
  late final GeneratedColumn<String> week = GeneratedColumn<String>(
    'week',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _questionsMeta = const VerificationMeta(
    'questions',
  );
  @override
  late final GeneratedColumn<String> questions = GeneratedColumn<String>(
    'questions',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _answersMeta = const VerificationMeta(
    'answers',
  );
  @override
  late final GeneratedColumn<String> answers = GeneratedColumn<String>(
    'answers',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
  );
  static const VerificationMeta _cursorMeta = const VerificationMeta('cursor');
  @override
  late final GeneratedColumn<int> cursor = GeneratedColumn<int>(
    'cursor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _expiredMeta = const VerificationMeta(
    'expired',
  );
  @override
  late final GeneratedColumn<bool> expired = GeneratedColumn<bool>(
    'expired',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("expired" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _scoreMeta = const VerificationMeta('score');
  @override
  late final GeneratedColumn<int> score = GeneratedColumn<int>(
    'score',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    week,
    questions,
    answers,
    cursor,
    expired,
    score,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'quiz_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<QuizRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('week')) {
      context.handle(
        _weekMeta,
        week.isAcceptableOrUnknown(data['week']!, _weekMeta),
      );
    } else if (isInserting) {
      context.missing(_weekMeta);
    }
    if (data.containsKey('questions')) {
      context.handle(
        _questionsMeta,
        questions.isAcceptableOrUnknown(data['questions']!, _questionsMeta),
      );
    } else if (isInserting) {
      context.missing(_questionsMeta);
    }
    if (data.containsKey('answers')) {
      context.handle(
        _answersMeta,
        answers.isAcceptableOrUnknown(data['answers']!, _answersMeta),
      );
    }
    if (data.containsKey('cursor')) {
      context.handle(
        _cursorMeta,
        cursor.isAcceptableOrUnknown(data['cursor']!, _cursorMeta),
      );
    }
    if (data.containsKey('expired')) {
      context.handle(
        _expiredMeta,
        expired.isAcceptableOrUnknown(data['expired']!, _expiredMeta),
      );
    }
    if (data.containsKey('score')) {
      context.handle(
        _scoreMeta,
        score.isAcceptableOrUnknown(data['score']!, _scoreMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {week};
  @override
  QuizRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return QuizRow(
      week: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}week'],
      )!,
      questions: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}questions'],
      )!,
      answers: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}answers'],
      )!,
      cursor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cursor'],
      )!,
      expired: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}expired'],
      )!,
      score: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}score'],
      ),
    );
  }

  @override
  $QuizRowsTable createAlias(String alias) {
    return $QuizRowsTable(attachedDatabase, alias);
  }
}

class QuizRow extends DataClass implements Insertable<QuizRow> {
  final String week;
  final String questions;
  final String answers;
  final int cursor;
  final bool expired;
  final int? score;
  const QuizRow({
    required this.week,
    required this.questions,
    required this.answers,
    required this.cursor,
    required this.expired,
    this.score,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['week'] = Variable<String>(week);
    map['questions'] = Variable<String>(questions);
    map['answers'] = Variable<String>(answers);
    map['cursor'] = Variable<int>(cursor);
    map['expired'] = Variable<bool>(expired);
    if (!nullToAbsent || score != null) {
      map['score'] = Variable<int>(score);
    }
    return map;
  }

  QuizRowsCompanion toCompanion(bool nullToAbsent) {
    return QuizRowsCompanion(
      week: Value(week),
      questions: Value(questions),
      answers: Value(answers),
      cursor: Value(cursor),
      expired: Value(expired),
      score: score == null && nullToAbsent
          ? const Value.absent()
          : Value(score),
    );
  }

  factory QuizRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return QuizRow(
      week: serializer.fromJson<String>(json['week']),
      questions: serializer.fromJson<String>(json['questions']),
      answers: serializer.fromJson<String>(json['answers']),
      cursor: serializer.fromJson<int>(json['cursor']),
      expired: serializer.fromJson<bool>(json['expired']),
      score: serializer.fromJson<int?>(json['score']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'week': serializer.toJson<String>(week),
      'questions': serializer.toJson<String>(questions),
      'answers': serializer.toJson<String>(answers),
      'cursor': serializer.toJson<int>(cursor),
      'expired': serializer.toJson<bool>(expired),
      'score': serializer.toJson<int?>(score),
    };
  }

  QuizRow copyWith({
    String? week,
    String? questions,
    String? answers,
    int? cursor,
    bool? expired,
    Value<int?> score = const Value.absent(),
  }) => QuizRow(
    week: week ?? this.week,
    questions: questions ?? this.questions,
    answers: answers ?? this.answers,
    cursor: cursor ?? this.cursor,
    expired: expired ?? this.expired,
    score: score.present ? score.value : this.score,
  );
  QuizRow copyWithCompanion(QuizRowsCompanion data) {
    return QuizRow(
      week: data.week.present ? data.week.value : this.week,
      questions: data.questions.present ? data.questions.value : this.questions,
      answers: data.answers.present ? data.answers.value : this.answers,
      cursor: data.cursor.present ? data.cursor.value : this.cursor,
      expired: data.expired.present ? data.expired.value : this.expired,
      score: data.score.present ? data.score.value : this.score,
    );
  }

  @override
  String toString() {
    return (StringBuffer('QuizRow(')
          ..write('week: $week, ')
          ..write('questions: $questions, ')
          ..write('answers: $answers, ')
          ..write('cursor: $cursor, ')
          ..write('expired: $expired, ')
          ..write('score: $score')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(week, questions, answers, cursor, expired, score);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is QuizRow &&
          other.week == this.week &&
          other.questions == this.questions &&
          other.answers == this.answers &&
          other.cursor == this.cursor &&
          other.expired == this.expired &&
          other.score == this.score);
}

class QuizRowsCompanion extends UpdateCompanion<QuizRow> {
  final Value<String> week;
  final Value<String> questions;
  final Value<String> answers;
  final Value<int> cursor;
  final Value<bool> expired;
  final Value<int?> score;
  final Value<int> rowid;
  const QuizRowsCompanion({
    this.week = const Value.absent(),
    this.questions = const Value.absent(),
    this.answers = const Value.absent(),
    this.cursor = const Value.absent(),
    this.expired = const Value.absent(),
    this.score = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  QuizRowsCompanion.insert({
    required String week,
    required String questions,
    this.answers = const Value.absent(),
    this.cursor = const Value.absent(),
    this.expired = const Value.absent(),
    this.score = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : week = Value(week),
       questions = Value(questions);
  static Insertable<QuizRow> custom({
    Expression<String>? week,
    Expression<String>? questions,
    Expression<String>? answers,
    Expression<int>? cursor,
    Expression<bool>? expired,
    Expression<int>? score,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (week != null) 'week': week,
      if (questions != null) 'questions': questions,
      if (answers != null) 'answers': answers,
      if (cursor != null) 'cursor': cursor,
      if (expired != null) 'expired': expired,
      if (score != null) 'score': score,
      if (rowid != null) 'rowid': rowid,
    });
  }

  QuizRowsCompanion copyWith({
    Value<String>? week,
    Value<String>? questions,
    Value<String>? answers,
    Value<int>? cursor,
    Value<bool>? expired,
    Value<int?>? score,
    Value<int>? rowid,
  }) {
    return QuizRowsCompanion(
      week: week ?? this.week,
      questions: questions ?? this.questions,
      answers: answers ?? this.answers,
      cursor: cursor ?? this.cursor,
      expired: expired ?? this.expired,
      score: score ?? this.score,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (week.present) {
      map['week'] = Variable<String>(week.value);
    }
    if (questions.present) {
      map['questions'] = Variable<String>(questions.value);
    }
    if (answers.present) {
      map['answers'] = Variable<String>(answers.value);
    }
    if (cursor.present) {
      map['cursor'] = Variable<int>(cursor.value);
    }
    if (expired.present) {
      map['expired'] = Variable<bool>(expired.value);
    }
    if (score.present) {
      map['score'] = Variable<int>(score.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QuizRowsCompanion(')
          ..write('week: $week, ')
          ..write('questions: $questions, ')
          ..write('answers: $answers, ')
          ..write('cursor: $cursor, ')
          ..write('expired: $expired, ')
          ..write('score: $score, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ContentRowsTable extends ContentRows
    with TableInfo<$ContentRowsTable, ContentRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ContentRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<String> version = GeneratedColumn<String>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recordCountMeta = const VerificationMeta(
    'recordCount',
  );
  @override
  late final GeneratedColumn<int> recordCount = GeneratedColumn<int>(
    'record_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [version, recordCount];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'content_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<ContentRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    } else if (isInserting) {
      context.missing(_versionMeta);
    }
    if (data.containsKey('record_count')) {
      context.handle(
        _recordCountMeta,
        recordCount.isAcceptableOrUnknown(
          data['record_count']!,
          _recordCountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_recordCountMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {version};
  @override
  ContentRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ContentRow(
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}version'],
      )!,
      recordCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}record_count'],
      )!,
    );
  }

  @override
  $ContentRowsTable createAlias(String alias) {
    return $ContentRowsTable(attachedDatabase, alias);
  }
}

class ContentRow extends DataClass implements Insertable<ContentRow> {
  final String version;
  final int recordCount;
  const ContentRow({required this.version, required this.recordCount});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['version'] = Variable<String>(version);
    map['record_count'] = Variable<int>(recordCount);
    return map;
  }

  ContentRowsCompanion toCompanion(bool nullToAbsent) {
    return ContentRowsCompanion(
      version: Value(version),
      recordCount: Value(recordCount),
    );
  }

  factory ContentRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ContentRow(
      version: serializer.fromJson<String>(json['version']),
      recordCount: serializer.fromJson<int>(json['recordCount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'version': serializer.toJson<String>(version),
      'recordCount': serializer.toJson<int>(recordCount),
    };
  }

  ContentRow copyWith({String? version, int? recordCount}) => ContentRow(
    version: version ?? this.version,
    recordCount: recordCount ?? this.recordCount,
  );
  ContentRow copyWithCompanion(ContentRowsCompanion data) {
    return ContentRow(
      version: data.version.present ? data.version.value : this.version,
      recordCount: data.recordCount.present
          ? data.recordCount.value
          : this.recordCount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ContentRow(')
          ..write('version: $version, ')
          ..write('recordCount: $recordCount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(version, recordCount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ContentRow &&
          other.version == this.version &&
          other.recordCount == this.recordCount);
}

class ContentRowsCompanion extends UpdateCompanion<ContentRow> {
  final Value<String> version;
  final Value<int> recordCount;
  final Value<int> rowid;
  const ContentRowsCompanion({
    this.version = const Value.absent(),
    this.recordCount = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ContentRowsCompanion.insert({
    required String version,
    required int recordCount,
    this.rowid = const Value.absent(),
  }) : version = Value(version),
       recordCount = Value(recordCount);
  static Insertable<ContentRow> custom({
    Expression<String>? version,
    Expression<int>? recordCount,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (version != null) 'version': version,
      if (recordCount != null) 'record_count': recordCount,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ContentRowsCompanion copyWith({
    Value<String>? version,
    Value<int>? recordCount,
    Value<int>? rowid,
  }) {
    return ContentRowsCompanion(
      version: version ?? this.version,
      recordCount: recordCount ?? this.recordCount,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (version.present) {
      map['version'] = Variable<String>(version.value);
    }
    if (recordCount.present) {
      map['record_count'] = Variable<int>(recordCount.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ContentRowsCompanion(')
          ..write('version: $version, ')
          ..write('recordCount: $recordCount, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $PreferenceRowsTable preferenceRows = $PreferenceRowsTable(this);
  late final $AssignmentRowsTable assignmentRows = $AssignmentRowsTable(this);
  late final $LearnedRowsTable learnedRows = $LearnedRowsTable(this);
  late final $ActivityRowsTable activityRows = $ActivityRowsTable(this);
  late final $QuizRowsTable quizRows = $QuizRowsTable(this);
  late final $ContentRowsTable contentRows = $ContentRowsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    preferenceRows,
    assignmentRows,
    learnedRows,
    activityRows,
    quizRows,
    contentRows,
  ];
}

typedef $$PreferenceRowsTableCreateCompanionBuilder =
    PreferenceRowsCompanion Function({
      Value<int> id,
      Value<int> dailyGoal,
      Value<bool> onboarded,
      Value<bool> reminders,
      Value<int> reminderHour,
      Value<int> reminderMinute,
      Value<String> themeMode,
    });
typedef $$PreferenceRowsTableUpdateCompanionBuilder =
    PreferenceRowsCompanion Function({
      Value<int> id,
      Value<int> dailyGoal,
      Value<bool> onboarded,
      Value<bool> reminders,
      Value<int> reminderHour,
      Value<int> reminderMinute,
      Value<String> themeMode,
    });

class $$PreferenceRowsTableFilterComposer
    extends Composer<_$AppDatabase, $PreferenceRowsTable> {
  $$PreferenceRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dailyGoal => $composableBuilder(
    column: $table.dailyGoal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get onboarded => $composableBuilder(
    column: $table.onboarded,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get reminders => $composableBuilder(
    column: $table.reminders,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reminderHour => $composableBuilder(
    column: $table.reminderHour,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reminderMinute => $composableBuilder(
    column: $table.reminderMinute,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get themeMode => $composableBuilder(
    column: $table.themeMode,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PreferenceRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $PreferenceRowsTable> {
  $$PreferenceRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dailyGoal => $composableBuilder(
    column: $table.dailyGoal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get onboarded => $composableBuilder(
    column: $table.onboarded,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get reminders => $composableBuilder(
    column: $table.reminders,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reminderHour => $composableBuilder(
    column: $table.reminderHour,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reminderMinute => $composableBuilder(
    column: $table.reminderMinute,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get themeMode => $composableBuilder(
    column: $table.themeMode,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PreferenceRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PreferenceRowsTable> {
  $$PreferenceRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get dailyGoal =>
      $composableBuilder(column: $table.dailyGoal, builder: (column) => column);

  GeneratedColumn<bool> get onboarded =>
      $composableBuilder(column: $table.onboarded, builder: (column) => column);

  GeneratedColumn<bool> get reminders =>
      $composableBuilder(column: $table.reminders, builder: (column) => column);

  GeneratedColumn<int> get reminderHour => $composableBuilder(
    column: $table.reminderHour,
    builder: (column) => column,
  );

  GeneratedColumn<int> get reminderMinute => $composableBuilder(
    column: $table.reminderMinute,
    builder: (column) => column,
  );

  GeneratedColumn<String> get themeMode =>
      $composableBuilder(column: $table.themeMode, builder: (column) => column);
}

class $$PreferenceRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PreferenceRowsTable,
          PreferenceRow,
          $$PreferenceRowsTableFilterComposer,
          $$PreferenceRowsTableOrderingComposer,
          $$PreferenceRowsTableAnnotationComposer,
          $$PreferenceRowsTableCreateCompanionBuilder,
          $$PreferenceRowsTableUpdateCompanionBuilder,
          (
            PreferenceRow,
            BaseReferences<_$AppDatabase, $PreferenceRowsTable, PreferenceRow>,
          ),
          PreferenceRow,
          PrefetchHooks Function()
        > {
  $$PreferenceRowsTableTableManager(
    _$AppDatabase db,
    $PreferenceRowsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PreferenceRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PreferenceRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PreferenceRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> dailyGoal = const Value.absent(),
                Value<bool> onboarded = const Value.absent(),
                Value<bool> reminders = const Value.absent(),
                Value<int> reminderHour = const Value.absent(),
                Value<int> reminderMinute = const Value.absent(),
                Value<String> themeMode = const Value.absent(),
              }) => PreferenceRowsCompanion(
                id: id,
                dailyGoal: dailyGoal,
                onboarded: onboarded,
                reminders: reminders,
                reminderHour: reminderHour,
                reminderMinute: reminderMinute,
                themeMode: themeMode,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> dailyGoal = const Value.absent(),
                Value<bool> onboarded = const Value.absent(),
                Value<bool> reminders = const Value.absent(),
                Value<int> reminderHour = const Value.absent(),
                Value<int> reminderMinute = const Value.absent(),
                Value<String> themeMode = const Value.absent(),
              }) => PreferenceRowsCompanion.insert(
                id: id,
                dailyGoal: dailyGoal,
                onboarded: onboarded,
                reminders: reminders,
                reminderHour: reminderHour,
                reminderMinute: reminderMinute,
                themeMode: themeMode,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PreferenceRowsTable, PreferenceRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $PreferenceRowsTable,
                    PreferenceRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PreferenceRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PreferenceRowsTable,
      PreferenceRow,
      $$PreferenceRowsTableFilterComposer,
      $$PreferenceRowsTableOrderingComposer,
      $$PreferenceRowsTableAnnotationComposer,
      $$PreferenceRowsTableCreateCompanionBuilder,
      $$PreferenceRowsTableUpdateCompanionBuilder,
      (
        PreferenceRow,
        BaseReferences<_$AppDatabase, $PreferenceRowsTable, PreferenceRow>,
      ),
      PreferenceRow,
      PrefetchHooks Function()
    >;
typedef $$AssignmentRowsTableCreateCompanionBuilder =
    AssignmentRowsCompanion Function({
      required String day,
      required int goal,
      required String wordIds,
      Value<int> rowid,
    });
typedef $$AssignmentRowsTableUpdateCompanionBuilder =
    AssignmentRowsCompanion Function({
      Value<String> day,
      Value<int> goal,
      Value<String> wordIds,
      Value<int> rowid,
    });

class $$AssignmentRowsTableFilterComposer
    extends Composer<_$AppDatabase, $AssignmentRowsTable> {
  $$AssignmentRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get day => $composableBuilder(
    column: $table.day,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get goal => $composableBuilder(
    column: $table.goal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get wordIds => $composableBuilder(
    column: $table.wordIds,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AssignmentRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $AssignmentRowsTable> {
  $$AssignmentRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get day => $composableBuilder(
    column: $table.day,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get goal => $composableBuilder(
    column: $table.goal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get wordIds => $composableBuilder(
    column: $table.wordIds,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AssignmentRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AssignmentRowsTable> {
  $$AssignmentRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get day =>
      $composableBuilder(column: $table.day, builder: (column) => column);

  GeneratedColumn<int> get goal =>
      $composableBuilder(column: $table.goal, builder: (column) => column);

  GeneratedColumn<String> get wordIds =>
      $composableBuilder(column: $table.wordIds, builder: (column) => column);
}

class $$AssignmentRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AssignmentRowsTable,
          AssignmentRow,
          $$AssignmentRowsTableFilterComposer,
          $$AssignmentRowsTableOrderingComposer,
          $$AssignmentRowsTableAnnotationComposer,
          $$AssignmentRowsTableCreateCompanionBuilder,
          $$AssignmentRowsTableUpdateCompanionBuilder,
          (
            AssignmentRow,
            BaseReferences<_$AppDatabase, $AssignmentRowsTable, AssignmentRow>,
          ),
          AssignmentRow,
          PrefetchHooks Function()
        > {
  $$AssignmentRowsTableTableManager(
    _$AppDatabase db,
    $AssignmentRowsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AssignmentRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AssignmentRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AssignmentRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> day = const Value.absent(),
                Value<int> goal = const Value.absent(),
                Value<String> wordIds = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AssignmentRowsCompanion(
                day: day,
                goal: goal,
                wordIds: wordIds,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String day,
                required int goal,
                required String wordIds,
                Value<int> rowid = const Value.absent(),
              }) => AssignmentRowsCompanion.insert(
                day: day,
                goal: goal,
                wordIds: wordIds,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AssignmentRowsTable, AssignmentRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $AssignmentRowsTable,
                    AssignmentRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AssignmentRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AssignmentRowsTable,
      AssignmentRow,
      $$AssignmentRowsTableFilterComposer,
      $$AssignmentRowsTableOrderingComposer,
      $$AssignmentRowsTableAnnotationComposer,
      $$AssignmentRowsTableCreateCompanionBuilder,
      $$AssignmentRowsTableUpdateCompanionBuilder,
      (
        AssignmentRow,
        BaseReferences<_$AppDatabase, $AssignmentRowsTable, AssignmentRow>,
      ),
      AssignmentRow,
      PrefetchHooks Function()
    >;
typedef $$LearnedRowsTableCreateCompanionBuilder =
    LearnedRowsCompanion Function({
      required String wordId,
      required String day,
      Value<int> rowid,
    });
typedef $$LearnedRowsTableUpdateCompanionBuilder =
    LearnedRowsCompanion Function({
      Value<String> wordId,
      Value<String> day,
      Value<int> rowid,
    });

class $$LearnedRowsTableFilterComposer
    extends Composer<_$AppDatabase, $LearnedRowsTable> {
  $$LearnedRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get wordId => $composableBuilder(
    column: $table.wordId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get day => $composableBuilder(
    column: $table.day,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LearnedRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $LearnedRowsTable> {
  $$LearnedRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get wordId => $composableBuilder(
    column: $table.wordId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get day => $composableBuilder(
    column: $table.day,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LearnedRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LearnedRowsTable> {
  $$LearnedRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get wordId =>
      $composableBuilder(column: $table.wordId, builder: (column) => column);

  GeneratedColumn<String> get day =>
      $composableBuilder(column: $table.day, builder: (column) => column);
}

class $$LearnedRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LearnedRowsTable,
          LearnedRow,
          $$LearnedRowsTableFilterComposer,
          $$LearnedRowsTableOrderingComposer,
          $$LearnedRowsTableAnnotationComposer,
          $$LearnedRowsTableCreateCompanionBuilder,
          $$LearnedRowsTableUpdateCompanionBuilder,
          (
            LearnedRow,
            BaseReferences<_$AppDatabase, $LearnedRowsTable, LearnedRow>,
          ),
          LearnedRow,
          PrefetchHooks Function()
        > {
  $$LearnedRowsTableTableManager(_$AppDatabase db, $LearnedRowsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LearnedRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LearnedRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LearnedRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> wordId = const Value.absent(),
            Value<String> day = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => LearnedRowsCompanion(wordId: wordId, day: day, rowid: rowid),
          createCompanionCallback:
              ({
                required String wordId,
                required String day,
                Value<int> rowid = const Value.absent(),
              }) => LearnedRowsCompanion.insert(
                wordId: wordId,
                day: day,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LearnedRowsTable, LearnedRow>(table),
                  BaseReferences<_$AppDatabase, $LearnedRowsTable, LearnedRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LearnedRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LearnedRowsTable,
      LearnedRow,
      $$LearnedRowsTableFilterComposer,
      $$LearnedRowsTableOrderingComposer,
      $$LearnedRowsTableAnnotationComposer,
      $$LearnedRowsTableCreateCompanionBuilder,
      $$LearnedRowsTableUpdateCompanionBuilder,
      (
        LearnedRow,
        BaseReferences<_$AppDatabase, $LearnedRowsTable, LearnedRow>,
      ),
      LearnedRow,
      PrefetchHooks Function()
    >;
typedef $$ActivityRowsTableCreateCompanionBuilder =
    ActivityRowsCompanion Function({required String day, Value<int> rowid});
typedef $$ActivityRowsTableUpdateCompanionBuilder =
    ActivityRowsCompanion Function({Value<String> day, Value<int> rowid});

class $$ActivityRowsTableFilterComposer
    extends Composer<_$AppDatabase, $ActivityRowsTable> {
  $$ActivityRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get day => $composableBuilder(
    column: $table.day,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ActivityRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $ActivityRowsTable> {
  $$ActivityRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get day => $composableBuilder(
    column: $table.day,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ActivityRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ActivityRowsTable> {
  $$ActivityRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get day =>
      $composableBuilder(column: $table.day, builder: (column) => column);
}

class $$ActivityRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ActivityRowsTable,
          ActivityRow,
          $$ActivityRowsTableFilterComposer,
          $$ActivityRowsTableOrderingComposer,
          $$ActivityRowsTableAnnotationComposer,
          $$ActivityRowsTableCreateCompanionBuilder,
          $$ActivityRowsTableUpdateCompanionBuilder,
          (
            ActivityRow,
            BaseReferences<_$AppDatabase, $ActivityRowsTable, ActivityRow>,
          ),
          ActivityRow,
          PrefetchHooks Function()
        > {
  $$ActivityRowsTableTableManager(_$AppDatabase db, $ActivityRowsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ActivityRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ActivityRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ActivityRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> day = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => ActivityRowsCompanion(day: day, rowid: rowid),
          createCompanionCallback: ({
            required String day,
            Value<int> rowid = const Value.absent(),
          }) => ActivityRowsCompanion.insert(day: day, rowid: rowid),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ActivityRowsTable, ActivityRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $ActivityRowsTable,
                    ActivityRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ActivityRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ActivityRowsTable,
      ActivityRow,
      $$ActivityRowsTableFilterComposer,
      $$ActivityRowsTableOrderingComposer,
      $$ActivityRowsTableAnnotationComposer,
      $$ActivityRowsTableCreateCompanionBuilder,
      $$ActivityRowsTableUpdateCompanionBuilder,
      (
        ActivityRow,
        BaseReferences<_$AppDatabase, $ActivityRowsTable, ActivityRow>,
      ),
      ActivityRow,
      PrefetchHooks Function()
    >;
typedef $$QuizRowsTableCreateCompanionBuilder = QuizRowsCompanion Function({
  required String week,
  required String questions,
  Value<String> answers,
  Value<int> cursor,
  Value<bool> expired,
  Value<int?> score,
  Value<int> rowid,
});
typedef $$QuizRowsTableUpdateCompanionBuilder = QuizRowsCompanion Function({
  Value<String> week,
  Value<String> questions,
  Value<String> answers,
  Value<int> cursor,
  Value<bool> expired,
  Value<int?> score,
  Value<int> rowid,
});

class $$QuizRowsTableFilterComposer
    extends Composer<_$AppDatabase, $QuizRowsTable> {
  $$QuizRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get week => $composableBuilder(
    column: $table.week,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get questions => $composableBuilder(
    column: $table.questions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get answers => $composableBuilder(
    column: $table.answers,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cursor => $composableBuilder(
    column: $table.cursor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get expired => $composableBuilder(
    column: $table.expired,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnFilters(column),
  );
}

class $$QuizRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $QuizRowsTable> {
  $$QuizRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get week => $composableBuilder(
    column: $table.week,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get questions => $composableBuilder(
    column: $table.questions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get answers => $composableBuilder(
    column: $table.answers,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cursor => $composableBuilder(
    column: $table.cursor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get expired => $composableBuilder(
    column: $table.expired,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$QuizRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $QuizRowsTable> {
  $$QuizRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get week =>
      $composableBuilder(column: $table.week, builder: (column) => column);

  GeneratedColumn<String> get questions =>
      $composableBuilder(column: $table.questions, builder: (column) => column);

  GeneratedColumn<String> get answers =>
      $composableBuilder(column: $table.answers, builder: (column) => column);

  GeneratedColumn<int> get cursor =>
      $composableBuilder(column: $table.cursor, builder: (column) => column);

  GeneratedColumn<bool> get expired =>
      $composableBuilder(column: $table.expired, builder: (column) => column);

  GeneratedColumn<int> get score =>
      $composableBuilder(column: $table.score, builder: (column) => column);
}

class $$QuizRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $QuizRowsTable,
          QuizRow,
          $$QuizRowsTableFilterComposer,
          $$QuizRowsTableOrderingComposer,
          $$QuizRowsTableAnnotationComposer,
          $$QuizRowsTableCreateCompanionBuilder,
          $$QuizRowsTableUpdateCompanionBuilder,
          (QuizRow, BaseReferences<_$AppDatabase, $QuizRowsTable, QuizRow>),
          QuizRow,
          PrefetchHooks Function()
        > {
  $$QuizRowsTableTableManager(_$AppDatabase db, $QuizRowsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QuizRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QuizRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$QuizRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> week = const Value.absent(),
                Value<String> questions = const Value.absent(),
                Value<String> answers = const Value.absent(),
                Value<int> cursor = const Value.absent(),
                Value<bool> expired = const Value.absent(),
                Value<int?> score = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => QuizRowsCompanion(
                week: week,
                questions: questions,
                answers: answers,
                cursor: cursor,
                expired: expired,
                score: score,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String week,
                required String questions,
                Value<String> answers = const Value.absent(),
                Value<int> cursor = const Value.absent(),
                Value<bool> expired = const Value.absent(),
                Value<int?> score = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => QuizRowsCompanion.insert(
                week: week,
                questions: questions,
                answers: answers,
                cursor: cursor,
                expired: expired,
                score: score,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$QuizRowsTable, QuizRow>(table),
                  BaseReferences<_$AppDatabase, $QuizRowsTable, QuizRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$QuizRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $QuizRowsTable,
      QuizRow,
      $$QuizRowsTableFilterComposer,
      $$QuizRowsTableOrderingComposer,
      $$QuizRowsTableAnnotationComposer,
      $$QuizRowsTableCreateCompanionBuilder,
      $$QuizRowsTableUpdateCompanionBuilder,
      (QuizRow, BaseReferences<_$AppDatabase, $QuizRowsTable, QuizRow>),
      QuizRow,
      PrefetchHooks Function()
    >;
typedef $$ContentRowsTableCreateCompanionBuilder =
    ContentRowsCompanion Function({
      required String version,
      required int recordCount,
      Value<int> rowid,
    });
typedef $$ContentRowsTableUpdateCompanionBuilder =
    ContentRowsCompanion Function({
      Value<String> version,
      Value<int> recordCount,
      Value<int> rowid,
    });

class $$ContentRowsTableFilterComposer
    extends Composer<_$AppDatabase, $ContentRowsTable> {
  $$ContentRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get recordCount => $composableBuilder(
    column: $table.recordCount,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ContentRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $ContentRowsTable> {
  $$ContentRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get recordCount => $composableBuilder(
    column: $table.recordCount,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ContentRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ContentRowsTable> {
  $$ContentRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<int> get recordCount => $composableBuilder(
    column: $table.recordCount,
    builder: (column) => column,
  );
}

class $$ContentRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ContentRowsTable,
          ContentRow,
          $$ContentRowsTableFilterComposer,
          $$ContentRowsTableOrderingComposer,
          $$ContentRowsTableAnnotationComposer,
          $$ContentRowsTableCreateCompanionBuilder,
          $$ContentRowsTableUpdateCompanionBuilder,
          (
            ContentRow,
            BaseReferences<_$AppDatabase, $ContentRowsTable, ContentRow>,
          ),
          ContentRow,
          PrefetchHooks Function()
        > {
  $$ContentRowsTableTableManager(_$AppDatabase db, $ContentRowsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ContentRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ContentRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ContentRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> version = const Value.absent(),
                Value<int> recordCount = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ContentRowsCompanion(
                version: version,
                recordCount: recordCount,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String version,
                required int recordCount,
                Value<int> rowid = const Value.absent(),
              }) => ContentRowsCompanion.insert(
                version: version,
                recordCount: recordCount,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ContentRowsTable, ContentRow>(table),
                  BaseReferences<_$AppDatabase, $ContentRowsTable, ContentRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ContentRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ContentRowsTable,
      ContentRow,
      $$ContentRowsTableFilterComposer,
      $$ContentRowsTableOrderingComposer,
      $$ContentRowsTableAnnotationComposer,
      $$ContentRowsTableCreateCompanionBuilder,
      $$ContentRowsTableUpdateCompanionBuilder,
      (
        ContentRow,
        BaseReferences<_$AppDatabase, $ContentRowsTable, ContentRow>,
      ),
      ContentRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$PreferenceRowsTableTableManager get preferenceRows =>
      $$PreferenceRowsTableTableManager(_db, _db.preferenceRows);
  $$AssignmentRowsTableTableManager get assignmentRows =>
      $$AssignmentRowsTableTableManager(_db, _db.assignmentRows);
  $$LearnedRowsTableTableManager get learnedRows =>
      $$LearnedRowsTableTableManager(_db, _db.learnedRows);
  $$ActivityRowsTableTableManager get activityRows =>
      $$ActivityRowsTableTableManager(_db, _db.activityRows);
  $$QuizRowsTableTableManager get quizRows =>
      $$QuizRowsTableTableManager(_db, _db.quizRows);
  $$ContentRowsTableTableManager get contentRows =>
      $$ContentRowsTableTableManager(_db, _db.contentRows);
}
