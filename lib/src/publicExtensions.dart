import 'julianDate.dart';

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
  double get totalMilliseconds => inMicroseconds / Duration.microsecondsPerMillisecond;
}

extension DateTimeExtension on DateTime {
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
    return ((275 * month) / 9).floor() - (k * ((month + 9) / 12).floor()) + day - 30;
  }

  /// The corresponding [JulianDate] of this [DateTime].
  JulianDate get julianDate => JulianDate.fromDateTime(this);
}
