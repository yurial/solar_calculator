import 'dart:math';

import 'calculatorCore.dart';
import '../timespan.dart';
import '../julianDate.dart';
import '../privateExtensions.dart';
import '../publicExtensions.dart';

class SunriseSunsetCalculator {
  /// Zenith distance of the Sun used as a reference.
  ///
  /// It is the angular distance of the Sun from the zenith. It is 90° minus the Sun altitude above the horizon.
  final double sunZenithDistance;

  final DateTime date;

  final double latitude;
  final double longitude;

  SunriseSunsetCalculator(this.date, this.latitude, this.longitude, {this.sunZenithDistance = 90.833});

  double _getSunriseMinutes(JulianDate julianDate) {
    var core = CalculatorCore(julianDate);

    var equationOfTime = core.equationOfTime;
    var sunDeclination = core.sunPosition.declination;
    var hourAngle = _getSolarHourAngleForSunriseSunset(sunDeclination);

    return 720 - 4 * (longitude + hourAngle) - equationOfTime;
  }

  double _getSunsetMinutes(JulianDate julianDate) {
    var core = CalculatorCore(julianDate);

    var equationOfTime = core.equationOfTime;
    var sunDeclination = core.sunPosition.declination;
    var hourAngle = _getSolarHourAngleForSunriseSunset(sunDeclination);

    return 720 - 4 * (longitude - hourAngle) - equationOfTime;
  }

  DateTime getSunrise() {
    var julianDate = JulianDate.fromDateTime(date.midnightUtc);

    // double jd = julianDate;

    var sunriseTime = _getSunriseMinutes(julianDate);
    var newSunriseTime =
        sunriseTime.isNaN ? double.nan : _getSunriseMinutes(julianDate + Timespan.fromMinutes(sunriseTime));

    if (newSunriseTime.isNaN) {
      // No sunrise found
      var azimuth = -1.0;
      var time = 0.0;

      var dayOfYear = date.midnightUtc.dayOfYear;

      if ((latitude > 66.4 && dayOfYear > 79 && dayOfYear < 267) ||
          (latitude < -66.4 && (dayOfYear < 83 || dayOfYear > 263))) {
        //previous sunrise/next sunset
        return _getPreviousSunrise();
      } else {
        //previous sunset/next sunrise
        return _getNextSunrise();
      }
    } else {
      // var time = newSunriseTime;

      // var julianCenturies = (julianDate + _CDuration.fromMinutes(newSunriseTime))
      //     .julianCenturies; //_getJulianCenturies(julianDate + (newSunriseUtc / Duration.minutesPerDay));

      // TODO Calculate Azimut and Elevation
      // var riseT = calcTimeJulianCent(JD + newTimeUTC/1440.0)
      // var riseAzEl = calcAzEl(riseT, timeLocal, latitude, longitude, timezone)
      // var azimuth = riseAzEl.azimuth

      // if (time < 0.0 || time >= Duration.minutesPerDay) {
      //   var increment = (time < 0.0) ? 1 : -1;
      //   while (time < 0.0 || time >= Duration.minutesPerDay) {
      //     time += increment * Duration.minutesPerDay;
      //     julianDate -= increment;
      //   }
      // }

      return date.midnightUtc.add(Timespan.fromMinutes(newSunriseTime));
    }
  }

  DateTime getSunset() {
    var julianDate = JulianDate.fromDateTime(date.midnightUtc);

    var sunsetTime = _getSunsetMinutes(julianDate);
    var newSunsetTime =
        sunsetTime.isNaN ? double.nan : _getSunsetMinutes(julianDate + Timespan.fromMinutes(sunsetTime));

    if (newSunsetTime.isNaN) {
      // No sunset found
      var azimuth = -1.0;
      var time = 0.0;

      var dayOfYear = date.midnightUtc.dayOfYear;

      if ((latitude > 66.4 && dayOfYear > 79 && dayOfYear < 267) ||
          (latitude < -66.4 && (dayOfYear < 83 || dayOfYear > 263))) {
        //previous sunrise/next sunset
        return _getNextSunset();
      } else {
        //previous sunset/next sunrise
        return _getPreviousSunset();
      }
    } else {
      // var time = newSunriseTime;

      // var julianCenturies = (julianDate + CustomDuration.fromMinutes(newSunsetTime))
      //     .julianCenturies; //_getJulianCenturies(julianDate + (newSunriseUtc / Duration.minutesPerDay));

      // TODO Calculate Azimut and Elevation
      // var riseT = calcTimeJulianCent(JD + newTimeUTC/1440.0)
      // var riseAzEl = calcAzEl(riseT, timeLocal, latitude, longitude, timezone)
      // var azimuth = riseAzEl.azimuth

      // if (time < 0.0 || time >= Duration.minutesPerDay) {
      //   var increment = (time < 0.0) ? 1 : -1;
      //   while (time < 0.0 || time >= Duration.minutesPerDay) {
      //     time += increment * Duration.minutesPerDay;
      //     julianDate -= increment;
      //   }
      // }

      return date.midnightUtc.add(Timespan.fromMinutes(newSunsetTime));
    }
  }

  DateTime _getNextSunrise() => _getNextEvent(_getSunriseMinutes);

  DateTime _getPreviousSunrise() => _getPreviousEvent(_getSunriseMinutes);

  DateTime _getNextSunset() => _getNextEvent(_getSunsetMinutes);

  DateTime _getPreviousSunset() => _getPreviousEvent(_getSunsetMinutes);

  DateTime _getPreviousEvent(double Function(JulianDate julianDate) getEvent) {
    var julianDate = JulianDate.fromDateTime(date.midnightUtc);
    var time = getEvent(julianDate);

    while (time.isNaN) {
      julianDate -= Duration(days: 1);
      time = getEvent(julianDate);
    }

    // var timeLocal = time + tz * 60.0
    // while ((timeLocal < 0.0) || (timeLocal >= 1440.0)) {
    // 	var incr = ((timeLocal < 0) ? 1 : -1)
    // 	timeLocal += (incr * 1440.0)
    // 	julianday -= incr
    // }

    return julianDate.toDateTime().midnightUtc.add(Timespan.fromMinutes(time));
  }

  DateTime _getNextEvent(double Function(JulianDate julianDate) getEvent) {
    var julianDate = JulianDate.fromDateTime(date.midnightUtc);
    var time = getEvent(julianDate);

    while (time.isNaN) {
      julianDate += Duration(days: 1);
      time = getEvent(julianDate);
    }

    // var timeLocal = time + tz * 60.0
    // while ((timeLocal < 0.0) || (timeLocal >= 1440.0)) {
    // 	var incr = ((timeLocal < 0) ? 1 : -1)
    // 	timeLocal += (incr * 1440.0)
    // 	julianday -= incr
    // }

    return julianDate.toDateTime().midnightUtc.add(Timespan.fromMinutes(time));
  }

  /// Get the solar hour angle in degrees for sunset and sunrise calculation, corrected for atmospheric refraction,
  /// for the given [latitude].
  ///
  /// For the special case of sunrise and sunset, the zenith is set to 90.833 degrees (the approximate correction for
  /// atmospheric refraction at sunrise and sunset, and the size of the solar disk).
  double _getSolarHourAngleForSunriseSunset(double sunDeclination) =>
      acos((cos(sunZenithDistance.toRadians()) / (cos(latitude.toRadians()) * cos(sunDeclination.toRadians()))) -
              (tan(latitude.toRadians()) * tan(sunDeclination.toRadians())))
          .toDegrees();
}
