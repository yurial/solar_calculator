import 'package:solar_calculator/src/celestialObjects/sun.dart';

import 'timespan.dart';
import 'coordinateSystems/equatorialCoordinate.dart';
import 'coordinateSystems/horizontalCoordinate.dart';
import 'julianDate.dart';
import 'extensions.dart';
import 'sunriseSunsetCalculator.dart';
import 'twilight.dart';

/// Calculates the apparent position of the sun, sunrise, sunset, noon and the different twilights times for a given moment
/// in time and position on Earth.
///
/// The position is given by:
/// - the latitude in degrees, positive for north, negative for south;
/// - the longitude in degrees, positive for east, negative for west.
class SolarCalculator {
  final DateTime date;

  final double latitude;

  final double longitude;

  const SolarCalculator(this.date, this.latitude, this.longitude);

  /// Gets if it is darkness hours based on the end of the nautical twilight.
  bool isHoursOfDarkness() {
    var solarZenith = 90 - sunHorizontalPosition().elevation;
    return (solarZenith > 102.0);
  }

  /// Get the noon time in UTC.
  DateTime noonTime() {
    var julianDate = JulianDate.fromDateTime(date.midnightUtc);

    var tNoon = (julianDate - Timespan.fromDays(longitude / 360));

    var sun = Sun(tNoon);
    var solNoonOffset = 720 - (longitude * 4) - sun.equationOfTime; // in minutes

    var newT = (julianDate + Timespan.fromMinutes(solNoonOffset));
    var newSun = Sun(newT);

    var solNoonUtc = 720 - (longitude * 4) - newSun.equationOfTime; // + (timezone * 60); // in minutes
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

  /// Get the sunrise time in UTC.
  DateTime sunriseTime() => SunriseSunsetCalculator(date, latitude, longitude).getSunrise();

  /// Get the sunset time in UTC.
  DateTime sunseTime() => SunriseSunsetCalculator(date, latitude, longitude).getSunset();

  /// Gets the morning astronomical twilight in UTC.
  ///
  /// The astronomical twilight is when the centre of the Sun is between 12° and 18° below the sensible horizon. Astronomical twilight is
  /// often considered to be "complete darkness".
  /// Sixth magnitude stars are no longer visible to the naked eye under good conditions.
  Twilight morningAstronomicalTwilight() {
    var begining = SunriseSunsetCalculator(date, latitude, longitude, sunZenithDistance: 108.0).getSunrise();
    var ending = SunriseSunsetCalculator(date, latitude, longitude, sunZenithDistance: 102.0).getSunrise();
    return Twilight(begining, ending);
  }

  /// Gets the morning nautical twilight in UTC.
  ///
  /// The nautical twilight is when the centre of the Sun is between 6° and 12° below the sensible horizon.
  /// It may now be possible to discern the sea horizon and it is no longer dark for normal practical purposes.
  Twilight morningNauticalTwilight() {
    var begining = SunriseSunsetCalculator(date, latitude, longitude, sunZenithDistance: 102.0).getSunrise();
    var ending = SunriseSunsetCalculator(date, latitude, longitude, sunZenithDistance: 96.0).getSunrise();
    return Twilight(begining, ending);
  }

  /// Gets the the morning civil twilight in UTC.
  ///
  /// The civil twillight is when the centre of the Sun is between 0° 50' and 6° below the sensible horizon.
  /// Illumination is such that it is possible to carry out day time tasks without additional artificial lighting.
  /// Large terrestrial objects can be now distinguished. The sea horizon is clearly defined and the brightest stars and planets are still visible.
  Twilight morningCivilTwilight() {
    var begining = SunriseSunsetCalculator(date, latitude, longitude, sunZenithDistance: 96.0).getSunrise();
    var ending = SunriseSunsetCalculator(date, latitude, longitude).getSunrise();
    return Twilight(begining, ending);
  }

  /// Gets the evening astronomical twilight in UTC.
  ///
  /// The astronomical twilight is when the centre of the Sun is between 12° and 18° below the sensible horizon. Astronomical twilight is
  /// often considered to be "complete darkness".
  /// Sixth magnitude stars are now visible to the naked eye under good conditions.
  Twilight eveningAstronomicalTwilight() {
    var begining = SunriseSunsetCalculator(date, latitude, longitude, sunZenithDistance: 102.0).getSunset();
    var ending = SunriseSunsetCalculator(date, latitude, longitude, sunZenithDistance: 108.0).getSunset();
    return Twilight(begining, ending);
  }

  /// Gets the evening nautical twilight in UTC.
  ///
  /// The nautical twilight is when the centre of the Sun is between 6° and 12° below the sensible horizon.
  /// The sea horizon is no longer visible and it can be considered to be dark for normal practical purposes.
  Twilight eveningNauticalTwilight() {
    var begining = SunriseSunsetCalculator(date, latitude, longitude, sunZenithDistance: 96.0).getSunset();
    var ending = SunriseSunsetCalculator(date, latitude, longitude, sunZenithDistance: 102.0).getSunset();
    return Twilight(begining, ending);
  }

  /// Gets the evening civil twilight in UTC.
  ///
  /// The civil twillight is when the centre of the Sun is between 0° 50' and 6° below the sensible horizon.
  /// Large terrestrial objects can be seen but no detail can be distinguished. The sea horizon is clearly defined and
  /// the brightest stars and planets are visible.
  Twilight eveningCivilTwilight() {
    var begining = SunriseSunsetCalculator(date, latitude, longitude).getSunset();
    var ending = SunriseSunsetCalculator(date, latitude, longitude, sunZenithDistance: 96.0).getSunset();
    return Twilight(begining, ending);
  }

  /// Gets the apparent position of the Sun in the Equatorial Coordinate System.
  ///
  /// Its declination angle varies from -23.44° at the (northern hemisphere) winter solstice, through 0° at the vernal equinox,
  /// to +23.44° at the summer solstice.
  /// The variation in solar declination is the astronomical description of the sun going south (in the northern hemisphere)
  /// for the winter.
  EquatorialCoordinate sunEquatorialPosition() => Sun(date.julianDate).equatorialPosition;

  /// Gets the apparent position of the Sun in the Horizontal Coordinate System.
  HorizontalCoordinate sunHorizontalPosition() => Sun(date.julianDate).sunHorizontalPosition(latitude, longitude);
}
