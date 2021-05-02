import 'package:solar_calculator/src/celestialBodies/sun.dart';

import 'timespan.dart';
import 'coordinateSystems/equatorialCoordinate.dart';
import 'coordinateSystems/horizontalCoordinate.dart';
import 'julianDate.dart';
import 'extensions.dart';
import 'sunriseSunsetCalculator.dart';
import 'twilight.dart';

/// Calculates the apparent position of the Sun, sunrise, sunset, noon and the different twilights times for a given moment
/// in time and position on Earth.
///
/// The position is given by:
/// - the latitude in degrees, positive for north, negative for south;
/// - the longitude in degrees, positive for east, negative for west.
class SolarCalculator {
  final DateTime date;

  final double latitude;

  final double longitude;

  SolarCalculator(this.date, double latitude, this.longitude)
      : latitude = (latitude >= 90)
            ? 89.9
            : (latitude <= -90)
                ? -89.9
                : latitude;

  /// Gets if it is darkness hours based on the end of the nautical twilight.
  bool get isHoursOfDarkness {
    var solarZenith = 90 - calculateSunHorizontalPosition().elevation;
    return (solarZenith > 102.0);
  }

  /// Gets the transit time of the Sun in UTC.
  ///
  /// The transit time of the sun, also called Sun–Meridian transit time, is a daily time when the Sun culminates on
  /// the observers Meridian, reaching the highest position in the sky. It corresponds to the solar noon.
  DateTime calculateSunTransitTime() {
    var julianDate = JulianDate.fromDateTime(date.midnightUtc);

    var tNoon = (julianDate - Timespan.fromDays(longitude / 360));
    var solarNoonOffset = 720 - (longitude * 4) - Sun(tNoon).equationOfTime; // in minutes

    tNoon = (julianDate + Timespan.fromMinutes(solarNoonOffset));
    var solarNoonUtc = 720 - (longitude * 4) - Sun(tNoon).equationOfTime; // in minutes

    return date.midnightUtc.add(Timespan.fromMinutes(solarNoonUtc));
  }

  // void sunrise() {
  //   var julianDatePrev = date.midnightUtc.subtract(Duration(days: 1)).julianDate;
  //   var julianDate = date.midnightUtc.julianDate;
  //   var julianDateNext = date.midnightUtc.add(Duration(days: 1)).julianDate;

  //   var sun = Sun(julianDate);
  //   var sunPrev = Sun(julianDatePrev);
  //   var sunNext = Sun(julianDateNext);

  //   var declinationRadians = sun.equatorialPosition.declination.toRadians();
  //   var latitudeRadians = latitude.toRadians();

  //   var hourAngleH = acos((sin((-0.833).toRadians()) - (sin(latitudeRadians) * sin(declinationRadians))) /
  //           (cos(latitudeRadians) * cos(declinationRadians)))
  //       .toDegrees();

  //   var siderealTime =
  //       evaluatePolynomial(julianDate.julianCenturies, [100.46061837, 36000.770053608, 0.000387933, -(1 / 38710000)])
  //           .correctedDegrees;

  //   var transit = (sun.equatorialPosition.rightAscension.decimalDegrees + longitude - siderealTime) / 360;
  //   transit = transit.isNegative ? transit + 1 : transit;

  //   print(date.midnightUtc.add(Timespan.fromDays(transit)));

  //   var rising = transit - (hourAngleH / 360);
  //   rising = rising.isNegative ? rising + 1 : rising;

  //   var greenwichSiderealTime = siderealTime + 360.985647 * rising;

  //   var deltaSiderealTime =
  //       evaluatePolynomial((date.year - 2000) / 100, [102, 102, 25.3]) + (0.37 * (date.year - 2100));
  //   var n = rising + (deltaSiderealTime / 86400);

  //   var a =
  //       sun.equatorialPosition.rightAscension.decimalDegrees - sunPrev.equatorialPosition.rightAscension.decimalDegrees;
  //   var b =
  //       sunNext.equatorialPosition.rightAscension.decimalDegrees - sun.equatorialPosition.rightAscension.decimalDegrees;
  //   var c = b - a;
  //   var interpolatedRightAscension =
  //       sun.equatorialPosition.rightAscension.decimalDegrees + ((n / 2) * (a + b + (n * c)));

  //   a = sun.equatorialPosition.declination - sunPrev.equatorialPosition.declination;
  //   b = sunNext.equatorialPosition.declination - sun.equatorialPosition.declination;
  //   c = b - a;
  //   var interpolatedDeclinationRadians =
  //       (sun.equatorialPosition.declination + ((n / 2) * (a + b + (n * c)))).toRadians();

  //   var localHourAngle = greenwichSiderealTime - longitude - interpolatedRightAscension;

  //   var altitude = asin(sin(latitudeRadians * sin(interpolatedDeclinationRadians)) +
  //           (cos(latitudeRadians) * cos(interpolatedDeclinationRadians) * cos(localHourAngle.toRadians())))
  //       .toDegrees();

  //   var deltaM = (altitude - (-0.8333)) /
  //       (360 * cos(interpolatedDeclinationRadians) * cos(latitudeRadians) * sin(localHourAngle.toRadians()));

