import 'dart:math';

import 'package:solar_calculator/src/timespan.dart';

import 'calculatorCores/calculatorCore.dart';
import 'coordinateSystems/equatorialCoordinate.dart';
import 'coordinateSystems/horizontalCoordinate.dart';
import 'julianDate.dart';
import 'privateExtensions.dart';
import 'publicExtensions.dart';
import 'calculatorCores/sunriseSunsetCalculator.dart';
import 'twilight.dart';

/// Calculates the apparent position of the sun, sunrise, sunset, noon and the different twilights times for a given date and position.
class SolarCalculator {
  final DateTime date;

  SolarCalculator(this.date);

  /// Gets the time offset from the given [timezone], for the given [longitude].
  ///
  /// [longitude] is given in degrees, positive for east, negative for west.
  ///
  /// [timezone] is given in hours from UTC.
  // Duration getTimeOffset(double longitude, [int timezone = 0]) {
  //   _SolarCalculatorCore core = _SolarCalculatorCore(JulianDate(date.julianDate));
  //   print(core.equationOfTime + (4 * longitude) - (60 * timezone));
  //   return _CDuration.fromMinutes(core.equationOfTime + (4 * longitude) - (60 * timezone));
  // }

  /// Gets if the position given by [latitude] and [longitude] is in darkness based on the end of the nautical twilight.
  bool getIfHoursOfDarkness(double latitude, double longitude) {
    var sunHorizontalPosition = getSunHorizontalPosition(latitude, longitude);

    var solarZenith = 90 - sunHorizontalPosition.elevation;
    return (solarZenith > 102.0);
  }

  /// Get the noon time in UTC for the given [longitude].
  ///
  /// [longitude] is given in degrees, positive for east, negative for west.
  DateTime getNoon(double longitude) {
    var julianDate = JulianDate.fromDateTime(date.midnightUtc);

    var tNoon = (julianDate - Timespan.fromDays(longitude / 360));

    var core = CalculatorCore(tNoon);
    var solNoonOffset = 720 - (longitude * 4) - core.equationOfTime; // in minutes

    var newT = (julianDate + Timespan.fromMinutes(solNoonOffset));
    var core2 = CalculatorCore(newT);

    var solNoonUtc = 720 - (longitude * 4) - core2.equationOfTime; // + (timezone * 60); // in minutes
    // var solNoonLocal = solNoonUtc + date.timeZoneOffset.inMinutes;

    return date.midnightUtc.add(Timespan.fromMinutes(solNoonUtc));
    // while (solNoonLocal < 0.0) {
    // 	solNoonLocal += 1440.0;
    // }
    // while (solNoonLocal >= 1440.0) {
    // 	solNoonLocal -= 1440.0;
    // }

    // return solNoonLocal
  }

  /// Get the sunrise time in UTC for the given [latitude] and [longitude].
  ///
  /// [latitude] is given in degrees, positive for north, negative for south.
  ///
  /// [longitude] is given in degrees, positive for east, negative for west.
  DateTime getSunrise(double latitude, double longitude) =>
      SunriseSunsetCalculator(date, latitude, longitude).getSunrise();

  /// Get the sunset time in UTC for the given [latitude] and [longitude].
  ///
  /// [latitude] is given in degrees, positive for north, negative for south.
  ///
  /// [longitude] is given in degrees, positive for east, negative for west.
  DateTime getSunset(double latitude, double longitude) =>
      SunriseSunsetCalculator(date, latitude, longitude).getSunset();

  /// Gets the morning astronomical twilight in UTC for the given [latitude] and [longitude].
  ///
  /// [latitude] is given in degrees, positive for north, negative for south.
  ///
  /// [longitude] is given in degrees, positive for east, negative for west.
  ///
  /// The astronomical twilight is when the centre of the Sun is between 12° and 18° below the sensible horizon. Astronomical twilight is
  /// often considered to be "complete darkness".
  /// Sixth magnitude stars are no longer visible to the naked eye under good conditions.
  Twilight getMorningAstronomicalTwilight(double latitude, double longitude) {
    var begining = SunriseSunsetCalculator(date, latitude, longitude, sunZenithDistance: 108.0).getSunrise();
    var ending = SunriseSunsetCalculator(date, latitude, longitude, sunZenithDistance: 102.0).getSunrise();
    return Twilight(begining, ending);
  }

