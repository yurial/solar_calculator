import 'dart:math';

import 'julianDate.dart';

extension DoubleExtensions on double {
  /// Corrects for very large angles.
  ///
  /// Because astronomical calculations generate very large angles it is necessary to reduce such angles to be between 0 and 360 degrees.
  double correctDegreesForLargeAngles() {
    var value = this % 360;
    if (value < 0) value += 360;
    return value;
  }

  /// Converts this [double] degrees to radians.
  double toRadians() => this * (pi / 180);

  /// Converts this [double] radians to degrees.
  double toDegrees() => this * (180 / pi);
}

extension DateTimeExtension on DateTime {
  /// Is this [DateTime] a Julian date.
  ///
  /// Pope Gregory introduced the Gregorian calendar in October 1582 when the calendar had drifted 10 days.
  /// Dates prior to October 4, 1582 are Julian dates and dates after October 15, 1582 are Gregorian dates.
  /// Any date in the gap is invalid on the Gregorian calendar.
  bool get isJulianDate => compareTo(DateTime(1582, 10, 14)) <= 0;

  /// Corresponding midnight time in UTC of this [DateTime].
  DateTime get midnightUtc {
    var utc = toUtc();
    return DateTime.utc(utc.year, utc.month, utc.day);
  }

  /// Corresponding noon time in UTC of this [DateTime].
  DateTime get noonUtc {
    var utc = toUtc();
    return DateTime.utc(utc.year, utc.month, utc.day, 12);
  }

  /// The time of this [DateTime] as [Duration].
  Duration get time => Duration(
      hours: hour,
      minutes: minute,
      seconds: second,
      milliseconds: millisecond,
      microseconds: microsecond);

  /// Is this [DateTime] in a leap year.
  ///
  /// In the Gregorian calendar, three criteria must be taken into account to identify leap years:
  /// - he year must be evenly divisible by 4;
  /// - if the year can also be evenly divided by 100, it is not a leap year;
  /// - unless the year is also evenly divisible by 400. Then it is a leap year.
  bool get isLeapYear => (year % 4 == 0 && year % 100 != 0) || year % 400 == 0;

  /// The day of year of this [DateTime].
  int get dayOfYear {
    var k = (isLeapYear ? 1 : 2);
    return ((275 * month) / 9).floor() -
        (k * ((month + 9) / 12).floor()) +
        day -
        30;
  }

  /// The corresponding [JulianDate] of this [DateTime].
  JulianDate get julianDate => JulianDate.fromDateTime(this);
}

extension DurationExtension on Duration {
  /// The total number of days spanned by this [Duration], expressed in whole and fractional days.
  double get totalDays => inMicroseconds / Duration.microsecondsPerDay;

  /// The total number of hours spanned by this [Duration], expressed in whole and fractional hours.
  double get totalHours => inMicroseconds / Duration.microsecondsPerHour;

  /// The total number of minutes spanned by this [Duration], expressed in whole and fractional minutes.
  double get totalMinutes => inMicroseconds / Duration.microsecondsPerMinute;

  /// The total number of seconds spanned by this [Duration], expressed in whole and fractional seconds.
  double get totalSeconds => inMicroseconds / Duration.microsecondsPerSecond;

  /// The total number of milliseconds spanned by this [Duration], expressed in whole and fractional milliseconds.
  double get totalMilliseconds =>
      inMicroseconds / Duration.microsecondsPerMillisecond;
}
