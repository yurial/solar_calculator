import 'timespan.dart';
import 'privateExtensions.dart';
import 'publicExtensions.dart';

class JulianDate {
  /// The Julian date (JD) of any instant is the Julian day number plus the fraction of a day since the preceding noon in
  /// Universal Time. Julian dates are expressed as a Julian day number with a decimal fraction added.
  ///
  /// The Julian day number (JDN) is the number assigned to a whole solar day in the Julian day count starting from
  /// 1 Jan -4712 at noon Universal time (January 1, 4713 BC at noon Universal Time).
  late final double julianDate;

  /// Gets the number of Julian centuries since the J2000.0 epoch.
  ///
  /// Technically, it corresponds to the number of Julian centuries of 36525 ephemeris days from the epoch J2000.0.
  ///
  /// The J2000.0 epoch is precisely Julian date 2451545.0 TT (Terrestrial Time), or January 1, 2000, noon TT.
  /// This is equivalent to January 1, 2000, 11:59:27.816 TAI or January 1, 2000, 11:58:55.816 UTC.
  double get julianCenturies => (julianDate - 2451545.0) / 36525.0;

  JulianDate(this.julianDate);

  JulianDate.fromDateTime(DateTime dateTime) {
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

    // If the date is Jan or Feb then the date is the 13th or 14th month of the preceding year for calculation purposes.
    if (month <= 2) {
      year -= 1;
      month += 12;
    }

    if (!utcDate.isJulianDate) // convert to Gregorian calendar
    {
      var a = (year / 100).floor();
      b = 2 - a + (a / 4).floor();
    }

    julianDate = (365.25 * (year + 4716)).floor() + (30.6001 * (month + 1)).floor() + day + b - 1524.5;

    //-(this.timeZoneOffset.inHours / 24);
  }

  DateTime toDateTime() {
    var a;
    var z = (julianDate + 0.5).floor();
    var f = (julianDate + 0.5) - z;
    if (z < 2299161) {
      a = z;
    } else {
      var alpha = ((z - 1867216.25) / 36524.25).floor();
      a = z + 1 + alpha - (alpha / 4).floor();
    }
    var b = a + 1524;
    int c = ((b - 122.1) / 365.25).floor();
    var d = (365.25 * c).floor();
    int e = ((b - d) / 30.6001).floor();

    double day = b - d - (30.6001 * e).floor() + f;
    var month = (e < 14) ? e - 1 : e - 13;
    var year = (month > 2) ? c - 4716 : c - 4715;

    var decimalPart = day - day.truncate();
    var hours = decimalPart * 24;

    Duration durationToAdd = Timespan.fromHours(hours);

    return DateTime.utc(year, month, day.truncate()).add(durationToAdd);
  }

  JulianDate operator +(Duration duration) => JulianDate(julianDate + duration.totalDays);

  JulianDate operator -(Duration duration) => JulianDate(julianDate - duration.totalDays);
}
