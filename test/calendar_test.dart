import 'package:flutter_test/flutter_test.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;
import 'package:wortly/domain/models.dart';

import 'support.dart';

void main() {
  setUpAll(tzdata.initializeTimeZones);
  test('DST spring gap is one civil day, not a 24-hour duration', () async {
    final zone = tz.getLocation('Europe/Berlin');
    final h = Harness();
    addTearDown(h.db.close);
    h.clock.value = tz.TZDateTime(zone, 2026, 3, 28, 9);
    await h.finish();
    h.clock.value = tz.TZDateTime(zone, 2026, 3, 29, 9);
    await h.finish();
    expect((await h.learning.streak()).current, 2);
    expect(
      const LocalDate(2026, 3, 28).daysUntil(const LocalDate(2026, 3, 29)),
      1,
    );
  });
  test(
    'DST autumn repeated hour keeps exactly one assignment and award',
    () async {
      final zone = tz.getLocation('Europe/Berlin');
      final h = Harness();
      addTearDown(h.db.close);
      h.clock.value = tz.TZDateTime.from(
        DateTime.utc(2026, 10, 25, 0, 30),
        zone,
      );
      final a = await h.finish();
      h.clock.value = tz.TZDateTime.from(
        DateTime.utc(2026, 10, 25, 1, 30),
        zone,
      );
      final b = await h.finish();
      expect(a.wordIds, b.wordIds);
      expect(await h.learning.activity(), hasLength(1));
    },
  );
  test(
    'timezone travel uses device local date and restores an existing date',
    () async {
      final h = Harness();
      addTearDown(h.db.close);
      final instant = DateTime.utc(2026, 10, 25, 1);
      h.clock.value = tz.TZDateTime.from(
        instant,
        tz.getLocation('Europe/Berlin'),
      );
      final berlin = await h.learning.ensureToday();
      h.clock.value = tz.TZDateTime.from(
        instant,
        tz.getLocation('America/Los_Angeles'),
      );
      expect(h.learning.today.key, '2026-10-24');
      expect(
        await h.learning.complete(berlin.wordIds.first, berlin.date),
        false,
      );
      await h.learning.ensureToday();
      h.clock.value = tz.TZDateTime.from(
        instant,
        tz.getLocation('Europe/Berlin'),
      );
      expect((await h.learning.ensureToday()).wordIds, berlin.wordIds);
    },
  );
  test('Monday calculation across year boundary and leap day arithmetic', () {
    expect(const LocalDate(2027, 1, 3).monday, const LocalDate(2026, 12, 28));
    expect(
      const LocalDate(2028, 2, 28).plusDays(1),
      const LocalDate(2028, 2, 29),
    );
    expect(
      const LocalDate(2028, 2, 28).plusDays(2),
      const LocalDate(2028, 3, 1),
    );
    expect(() => LocalDate.parse('2026-02-30'), throwsFormatException);
  });
}
