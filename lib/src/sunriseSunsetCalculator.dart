import 'dart:math';

import 'package:solar_calculator/src/celestialBodies/sun.dart';

import 'timespan.dart';
import 'julianDate.dart';
import 'extensions.dart';

class SunriseSunsetCalculator {
  /// Zenith distance of the Sun used as a reference.
  ///
  /// It is the angular distance of the Sun from the zenith. It is 90° minus the Sun altitude above the horizon.
  ///
  /// For the special case of sunrise and sunset, the zenith is set to 90.833 degrees (the approximate correction for
  /// atmospheric refraction at sunrise and sunset, and the size of the solar disk).
  final double sunZenithDistance;

  final DateTime date;

  final double latitude;
  final double longitude;

  SunriseSunsetCalculator(this.date, this.latitude, this.longitude, {this.sunZenithDistance = 90.833});

  double _calculateSunriseMinutes(JulianDate julianDate) {
    var sun = Sun(julianDate);

    var hourAngle = _calculateSolarHourAngleForSunriseSunset(sun.equatorialPosition.declination);

    // 1 degree of longitude = 4 minutes
    // 720 = noon time in minutes
    return 720 - 4 * (longitude + hourAngle) - sun.equationOfTime;
  }

  double _calculateSunsetMinutes(JulianDate julianDate) {
    var sun = Sun(julianDate);

    var hourAngle = _calculateSolarHourAngleForSunriseSunset(sun.equatorialPosition.declination);

    // 1 degree of longitude = 4 minutes
    // 720 = noon time in minutes
    return 720 - 4 * (longitude - hourAngle) - sun.equationOfTime;
  }

  DateTime calculateSunTransitTime() {
    var julianDate = JulianDate.fromDateTime(date.midnightUtc);

    var tNoon = (julianDate - Timespan.fromDays(longitude / 360));
    var solarNoonOffset = 720 - (longitude * 4) - Sun(tNoon).equationOfTime; // in minutes

    tNoon = (julianDate + Timespan.fromMinutes(solarNoonOffset));
    var solarNoonUtc = 720 - (longitude * 4) - Sun(tNoon).equationOfTime; // in minutes

    return date.midnightUtc.add(Timespan.fromMinutes(solarNoonUtc));
  }

  DateTime calculateSunrise() {
    var julianDate = JulianDate.fromDateTime(date.midnightUtc);

    var sunriseTime = _calculateSunriseMinutes(julianDate);
    var newSunriseTime =
        sunriseTime.isNaN ? double.nan : _calculateSunriseMinutes(julianDate + Timespan.fromMinutes(sunriseTime));

    if (newSunriseTime.isNaN) {
      // No sunrise found
      var dayOfYear = julianDate.gregorianDateTime.dayOfYear;

      if ((latitude > 66.4 && dayOfYear > 79 && dayOfYear < 267) ||
          (latitude < -66.4 && (dayOfYear < 83 || dayOfYear > 263))) {
        //previous sunrise/next sunset
        return _calculatePreviousSunrise();
      } else {
        //previous sunset/next sunrise
        return _calculateNextSunrise();
      }
    } else {
      return julianDate.gregorianDateTime.add(Timespan.fromMinutes(newSunriseTime));
    }
  }

  DateTime calculateSunset() {
    var julianDate = JulianDate.fromDateTime(date.midnightUtc);

    var sunsetTime = _calculateSunsetMinutes(julianDate);
    var newSunsetTime =
        sunsetTime.isNaN ? double.nan : _calculateSunsetMinutes(julianDate + Timespan.fromMinutes(sunsetTime));

    if (newSunsetTime.isNaN) {
      // No sunset found
      var dayOfYear = julianDate.gregorianDateTime.dayOfYear;

      if ((latitude > 66.4 && dayOfYear > 79 && dayOfYear < 267) ||
          (latitude < -66.4 && (dayOfYear < 83 || dayOfYear > 263))) {
        //previous sunrise/next sunset
        return _calculateNextSunset();
      } else {
        //previous sunset/next sunrise
        return _calculatePreviousSunset();
      }
    } else {
      return julianDate.gregorianDateTime.add(Timespan.fromMinutes(newSunsetTime));
    }
  }

  DateTime _calculateNextSunrise() => _calculateNextEvent(_calculateSunriseMinutes);

  DateTime _calculatePreviousSunrise() => _calculatePreviousEvent(_calculateSunriseMinutes);

  DateTime _calculateNextSunset() => _calculateNextEvent(_calculateSunsetMinutes);

  DateTime _calculatePreviousSunset() => _calculatePreviousEvent(_calculateSunsetMinutes);

  DateTime _calculatePreviousEvent(double Function(JulianDate julianDate) getEvent) {
    var julianDate = JulianDate.fromDateTime(date.midnightUtc);
    var time = getEvent(julianDate);

    while (time.isNaN) {
      julianDate -= Duration(days: 1);
      time = getEvent(julianDate);
    }

    return julianDate.gregorianDateTime.midnightUtc.add(Timespan.fromMinutes(time));
  }

  DateTime _calculateNextEvent(double Function(JulianDate julianDate) getEvent) {
    var julianDate = JulianDate.fromDateTime(date.midnightUtc);
    var time = getEvent(julianDate);

    while (time.isNaN) {
      julianDate += Duration(days: 1);
      time = getEvent(julianDate);
    }

    return julianDate.gregorianDateTime.midnightUtc.add(Timespan.fromMinutes(time));
  }

  /// Gets the solar hour angle in degrees for sunset and sunrise calculation, corrected for atmospheric refraction,
  /// for the given [sunDeclination].
  ///
  /// Observing the sun from earth, the solar hour angle is an expression of time, expressed in angular measurement, usually degrees,
  /// from solar noon. At solar noon the hour angle is 0.000 degree, with the time before solar noon expressed as negative degrees, and
  /// the local time after solar noon expressed as positive degrees. For example, at 10:30 AM local apparent time
  /// the hour angle is −22.5° (15° per hour times 1.5 hours before noon).
  ///
  /// The cosine of the hour angle (cos(h)) is used to calculate the solar zenith angle. At solar noon, h = 0.000 so cos(h)=1,
  /// and before and after solar noon the cos(± h) term = the same value for morning (negative hour angle) or afternoon (positive hour angle),
  /// i.e. the sun is at the same altitude in the sky at 11:00AM and 1:00PM solar time, etc.
  double _calculateSolarHourAngleForSunriseSunset(double sunDeclination) =>
      acos((cos(sunZenithDistance.toRadians()) / (cos(latitude.toRadians()) * cos(sunDeclination.toRadians()))) -
              (tan(latitude.toRadians()) * tan(sunDeclination.toRadians())))
          .toDegrees();
}
