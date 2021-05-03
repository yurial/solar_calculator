import 'dart:math';

import 'package:solar_calculator/solar_calculator.dart';
import 'package:solar_calculator/src/celestialBodies/earth.dart';
import 'package:solar_calculator/src/coordinateSystems/horizontalCoordinate.dart';
import 'package:solar_calculator/src/julianDate.dart';
import 'package:solar_calculator/src/math.dart';
import 'package:solar_calculator/src/extensions.dart';

class Sun {
  // Cache
  static final Map<double, Sun> _cache = <double, Sun>{};

  final JulianDate julianDate;

  double? _meanLongitude;
  double? _meanAnomaly;
  double? _uncorrectedMeanAnomaly;
  double? _equationOfCenter;
  double? _trueLongitude;
  double? _trueAnomaly;
  double? _radiusVector;
  double? _apparentLongitude;
  double? _equationOfTime;

  EquatorialCoordinate? _equatorialPosition;

  factory Sun(JulianDate julianDate) => _cache.putIfAbsent(julianDate.julianDay, () => Sun._internal(julianDate));

  Sun._internal(this.julianDate);

  /// The equation of time in minutes.
  ///
  /// Due to the eccentricity of its orbit, and to a less degree due to the perturbations by the Moon and the planets, the Earth's
  /// heliocentric longitude does not vary uniformly. It follows that the Sun appears to describe the ecliptic at a non uniform rate.
  /// Due to this, and also to the fact that the Sun is moving in the ecliptic and not along the celestial equator, its right
  /// ascension does not increase uniformly.
  ///
  /// When the mean Sun crosses the observer's meridian, it is mean noon there. True noon is the instant when the true Sun crosses
  /// the meridian. The equation of time is the difference between apparent et mean time. In other words, it is the difference between the
  /// hour angles of the true Sun et the mean Sun.
  ///
  /// Equation of time is an astronomical term accounting for changes in the time of solar noon for a given location over the course of a year.
  /// Earth's elliptical orbit and Kepler's law of equal areas in equal times are the culprits behind this phenomenon.
  double get equationOfTime {
    if (_equationOfTime == null) {
      var earth = Earth(julianDate);

      var epsilonRadians = earth.correctedObliquityOfEcliptic.toRadians();
      var l0Radians = meanLongitude.toRadians();
      var e = earth.orbitalEccentricity;
      var mRadians = uncorrectedMeanAnomaly.toRadians();

      var y = pow(tan(epsilonRadians / 2), 2);

      var eTime = (y * sin(2.0 * l0Radians)) -
          (2.0 * e * sin(mRadians)) +
          (4.0 * e * y * sin(mRadians) * cos(2.0 * l0Radians)) -
          (0.5 * y * y * sin(4.0 * l0Radians)) -
          (1.25 * e * e * sin(2.0 * mRadians));

      _equationOfTime = eTime.toDegrees() * 4.0;
    }

    return _equationOfTime!;
  }

  /// The mean longitude of the Sun in degrees.
  ///
  /// The mean longitude is the ecliptic longitude at which an orbiting body could be found if its orbit were circular and
  /// free of perturbations.
  double get meanLongitude {
    if (_meanLongitude == null) {
      var l0 = evaluatePolynomial(julianDate.julianCenturies, [280.46646, 36000.76983, 0.0003032]);
      // var l0 = 280.46646 + (36000.76983 * _julianCenturies) + (0.0003032 * pow(_julianCenturies, 2));
      _meanLongitude = l0.correctedDegrees;
    }

    return _meanLongitude!;
  }

  /// The geometric mean anomaly of the Sun in degrees.
  ///
  /// Anomaly here refers to the non-uniform apparent motion of the Sun and planets along the plane of the ecliptic.
  /// It is defined as the angular distance from perihelion which the Earth would have if it moved around the Sun with
  /// a constant angular velocity.
  ///
  /// Note that the word "apparent" is always used to denote that the Sun, planets, and stars appear to move across the
  /// sky in a 24-hour period. Obviously, the true movement is the rotation of the Earth on its axis but it is convenient
  /// to talk of the apparent motion of the Sun and planets across the sky.
  double get meanAnomaly => _meanAnomaly ??= uncorrectedMeanAnomaly.correctedDegrees;

