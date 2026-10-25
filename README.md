# Wortly

An offline German vocabulary app for iOS and Android. Built with Flutter Material
3, Riverpod and Drift/SQLite. Fonts, vocabulary and examples are bundled. There is
no account, backend, subscription or runtime network requirement.

**Development MVP — not beta-ready.** The bundle contains **390 original
AI-authored draft records / 780 translated examples**, not the approximately
3,000-word reviewed launch corpus. No human German-language editorial review has
occurred. The enforced content release gate intentionally rejects this starter.
See [content/EDITORIAL.md](content/EDITORIAL.md).

## Setup

Pinned SDK: **Flutter 3.47.8 stable / Dart 3.13.7**.

`tool/flutter.ps1` selects an SDK at `%USERPROFILE%\.codex\tools\flutter-wortly`
when present, then falls back to
Flutter on PATH. Override with `WORTLY_FLUTTER` set to an SDK root. On another
machine, install the pinned SDK from the [Flutter archive](https://docs.flutter.dev/install/archive).
Android requires a supported JDK, Android SDK/build tools and accepted SDK
licenses. Android Studio's bundled JDK works. Flutter 3.47 requires minimum
Android API 24 (Android 7.0); the project follows that SDK default.

This Windows host has a Java AF_UNIX pipe failure before Gradle starts. The
PowerShell helper sets a process-local `jdk.net.unixdomain.tmpdir` pointing to
an absent directory, which makes Java use its TCP pipe fallback. The installed
JDK is unchanged; ordinary builds on other hosts do not need the workaround.

From the project root in PowerShell:

```powershell
.\tool\flutter.ps1 doctor -v
.\tool\flutter.ps1 pub get
.\tool\flutter.ps1 pub run build_runner build
.\tool\flutter.ps1 devices
.\tool\flutter.ps1 run -d <android-device-id>
```

On macOS/Linux with the pinned Flutter on PATH:

```sh
flutter pub get
dart run build_runner build
flutter run -d <device-id>
```

Generated Drift code and the dependency lockfile are included. Use `pub get` for
reproducible resolution. Only development setup downloads packages/SDK artifacts;
the installed mobile app uses on-device storage and bundled assets.

## Behavior

- Settings offers System, Light and Dark appearance. System follows the device;
  an explicit choice is saved locally and restored on restart.
- Onboarding confirms English and offers 1, 3 or 5 daily words, defaulting to 3,
  then opens Today. A fixed learning button opens a full-screen lesson with
  swipeable cards and previous/next controls. The word and examples get the
  available screen space; the learning action stays fixed below the card.
  Cards have grammatical type, article/plural for nouns, English meanings and
  two translated examples. Long content and large text scroll inside the card.
- Leaving a lesson preserves each learned word. Continue learning starts on the
  next unlearned word; completing the lesson returns to Today. Swiping only
  browses, and completed lessons can be revisited without changing progress.
- Each civil date has one transactional assignment and a goal snapshot. Oldest
  unfinished words carry forward first; remaining places use unseen words in
  usefulness order. Goal changes affect the next newly assigned date.
- Each completion saves immediately. Unique word/activity keys and transactions
  prevent double counts. Only a fully completed nonempty lesson earns a streak
  day. Missing a day resets the current run; the longest run remains.
- Date checks happen at startup, resume, every 15 seconds while open, and before
  completion. Tapping a stale card after midnight refreshes today's lesson.
  Calendar-component arithmetic handles DST, leap days and month/year boundaries.
  Returning to an existing date restores that date's original assignment.
- At the end of the vocabulary, only the remainder is assigned. Completing the
  collection shows a complete state and permanently preserves the final streak.
- Tests unlock on Sunday after that day's lesson. One question per distinct word
  first learned during local Monday–Sunday, alternating translation direction.
  Four choices respect curated equivalence groups. Questions, choices, answers
  and cursor are frozen in SQLite. Selection locks and reveals feedback; Next is
  explicit. The final action saves one score per week. Incomplete tests expire
  permanently after leaving their Sunday; completed scores remain in Progress.
  Tests never award streaks.
  If the collection finishes before Sunday, that week's learned words can still
  be tested without creating an empty streak day. Later weeks have no new test.
- Progress shows learned words, current/longest streaks, weekly scores and a
  labeled five-week activity calendar. Today, Test and Progress are the three
  navigation destinations; Settings opens from the small toolbar icon.
- Reminders default off. Permission is requested only when enabling. A local
  repeating notification uses the current IANA timezone and calendar scheduling.
  Startup/resume reconfigure it for timezone changes. Android uses inexact alarms,
  without an exact-alarm permission. Device power policies may delay delivery.

## Source and persistence

```text
lib/domain/models.dart               Typed records, civil dates, injected clock
lib/data/database.dart               Drift schema v3; additive migrations preserve history
lib/data/vocabulary_repository.dart   Versioned bundled content
lib/data/preferences_repository.dart Settings and onboarding
lib/data/learning_repository.dart    Lessons, completions, activity and streaks
lib/data/quiz_repository.dart        Membership, frozen sessions, scoring, expiry
lib/services/reminders.dart          Optional OS notifications
lib/app_controller.dart             Riverpod state and service injection
lib/ui/                             All five app screens
assets/content/vocabulary.json      Runtime corpus
tool/author_content.py               Original starter authoring source
tool/validate_content.py             Import validator and beta gate
content/editorial_review.json        Pending review record
test/                               Repository, calendar, migration, UI tests
integration_test/                   Native SQLite reopen smoke test
```

SQLite stores preferences/onboarding, daily assignments, first-learned dates,
earned activity dates, quiz sessions/scores and content import versions. Drift
manages its file in the platform's application documents directory. No migration clears progress.
Schema v2 adds import metadata; v3 adds the saved theme preference. Both preserve
history. For future schema
changes, increment `schemaVersion`, write an additive/data-preserving migration
and extend the migration test. Released word IDs may never disappear or be
reassigned. Validate content updates against the last shipped bundle:

```sh
python tool/validate_content.py new.json --previous old.json
```

Quiz text is snapshotted so editorial updates cannot alter an in-progress test.
Equivalence keys require human review: string uniqueness cannot establish that
two answers are semantically distinct. The typed model supports later translation
languages; English is the sole launch language.

Android and iOS are the supported platform targets. Use `flutter emulators`
to list your locally configured Android emulators.

## Checks

```powershell
python tool\validate_content.py
python -m unittest discover -s tool -p test_validator.py -v
.\tool\flutter.ps1 pub run build_runner build
.\tool\dart.ps1 format --output=none --set-exit-if-changed lib test integration_test
.\tool\flutter.ps1 analyze
.\tool\flutter.ps1 test --reporter expanded
.\tool\flutter.ps1 test integration_test\wortly_test.dart -d <android-device-id>
.\tool\flutter.ps1 build apk --debug
```

`tool/check.ps1` runs content validation, Python validator tests, code generation,
format checks, analysis and Flutter tests. `-ReleaseContent` additionally requires
the complete corpus and exact-byte editorial approval. On macOS/Linux, use
`dart format --output=none --set-exit-if-changed lib test integration_test`,
`flutter analyze` and `flutter test`.

Tests cover restart persistence, partial progress, carry ordering, goal snapshots,
repeated/concurrent operations, exhaustion, midnight, calendar boundaries, DST,
timezone travel, date revisits, Sunday gating, weekly membership, directions,
equivalent choices, locking, expiry, scoring and streak independence. UI checks
cover onboarding through completion, settings, Sunday testing, small screens,
200% text, labels and touch targets. `test/preview_test.dart` creates PNGs using
the bundled fonts in `output/previews/` for visual review.

Beta check, **expected to fail** for this development delivery:

```sh
python tool/validate_content.py --release
```

See [VALIDATION.md](VALIDATION.md) for actual run results and remaining checks.

## Android builds and offline device checks

`flutter build apk --debug` creates
`build/app/outputs/flutter-apk/app-debug.apk`. Install with `adb install -r`.

For production, register your final application ID, create your organization's
keystore/signing config and replace the generated debug signing fallback in
`android/app/build.gradle.kts`. Run the content gate before
`flutter build appbundle --release`. `app.wortly.wortly` is a development ID; no
store upload or production signing is configured.

Device restart procedure: onboard, complete part of a lesson, force-stop, disable
Wi-Fi/mobile data and reopen. Confirm the exact cards and partial progress.
Finish and repeat; confirm one activity day. Check midnight rollover, timezone
changes, next-day goals and Sunday quiz feedback/order across force-stop/reopen.
Verify notifications on physical devices: enabling/denial, chosen local time,
reboot, disabling, power saving, timezone travel and DST. Inspect TalkBack and
large-text layouts. No remote data or account is needed for any learning flow.

## iOS on macOS

Windows cannot build/sign iOS or validate an iPhone. On a Mac with supported Xcode,
install CocoaPods if required by the current Flutter/plugin toolchain, then:

```sh
flutter pub get
flutter build ios --simulator --debug
open ios/Runner.xcworkspace
```

Select Runner, choose your Apple development team and a registered bundle ID,
then run on a physical iPhone. After all release gates pass, archive with
`flutter build ipa --release`. Check fresh-install notification permission remains
unrequested until enabling, denied permissions, local-time scheduling,
foreground/background delivery, DST/travel, disabling, VoiceOver, Dynamic Type,
iPad layout and cold-start persistence. Apple signing and iOS device validation
remain macOS release work.

## Assets and implementation references

Fraunces and DM Sans are bundled under the SIL Open Font License; licenses live
in `assets/fonts/`. `tool/fetch_fonts.py` downloads from the
[Google Fonts repository](https://github.com/google/fonts) during development only.
Leaf icons are original vector geometry; `tool/make_icons.py` generates native
raster sizes with Pillow. Neither script runs in the mobile app.

References: [Flutter setup](https://docs.flutter.dev/install/),
[Drift setup](https://drift.simonbinder.eu/setup/),
[Drift migrations](https://drift.simonbinder.eu/migrations/), and
[local notifications](https://pub.dev/packages/flutter_local_notifications).
