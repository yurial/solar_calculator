import 'dart:math';

extension DoubleExtensions on double {
  /// Corrects for very large angles.
  /// Because planetary orbit calculations generate very large angles we need to reduce such angles to between 0 and 360 degrees.
  double get correctedDegrees {
    var value = this % 360;
    if (value < 0) value += 360;
    return value;
  }

  /// Converts this [Double] degrees to radians.
  double toRadians() => this * (pi / 180);

  /// Converts this [Double] radians to degrees.
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
}