  /// The geometric mean anomaly of the Sun in degrees, uncorrected for large angles.
  ///
  /// See [meanAnomaly].
  double get uncorrectedMeanAnomaly =>
      _uncorrectedMeanAnomaly ??= evaluatePolynomial(julianDate.julianCenturies, [357.52911, 35999.05029, -0.0001537]);
  //357.52911 + (35999.05029 * _julianCenturies) - (0.0001537 * pow(_julianCenturies, 2));

  /// The Sun's equation of center, in degrees.
  ///
  /// In two-body, Keplerian orbital mechanics, the equation of the center is the angular difference between
  /// the actual position of a body in its elliptical orbit and the position it would occupy if its motion were uniform,
  /// in a circular orbit of the same period.
  ///
  /// It is defined as the difference of true anomaly minus mean anomaly, and is typically expressed as a function of
  /// mean anomaly and orbital eccentricity.
  ///
  /// https://en.wikipedia.org/wiki/Equation_of_the_center
  double get equationOfCenter {
    if (_equationOfCenter == null) {
      var mRadians = meanAnomaly.toRadians();

      var julianCenturies = julianDate.julianCenturies;

      _equationOfCenter = (sin(mRadians) * (1.914602 - julianCenturies * (0.004817 + 0.000014 * julianCenturies))) +
          (sin(mRadians * 2.0) * (0.019993 - 0.000101 * julianCenturies)) +
          (sin(mRadians * 3.0) * 0.000289);
    }

    return _equationOfCenter!;
  }

  /// The true longitude of the Sun in degrees.
  ///
  /// In celestial mechanics, true longitude is the ecliptic longitude at which an orbiting body could actually be found if
  /// its inclination were zero. Together with the inclination and the ascending node, the true longitude can tell us
  /// the precise direction from the central object at which the body would be located at a particular time.
  double get trueLongitude => _trueLongitude ??= (meanLongitude + equationOfCenter).correctedDegrees;

  /// The true anomaly of the Sun in degrees.
  ///
  /// In celestial mechanics, true anomaly is an angular parameter that defines the position of a body moving along a
  /// Keplerian orbit. It is the angle between the direction of periapsis and the current position of the body, as seen
  /// from the main focus of the ellipse (the point around which the object orbits).
  double get trueAnomaly => _trueAnomaly ??= (meanAnomaly + equationOfCenter).correctedDegrees;

  /// The radius vector in AUs.
  ///
  /// It is the distance (measured in astronomical units or AU) between the center of the Sun and the center of the Earth.
  double get radiusVector {
    // var v = sunTrueAnomaly;
    // var e = earthOrbitalEccentricity;

    // var r = (1.000001018 * (1 - pow(e, 2))) / (1 + e * cos(_k * v));

    if (_radiusVector == null) {
      // U.S. Naval Observatory function for radius vector
      var mRadians = meanAnomaly.toRadians();
      _radiusVector = 1.00014 - (0.01671 * cos(mRadians)) - (0.00014 * cos(2 * mRadians));
    }

    return _radiusVector!;

    // return r;
  }

  /// The apparent longitude of the Sun in degrees.
  ///
  /// Apparent longitude is celestial longitude corrected for aberration and nutation as opposed to mean longitude.
  double get apparentLongitude => _apparentLongitude ??=
      trueLongitude - 0.00569 - (0.00478 * sin(Earth(julianDate).nutationAndAberrationCorrection.toRadians()));

  /// The Apparent position of the Sun in the Equatorial Coordinate System.
  ///
  /// Its declination angle varies from -23.44° at the (northern hemisphere) winter solstice, through 0° at the vernal equinox,
  /// to +23.44° at the summer solstice.
  /// The variation in solar declination is the astronomical description of the sun going south (in the northern hemisphere)
  /// for the winter.
  EquatorialCoordinate get equatorialPosition {
    if (_equatorialPosition == null) {
      var earth = Earth(julianDate);

      var rightAscension = atan2(
        cos(earth.correctedObliquityOfEcliptic.toRadians()) * sin(apparentLongitude.toRadians()),
        cos(apparentLongitude.toRadians()),
      );

      var declination = asin(sin(earth.correctedObliquityOfEcliptic.toRadians()) * sin(apparentLongitude.toRadians()));

      _equatorialPosition = EquatorialCoordinate(HourAngle.fromRadians(rightAscension), declination.toDegrees());
    }

    return _equatorialPosition!;
  }

