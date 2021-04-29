import 'hourAngle.dart';
import '../privateExtensions.dart';

class Angle {
  late final double degrees;
  late final double radians;

  Angle({int degrees = 0, double minutes = 0, double seconds = 0}) {
    this.degrees = degrees + (minutes / 60) + (seconds / 3600);
    radians = this.degrees.toRadians();
  }

  Angle.fromDegrees(this.degrees) : radians = degrees.toRadians();

  Angle.fromRadians(this.radians) : degrees = radians.toDegrees();

  Angle.fromHourAngle(HourAngle angle) {
    degrees = (angle.hours + (angle.minutes / 60) + (angle.seconds / 3600)) * 15;
    radians = degrees.toRadians();
  }
}