  /// Gets the morning nautical twilight in UTC for the given [latitude] and [longitude].
  ///
  /// [latitude] is given in degrees, positive for north, negative for south.
  ///
  /// [longitude] is given in degrees, positive for east, negative for west.
  ///
  /// The nautical twilight is when the centre of the Sun is between 6° and 12° below the sensible horizon.
  /// It may now be possible to discern the sea horizon and it is no longer dark for normal practical purposes.
  Twilight getMorningNauticalTwilight(double latitude, double longitude) {
    var begining = SunriseSunsetCalculator(date, latitude, longitude, sunZenithDistance: 102.0).getSunrise();
    var ending = SunriseSunsetCalculator(date, latitude, longitude, sunZenithDistance: 96.0).getSunrise();
    return Twilight(begining, ending);
  }

  /// Gets the the morning civil twilight in UTC for the given [latitude] and [longitude].
  ///
  /// [latitude] is given in degrees, positive for north, negative for south.
  ///
  /// [longitude] is given in degrees, positive for east, negative for west.
  ///
  /// The civil twillight is when the centre of the Sun is between 0° 50' and 6° below the sensible horizon.
  /// Illumination is such that it is possible to carry out day time tasks without additional artificial lighting.
  /// Large terrestrial objects can be now distinguished. The sea horizon is clearly defined and the brightest stars and planets are still visible.
  Twilight getMorningCivilTwilight(double latitude, double longitude) {
    var begining = SunriseSunsetCalculator(date, latitude, longitude, sunZenithDistance: 96.0).getSunrise();
    var ending = SunriseSunsetCalculator(date, latitude, longitude).getSunrise();
    return Twilight(begining, ending);
  }

  /// Gets the evening astronomical twilight in UTC for the given [latitude] and [longitude].
  ///
  /// [latitude] is given in degrees, positive for north, negative for south.
  ///
  /// [longitude] is given in degrees, positive for east, negative for west.
  ///
  /// The astronomical twilight is when the centre of the Sun is between 12° and 18° below the sensible horizon. Astronomical twilight is
  /// often considered to be "complete darkness".
  /// Sixth magnitude stars are now visible to the naked eye under good conditions.
  Twilight getEveningAstronomicalTwilight(double latitude, double longitude) {
    var begining = SunriseSunsetCalculator(date, latitude, longitude, sunZenithDistance: 102.0).getSunset();
    var ending = SunriseSunsetCalculator(date, latitude, longitude, sunZenithDistance: 108.0).getSunset();
    return Twilight(begining, ending);
  }

  /// Gets the evening nautical twilight in UTC for the given [latitude] and [longitude].
  ///
  /// [latitude] is given in degrees, positive for north, negative for south.
  ///
  /// [longitude] is given in degrees, positive for east, negative for west.
  ///
  /// The nautical twilight is when the centre of the Sun is between 6° and 12° below the sensible horizon.
  /// The sea horizon is no longer visible and it can be considered to be dark for normal practical purposes.
  Twilight getEveningNauticalTwilight(double latitude, double longitude) {
    var begining = SunriseSunsetCalculator(date, latitude, longitude, sunZenithDistance: 96.0).getSunset();
    var ending = SunriseSunsetCalculator(date, latitude, longitude, sunZenithDistance: 102.0).getSunset();
    return Twilight(begining, ending);
  }

  /// Gets the evening civil twilight in UTC for the given [latitude] and [longitude].
  ///
  /// [latitude] is given in degrees, positive for north, negative for south.
  ///
  /// [longitude] is given in degrees, positive for east, negative for west.
  ///
  /// The civil twillight is when the centre of the Sun is between 0° 50' and 6° below the sensible horizon.
  /// Large terrestrial objects can be seen but no detail can be distinguished. The sea horizon is clearly defined and
  /// the brightest stars and planets are visible.
  Twilight getEveningCivilTwilight(double latitude, double longitude) {
    var begining = SunriseSunsetCalculator(date, latitude, longitude).getSunset();
    var ending = SunriseSunsetCalculator(date, latitude, longitude, sunZenithDistance: 96.0).getSunset();
    return Twilight(begining, ending);
  }