  /// Gets the apparent position of the Sun in the Horizontal Coordinate System.
  HorizontalCoordinate horizontalPosition(double latitude, double longitude) {
    var timeOffset = equationOfTime + (4.0 * longitude);

    var utcDateTime = julianDate.gregorianDateTime.toUtc();
    var time = utcDateTime.time;

    var trueSolarTime = time.totalMinutes + timeOffset;

    while (trueSolarTime > Duration.minutesPerDay) {
      trueSolarTime -= Duration.minutesPerDay;
    }

    var hourAngle = (trueSolarTime / 4.0) - 180.0; // Solar hour angle in degrees
    if (hourAngle < -180) hourAngle += 360.0;

    var latitudeRadians = latitude.toRadians();
    var sunDeclinationRadians = equatorialPosition.declination.toRadians();
    var hourAngleRadians = hourAngle.toRadians();

    // Calculate the cosinus of the solar zenith angle.
    var cosinusSolarZenith = (sin(latitudeRadians) * sin(sunDeclinationRadians)) +
        (cos(latitudeRadians) * cos(sunDeclinationRadians) * cos(hourAngleRadians));

    if (cosinusSolarZenith > 1.0) {
      cosinusSolarZenith = 1.0;
    } else if (cosinusSolarZenith < -1.0) cosinusSolarZenith = -1.0;

    var zenithRadians = acos(cosinusSolarZenith);
    var zenith = zenithRadians.toDegrees();
    var azimuthDenominator = cos(latitudeRadians) * sin(zenithRadians);

    double azimuth;

    if (azimuthDenominator.abs() > 0.001) {
      var azimuthRadians =
          ((sin(latitudeRadians) * cos(zenithRadians)) - sin(sunDeclinationRadians)) / azimuthDenominator;

      if (azimuthRadians.abs() > 1.0) azimuthRadians = (azimuthRadians < 0) ? -1.0 : 1.0;

      azimuth = 180.0 - acos(azimuthRadians).toDegrees();

      if (hourAngle > 0.0) azimuth = -azimuth;
    } else {
      azimuth = (latitude > 0.0) ? 180.0 : 0.0;
    }

    if (azimuth < 0.0) azimuth += 360.0;

    // Atmospheric Refraction correction
    var refractionCorrection = _calculateAtmosphericRefractionCorrection(90.0 - zenith);

    var correctedSolarZenith = zenith - refractionCorrection;
    var elevation = 90.0 - correctedSolarZenith;

    return HorizontalCoordinate(azimuth, elevation);
  }

  /// Calculates the approximate Atmospheric Refraction Correction in degrees for the given [elevation].
  ///
  /// As light from the sun (or another celestial body) travels from the vacuum of space into Earth's atmosphere, the path of the light
  /// is bent due to refraction. This causes stars and planets near the horizon to appear higher in the sky than they actually are,
  /// and explains how the sun can still be visible after it has physically passed beyond the horizon at sunset.
  ///
  /// https://www.esrl.noaa.gov/gmd/grad/solcalc/calcdetails.html
  double _calculateAtmosphericRefractionCorrection(double elevation) {
    if (elevation > 85.0) {
      return 0.0;
    } else {
      var tanElevation = tan(elevation.toRadians());
      double correction;

      if (elevation > 5.0) {
        // correction = (58.1 / tanElevation) - (0.07 / pow(tanElevation, 3)) + (0.000086 / pow(tanElevation, 5));
        correction = evaluatePolynomial(1 / tanElevation, [0, 58.1, 0, -0.07, 0, 0.000086]);
      } else if (elevation > -0.575) {
        //correction = 1735.0 + elevation * (-518.2 + elevation * (103.4 + elevation * (-12.79 + elevation * 0.711)));
        correction = evaluatePolynomial(elevation, [1735, -518.2, 103.4, -12.79, 0.711]);
        // correction = 1735.0 -
        //     (518.2 * elevation) +
        //     (103.4 * pow(elevation, 2)) -
        //     (12.79 * pow(elevation, 3)) +
        //     (0.711 * pow(elevation, 4));
      } else {
        correction = -20.774 / tanElevation;
      }

      return correction / 3600.0;
    }
  }
}
