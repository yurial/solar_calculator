import '../privateExtensions.dart';

/// Represents an angular measurement expressed in time.
class HourAngle {
  late final int hours;
  late final int minutes;
  late final double seconds;

  /// The corresponding angle decimal value in degrees.
  double get decimalDegrees => (hours + (minutes / Duration.minutesPerHour) + (seconds / Duration.secondsPerHour)) * 15;

  // HourAngle({this.hours = 0, this.minutes = 0, this.seconds = 0});

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
  String toString() => '${hours}h ${minutes}m ${seconds.toStringAsFixed(2)}s';

  void _initializeFromDegrees(double degrees) {
    var d = (degrees < 0) ? degrees + 360 : degrees;
    d = (d / 15);

    hours = d.floor();

    d = (d - d.truncateToDouble()) * 60;

    minutes = d.floor();

    d = (d - d.truncateToDouble()) * 60;

    seconds = d;
  }
}