  /// Gets the position of the Sun in the Equatorial Coordinate System.
  ///
  /// Its declination angle varies from -23.44° at the (northern hemisphere) winter solstice, through 0° at the vernal equinox,
  /// to +23.44° at the summer solstice.
  /// The variation in solar declination is the astronomical description of the sun going south (in the northern hemisphere)
  /// for the winter.
  EquatorialCoordinate getSunEquatorialPosition() => CalculatorCore(date.julianDate).sunPosition;

  /// Gets the position of the Sun in the Horizontal Coordinate System.
  HorizontalCoordinate getSunHorizontalPosition(double latitude, double longitude) {
    var core = CalculatorCore(date.julianDate);

    var solarTimeFix = core.equationOfTime + (4.0 * longitude); // - 60.0 * zone
    // var earthRadVec = calcSunRadVector(T)
    var utcTime = date.toUtc();
    var time = Duration(
        hours: utcTime.hour,
        minutes: utcTime.minute,
        seconds: utcTime.second,
        milliseconds: utcTime.millisecond,
        microseconds: utcTime.microsecond);
    var trueSolarTime = time.totalMinutes + solarTimeFix;

    while (trueSolarTime > Duration.minutesPerDay) {
      trueSolarTime -= Duration.minutesPerDay;
    }

    var hourAngle = (trueSolarTime / 4.0) - 180.0;
    if (hourAngle < -180) hourAngle += 360.0;

    var latitudeRadians = latitude.toRadians();
    var sunDeclinationRadians = core.sunPosition.declination.toRadians();
    var haRad = hourAngle.toRadians();

    var csz = (sin(latitudeRadians) * sin(sunDeclinationRadians)) +
        (cos(latitudeRadians) * cos(sunDeclinationRadians) * cos(haRad));

    if (csz > 1.0) {
      csz = 1.0;
    } else if (csz < -1.0) csz = -1.0;

    var zenithRadians = acos(csz);
    var zenith = zenithRadians.toDegrees();
    var azDenom = cos(latitudeRadians) * sin(zenithRadians);

    double azimuth;

    if (azDenom.abs() > 0.001) {
      var azRad = ((sin(latitudeRadians) * cos(zenithRadians)) - sin(sunDeclinationRadians)) / azDenom;

      if (azRad.abs() > 1.0) azRad = (azRad < 0) ? -1.0 : 1.0;

      azimuth = 180.0 - acos(azRad).toDegrees();

      if (hourAngle > 0.0) azimuth = -azimuth;
    } else {
      azimuth = (latitude > 0.0) ? 180.0 : 0.0;
    }

    if (azimuth < 0.0) azimuth += 360.0;

    var exoatmElevation = 90.0 - zenith;

    // Atmospheric Refraction correction
    var refractionCorrection = _getAtmosphericRefractionCorrection(exoatmElevation);

    var solarZen = zenith - refractionCorrection;
    var elevation = 90.0 - solarZen;

    return HorizontalCoordinate(azimuth, elevation);
  }

  /// Gets the approximate Atmospheric Refraction Correction in degrees for the given [elevation].
  ///
  /// https://www.esrl.noaa.gov/gmd/grad/solcalc/calcdetails.html
  double _getAtmosphericRefractionCorrection(double elevation) {
    if (elevation > 85.0) {
      return 0.0;
    } else {
      var te = tan(elevation.toRadians());
      double correction;

      if (elevation > 5.0) {
        correction = (58.1 / te) - (0.07 / pow(te, 3)) + (0.000086 / pow(te, 5));
      } else if (elevation > -0.575) {
        correction = 1735.0 -
            (518.2 * elevation) +
            (103.4 * pow(elevation, 2)) -
            (12.79 * pow(elevation, 3)) +
            (0.711 * pow(elevation, 4));
        // correction = 1735.0 + elevation * (-518.2 + elevation * (103.4 + elevation * (-12.79 + elevation * 0.711)));
      } else {
        correction = -20.774 / te;
      }

      return correction / 3600.0;
    }
  }
}
