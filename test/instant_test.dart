import 'package:solar_calculator/src/instant.dart';
import 'package:solar_calculator/src/timespan.dart';
import 'package:test/test.dart';

void main() {
  group('Creation', () {
    // final localTimeZone = DateTime.now().timeZoneOffset;

    // final modF = modf(localTimeZone.totalHours);
    // final h = (modF.integerPart >= 10) ? '${modF.integerPart}' : '0${modF.integerPart}';
    // final mins = (modF.fractionalPart * Duration.minutesPerHour).round();
    // final m = (mins >= 10) ? '$mins' : '0$mins';

    // final sign = localTimeZone.isNegative ? '-' : '+';

    // print('$sign$h:$m');

    test('From DateTime in local time zone', () {
      final instant = Instant.fromDateTime(DateTime(2021, 09, 24, 01, 48));
      expect(instant.toIso8601String(), '2021-09-24T01:48:00+02:00');
    });

    test('From DateTime in local time zone to UTC+04:00', () {
      final instant = Instant.fromDateTime(DateTime(2021, 09, 24, 01, 48), timeZoneOffset: 4.0);
      expect(instant.toIso8601String(), '2021-09-24T03:48:00+04:00');
    });

    test('From DateTime in local time zone to UTC-04:00', () {
      final instant = Instant.fromDateTime(DateTime(2021, 09, 24, 01, 48), timeZoneOffset: -4.0);
      expect(instant.toIso8601String(), '2021-09-23T19:48:00-04:00');
    });
  });

  group('Operations', () {
    test('Addition with positive duration', () {
      final instant = Instant(2021, 05, 09, 14, 00, 00, 2).add(Duration(days: 1, hours: 4, minutes: 30));
      expect(instant.toIso8601String(), '2021-05-10T18:30:00+02:00');
    });

    test('Addition with negative duration', () {
      final instant = Instant(2021, 05, 09, 14, 00, 00, 2).add(Duration(days: -1, hours: 4, minutes: 30));
      expect(instant.toIso8601String(), '2021-05-08T18:30:00+02:00');
    });

    test('Substraction with positive duration', () {
      final instant = Instant(2021, 05, 09, 14, 00, 00, 2).subtract(Duration(days: 1, hours: 4, minutes: 30));
      expect(instant.toIso8601String(), '2021-05-08T09:30:00+02:00');
    });

    test('Substraction with negative duration', () {
      final instant = Instant(2021, 05, 09, 14, 00, 00, 2).subtract(Duration(days: -1, hours: 4, minutes: 30));
      expect(instant.toIso8601String(), '2021-05-10T09:30:00+02:00');
    });
  });

  group('Leap year detection', () {
    test('Leap year 2020', () {
      final instant = Instant(2020);
      expect(instant.isLeapYear, true);
    });

    test('Leap year 2000', () {
      final instant = Instant(2000);
      expect(instant.isLeapYear, true);
    });

    test('Leap year 1996', () {
      final instant = Instant(1996);
      expect(instant.isLeapYear, true);
    });

    test('Non leap year 2021', () {
      final instant = Instant(2021);
      expect(instant.isLeapYear, false);
    });

    test('Non leap year 2014', () {
      final instant = Instant(2014);
      expect(instant.isLeapYear, false);
    });

    test('Non leap year 1997', () {
      final instant = Instant(1997);
      expect(instant.isLeapYear, false);
    });

    test('Non leap year 1998', () {
      final instant = Instant(1998);
      expect(instant.isLeapYear, false);
    });
  });

  group('Unix epoch years range', () {
    List.generate(121, (index) => 1900 + index).forEach((y) {
      test(y, () {
        final instant = Instant(y);
        expect(instant.sinceEpoch, Duration(milliseconds: DateTime.utc(y).millisecondsSinceEpoch));
      });
    });
  });

  group('Since Unix epoch', () {
    test('2021-05-09 13:00:00+02:00', () {
      final instant = Instant(2021, 05, 09, 13, 0, 0, 2);
      expect(
          instant.sinceEpoch, Timespan.fromMilliseconds(DateTime(2021, 05, 09, 13).millisecondsSinceEpoch.toDouble()));
    });

    test('Leap year - 2020-01-01', () {
      final instant = Instant(2020);
      expect(instant.sinceEpoch, Timespan.fromMilliseconds(DateTime.utc(2020).millisecondsSinceEpoch.toDouble()));
    });

    test('Leap year - 2020-02-01', () {
      final instant = Instant(2020, 2);
      expect(instant.sinceEpoch, Timespan.fromMilliseconds(DateTime.utc(2020, 2).millisecondsSinceEpoch.toDouble()));
    });

    test('Leap year - 2020-03-01', () {
      final instant = Instant(2020, 3);
      expect(instant.sinceEpoch, Timespan.fromMilliseconds(DateTime.utc(2020, 3).millisecondsSinceEpoch.toDouble()));
    });

    test('Leap year - 2020-03-14 13:34:54Z', () {
      final instant = Instant(2020, 03, 14, 13, 34, 54);
      expect(instant.sinceEpoch,
          Timespan.fromMilliseconds(DateTime.utc(2020, 03, 14, 13, 34, 54).millisecondsSinceEpoch.toDouble()));
    });

    test('Leap year - 2020-03-14 23:34:54Z', () {
      final instant = Instant(2020, 03, 14, 23, 34, 54);
      expect(instant.sinceEpoch,
          Timespan.fromMilliseconds(DateTime.utc(2020, 03, 14, 23, 34, 54).millisecondsSinceEpoch.toDouble()));
    });

    test('Non leap year - 2021-01-01', () {
      final instant = Instant(2021);
      expect(instant.sinceEpoch, Timespan.fromMilliseconds(DateTime.utc(2021).millisecondsSinceEpoch.toDouble()));
    });

    test('Non leap year - 2021-02-01', () {
      final instant = Instant(2021, 2);
      expect(instant.sinceEpoch, Timespan.fromMilliseconds(DateTime.utc(2021, 2).millisecondsSinceEpoch.toDouble()));
    });

    test('Non leap year - 2013-11-23 22:33Z', () {
      final instant = Instant(2013, 11, 23, 22, 33);
      expect(instant.sinceEpoch,
          Timespan.fromMilliseconds(DateTime.utc(2013, 11, 23, 22, 33).millisecondsSinceEpoch.toDouble()));
    });

    test('Non leap year - 2013-11-23 13:33Z', () {
      final instant = Instant(2013, 11, 23, 13, 33);
      expect(instant.sinceEpoch,
          Timespan.fromMilliseconds(DateTime.utc(2013, 11, 23, 13, 33).millisecondsSinceEpoch.toDouble()));
    });

    test('Non leap year - 1999-01-01', () {
      final instant = Instant(1999);
      expect(instant.sinceEpoch, Timespan.fromMilliseconds(DateTime.utc(1999).millisecondsSinceEpoch.toDouble()));
    });

    test('Leap year - 2000-01-01', () {
      final instant = Instant(2000);
      expect(instant.sinceEpoch, Timespan.fromMilliseconds(DateTime.utc(2000).millisecondsSinceEpoch.toDouble()));
    });

    test('1969-01-01', () {
      final instant = Instant(1969);
      expect(instant.sinceEpoch, Timespan.fromMilliseconds(DateTime.utc(1969).millisecondsSinceEpoch.toDouble()));
    });

    test('1960-01-01 04:56Z', () {
      final instant = Instant(1969, 1, 1, 4, 56);
      expect(instant.sinceEpoch,
          Timespan.fromMilliseconds(DateTime.utc(1969, 1, 1, 4, 56).millisecondsSinceEpoch.toDouble()));
    });

    test('1600-03-12', () {
      final instant = Instant(1600, 3, 12);
      expect(
          instant.sinceEpoch, Timespan.fromMilliseconds(DateTime.utc(1600, 3, 12).millisecondsSinceEpoch.toDouble()));
    });

    test('-4713-11-24 12:00', () {
      final instant = Instant(-4713, 11, 24, 12);
      expect(instant.sinceEpoch,
          Timespan.fromMilliseconds(DateTime.utc(-4713, 11, 24, 12).millisecondsSinceEpoch.toDouble()));
    });
  });

  group('Julian dates', () {
    test('Julian day - 2021-05-09', () {
      final instant = Instant(2021, 05, 09);
      expect(instant.julianDay, 2459343.5);
    });

    test('Julian day - 2021-05-09 12:00Z', () {
      final instant = Instant(2021, 05, 09, 12);
      expect(instant.julianDay, 2459344.0);
    });

    test('Julian day - 2021-05-09 15:13Z', () {
      final instant = Instant(2021, 05, 09, 15, 13);
      expect(instant.julianDay, 2459344.1340277777);
    });

    test('Julian day - 1999', () {
      final instant = Instant(1999);
      expect(instant.julianDay, 2451179.5);
    });

    test('Julian day - J2000', () {
      final instant = Instant(2000);
      expect(instant.julianDay, 2451544.5);
    });

    test('Julian day - 1400', () {
      final instant = Instant(1400);
      expect(instant.julianDay, 2232407.5);
    });

    test('Julian day - 1000', () {
      final instant = Instant(1000);
      expect(instant.julianDay, 2086307.5);
    });
  });
}
