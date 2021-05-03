import '../extensions.dart';

/// Represents an angular measurement expressed in time.
class HourAngle {
  late final int arcHours;
  late final int arcMinutes;
  late final double arcSeconds;

  /// The corresponding angle decimal value in degrees.
  double get decimalDegrees =>
      (arcHours +
          (arcMinutes / Duration.minutesPerHour) +
          (arcSeconds / Duration.secondsPerHour)) *
      15;

  /// Creates an [HourAngle] from its decimal value in [degrees].
  HourAngle.fromDegrees(double degrees) {
    _initializeFromDegrees(degrees);
  }

  /// Creates an [HourAngle] from its decimal value in [radians].
  HourAngle.fromRadians(double radians) {
    _initializeFromDegrees(radians.toDegrees());
  }

  /// A string representation of this [HourAngle].
  ///
  /// In this representation, the number of seconds is represented with two decimal digits.
  @override
  String toString() =>
      '${arcHours}h ${arcMinutes}m ${arcSeconds.toStringAsFixed(2)}s';

  void _initializeFromDegrees(double degrees) {
    var d = (degrees < 0) ? degrees + 360 : degrees;
    d = (d / 15);

    arcHours = d.floor();

    d = (d - d.truncateToDouble()) * 60;

    arcMinutes = d.floor();

    d = (d - d.truncateToDouble()) * 60;

    arcSeconds = d;
  }
}
