import 'package:solar_calculator/src/math.dart';

import 'timespan.dart';
import 'extensions.dart';

/// Represents a Julian date.
///
/// The Julian date of any instant is the Julian day number plus the fraction of a day since the preceding noon in
/// Universal Time. Julian dates are expressed as a Julian day number with a decimal fraction added.
///
/// The Julian day number (JDN) is the number assigned to a whole solar day in the Julian day count starting from
/// 1 Jan -4712 at noon Universal time (January 1, 4713 BC at noon Universal Time).
class JulianDate {
  DateTime? _gregorianDateTime;

  /// The corresponding Gregorian [DateTime] of this [JulianDate].
  DateTime get gregorianDateTime => _gregorianDateTime ??= toDateTime();

  /// The Julian day.
  late final double julianDay;

  /// The number of Julian centuries since the J2000.0 epoch.
  ///
  /// Since a Julian year counts exactly 365.25 Julian days, a Julian century counts 36,525.0 Julian days.
  ///
  /// The J2000.0 epoch is precisely Julian date 2451545.0 TT (Terrestrial Time), or January 1, 2000, noon TT.
  /// This is equivalent to January 1, 2000, 11:59:27.816 TAI or January 1, 2000, 11:58:55.816 UTC.
  double get julianCenturies => (julianDay - 2451545.0) / 36525.0;

  /// Creates a Julian date with the given [julianDay].
  JulianDate(this.julianDay);

  /// Creates the corresponding [JulianDate] of the given [dateTime].
  JulianDate.fromDateTime(DateTime dateTime) {
    _gregorianDateTime = dateTime;

    var utcDate = dateTime.toUtc();

    var year = utcDate.year;
    var month = utcDate.month;

    var day = utcDate.day +
        (utcDate.hour / Duration.hoursPerDay) +
        (utcDate.minute / Duration.minutesPerDay) +
        (utcDate.second +
                (utcDate.millisecond / Duration.millisecondsPerSecond) +
                (utcDate.microsecond / Duration.microsecondsPerSecond)) /
            Duration.secondsPerDay;

    var b = 0; // Julian calendar default

    // If the date is Jan or Feb then the date is considered to be in the 13th or 14th month of the preceding year for calculation purposes.
    if (month <= 2) {
      year -= 1;
      month += 12;
    }

    if (!utcDate.isJulianDate) // convert to Gregorian calendar
    {
      var a = (year / 100).floor();
      b = 2 - a + (a / 4).floor();
    }

    julianDay = (365.25 * (year + 4716)).floor() + (30.6001 * (month + 1)).floor() + day + b - 1524.5;
  }

  /// Convert this [JulianDate] to a Gregorian [DateTime].
  DateTime toDateTime() {
    var a;

    final modfJulianDay = modf(julianDay + 0.5);
    // var z = (julianDay + 0.5).floor(); // Integer part
    // var f = (julianDay + 0.5) - z; // Fractional part
    if (modfJulianDay.integerPart < 2299161) {
      a = modfJulianDay.integerPart;
    } else {
      final alpha = ((modfJulianDay.integerPart - 1867216.25) / 36524.25).floor();
      a = modfJulianDay.integerPart + 1 + alpha - (alpha / 4).floor();
    }
    final b = a + 1524;
    final c = ((b - 122.1) / 365.25).floor();
    final d = (365.25 * c).floor();
    final e = ((b - d) / 30.6001).floor();

    double day = b - d - (30.6001 * e).floor() + modfJulianDay.fractionalPart;
    final month = (e < 14) ? e - 1 : e - 13;
    final year = (month > 2) ? c - 4716 : c - 4715;

    final decimalPart = day - day.truncate();
    final hours = decimalPart * 24;

    Duration durationToAdd = Timespan.fromHours(hours);

    return DateTime.utc(year, month, day.truncate()).add(durationToAdd);
  }

  JulianDate operator +(Duration duration) {
    _gregorianDateTime = _gregorianDateTime?.add(duration);
    return JulianDate(julianDay + duration.totalDays);
  }

  JulianDate operator -(Duration duration) {
    _gregorianDateTime = _gregorianDateTime?.subtract(duration);
    return JulianDate(julianDay - duration.totalDays);
  }

  // JulianDate operator +(Duration duration) => JulianDate.fromDateTime(gregorianDateTime.add(duration));

  // JulianDate operator -(Duration duration) => JulianDate.fromDateTime(gregorianDateTime.subtract(duration));
}
