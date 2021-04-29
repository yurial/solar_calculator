import 'angle.dart';
import '../privateExtensions.dart';

class HourAngle {
  late final int hours;
  late final int minutes;
  late final double seconds;

  HourAngle({this.hours = 0, this.minutes = 0, this.seconds = 0});

  HourAngle.fromAngle(Angle angle) {
    _initializeFromDegrees(angle.degrees);
  }

  HourAngle.fromDegrees(double degrees) {
    _initializeFromDegrees(degrees);
  }

  HourAngle.fromRadians(double radians) {
    _initializeFromDegrees(radians.toDegrees());
  }

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
