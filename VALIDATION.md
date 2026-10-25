# Validation record — 25 October 2026

Development delivery; beta approval has **not** been granted.

## Verified in this workspace

| Check | Result |
|---|---|
| SDK | Flutter 3.47.8 stable / Dart 3.13.7 installed separately |
| Drift code generation | Passed; generated source included |
| Dart formatting | 28 files; no pending formatting changes |
| Static analysis | Passed; no issues |
| Flutter automated tests | 41 passed in the final full run |
| Content import validation | 390 structurally valid draft records, 780 example pairs |
| Python validator tests | 7 passed |
| Beta corpus/editorial gate | Correctly rejected incomplete corpus and missing human approval |
| Visual inspection | Bundled-font renders inspected for onboarding, Today, Progress, Settings and Test |
| Android emulator setup | Pixel 7 / API 35 x86_64, booted |
| Android debug build | Passed; universal development APK |
| Native Android smoke test | Passed on API 35 with airplane mode on, Wi-Fi and mobile data off |
| Real Android process restart | Passed: force-stop/relaunch retained the exact assignment, goal, one partial completion and zero premature streak awards; reopened on the next word |

The test suite uses real Drift/SQLite databases, including file-backed close/reopen
tests and a schema v1→v2 migration preserving preferences, lessons, learned words,
activity and scores. Calendar tests use Europe/Berlin DST transitions and a shared
instant viewed in Berlin and Los Angeles. UI tests exercise onboarding, actual
completion taps, Sunday scoring, settings, empty progress, 320-pixel screens at
200% text, screen-reader labels and Android touch-target sizes. Notification
permission logic is tested using an injected reminder service.

Rendered previews are in `output/previews/`. Test fixtures do not seed the user's
installed database. Raw local logs are ignored by source control.

## Native build/device checks

The native integration test completed onboarding, learned a word, closed the
application services and SQLite connection, reopened the same file, and verified
the exact assignment, learned count, daily goal and single streak day. It passed
with airplane mode enabled, Wi-Fi disabled and mobile data disabled. This is a
native file close/reopen check, not a claim of physical-device or iOS validation.

The normal app was also installed and checked independently of the integration
runner: onboard with a three-word goal, learn one word, force-stop the process,
relaunch offline, then compare the on-device SQLite records before/after. The
preferences, assignment IDs/order/goal, single learned record and empty activity
table matched exactly. The UI reopened on `lernen`, the next unfinished word.
The native render is saved at `output/native-today.png`.

The Windows/JDK AF_UNIX pipe failure was reproduced
outside Gradle with a minimal Selector probe; a process-local socket-directory
override enables Java's TCP fallback. `tool/flutter.ps1` includes this workaround.
It does not change the installed JDK or the system environment.
Kotlin incremental compilation is disabled because its cache could not represent
paths across the C: package cache and D: project drives. Native builds use four
Gradle workers to keep resource use bounded. The generated Android target follows
Flutter 3.47's API 24 minimum.

## Remaining beta/release requirements

- Expand the original draft corpus from 390 to approximately 3,000 curated
  records. Complete a genuine German-language editorial review of every record,
  translations, examples, grammatical metadata, usefulness order and quiz
  equivalence groups. Record approval against the final corpus hash. Both gates
  are enforced by `python tool/validate_content.py --release`.
- Validate iOS builds, Apple signing, simulator and physical iPhone/iPad behavior
  on macOS with Xcode. This Windows environment cannot establish those results.
- Verify notifications on physical Android/iOS devices, including permission
  denial, local time, DST/travel while the app is closed, reboot, cancellation,
  foreground/background operation and manufacturer power-saving policies.
- Perform manual TalkBack/VoiceOver, Dynamic Type, contrast, landscape/tablet and
  physical-device checks. Automated labels/layout checks and inspected renders
  support these checks but do not replace assistive-technology testing.
- Configure owned application identifiers, production signing and store assets;
  debug signing is only for development. No store publishing has occurred.

The source has all requested engineering areas implemented. The incomplete,
unreviewed content and outstanding platform/device release checks prevent a claim
that the complete product brief or beta release conditions have been fulfilled.