  //   rising = rising + deltaM;

  //   print(date.midnightUtc.add(Timespan.fromDays(rising)));
  // }

  /// Gets the sunrise time in UTC.
  DateTime calculateSunriseTime() => SunriseSunsetCalculator(date, latitude, longitude).calculateSunrise();

  /// Gets the sunset time in UTC.
  DateTime calculateSunseTime() => SunriseSunsetCalculator(date, latitude, longitude).calculateSunset();

  /// Gets the morning astronomical twilight in UTC.
  ///
  /// The astronomical twilight is when the centre of the Sun is between 12° and 18° below the sensible horizon. Astronomical twilight is
  /// often considered to be "complete darkness".
  /// Sixth magnitude stars are no longer visible to the naked eye under good conditions.
  Twilight calculateMorningAstronomicalTwilight() {
    var begining = SunriseSunsetCalculator(date, latitude, longitude, sunZenithDistance: 108.0).calculateSunrise();
    var ending = SunriseSunsetCalculator(date, latitude, longitude, sunZenithDistance: 102.0).calculateSunrise();
    return Twilight(begining, ending);
  }

  /// Gets the morning nautical twilight in UTC.
  ///
  /// The nautical twilight is when the centre of the Sun is between 6° and 12° below the sensible horizon.
  /// It may now be possible to discern the sea horizon and it is no longer dark for normal practical purposes.
  Twilight calculateMorningNauticalTwilight() {
    var begining = SunriseSunsetCalculator(date, latitude, longitude, sunZenithDistance: 102.0).calculateSunrise();
    var ending = SunriseSunsetCalculator(date, latitude, longitude, sunZenithDistance: 96.0).calculateSunrise();
    return Twilight(begining, ending);
  }

  /// Gets the the morning civil twilight in UTC.
  ///
  /// The civil twillight is when the centre of the Sun is between 0° 50' and 6° below the sensible horizon.
  /// Illumination is such that it is possible to carry out day time tasks without additional artificial lighting.
  /// Large terrestrial objects can be now distinguished. The sea horizon is clearly defined and the brightest stars and planets are still visible.
  Twilight calculateMorningCivilTwilight() {
    var begining = SunriseSunsetCalculator(date, latitude, longitude, sunZenithDistance: 96.0).calculateSunrise();
    var ending = SunriseSunsetCalculator(date, latitude, longitude).calculateSunrise();
    return Twilight(begining, ending);
  }

  /// Gets the evening astronomical twilight in UTC.
  ///
  /// The astronomical twilight is when the centre of the Sun is between 12° and 18° below the sensible horizon. Astronomical twilight is
  /// often considered to be "complete darkness".
  /// Sixth magnitude stars are now visible to the naked eye under good conditions.
  Twilight calculateEveningAstronomicalTwilight() {
    var begining = SunriseSunsetCalculator(date, latitude, longitude, sunZenithDistance: 102.0).calculateSunset();
    var ending = SunriseSunsetCalculator(date, latitude, longitude, sunZenithDistance: 108.0).calculateSunset();
    return Twilight(begining, ending);
  }

  /// Gets the evening nautical twilight in UTC.
  ///
  /// The nautical twilight is when the centre of the Sun is between 6° and 12° below the sensible horizon.
  /// The sea horizon is no longer visible and it can be considered to be dark for normal practical purposes.
  Twilight calculateEveningNauticalTwilight() {
    var begining = SunriseSunsetCalculator(date, latitude, longitude, sunZenithDistance: 96.0).calculateSunset();
    var ending = SunriseSunsetCalculator(date, latitude, longitude, sunZenithDistance: 102.0).calculateSunset();
    return Twilight(begining, ending);
  }

  /// Gets the evening civil twilight in UTC.
  ///
  /// The civil twillight is when the centre of the Sun is between 0° 50' and 6° below the sensible horizon.
  /// Large terrestrial objects can be seen but no detail can be distinguished. The sea horizon is clearly defined and
  /// the brightest stars and planets are visible.
  Twilight calculateEveningCivilTwilight() {
    var begining = SunriseSunsetCalculator(date, latitude, longitude).calculateSunset();
    var ending = SunriseSunsetCalculator(date, latitude, longitude, sunZenithDistance: 96.0).calculateSunset();
    return Twilight(begining, ending);
  }

  /// Gets the apparent position of the Sun in the Equatorial Coordinate System.
  ///
  /// Its declination angle varies from -23.44° at the (northern hemisphere) winter solstice, through 0° at the vernal equinox,
  /// to +23.44° at the summer solstice.
  /// The variation in solar declination is the astronomical description of the sun going south (in the northern hemisphere)
  /// for the winter.
  EquatorialCoordinate calculateSunEquatorialPosition() => Sun(date.julianDate).equatorialPosition;

  /// Gets the apparent position of the Sun in the Horizontal Coordinate System.
  HorizontalCoordinate calculateSunHorizontalPosition() => Sun(date.julianDate).horizontalPosition(latitude, longitude);
}
