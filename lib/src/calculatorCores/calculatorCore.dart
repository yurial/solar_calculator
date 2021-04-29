import 'dart:math';

import '../coordinateSystems/horizontalCoordinate.dart';
import '../angles/angle.dart';
import '../angles/hourAngle.dart';
import '../coordinateSystems/equatorialCoordinate.dart';
import '../julianDate.dart';
import '../privateExtensions.dart';
import '../publicExtensions.dart';

class CalculatorCore {
  final JulianDate julianDate;

  double? _sunMeanLongitude;
  double? _sunMeanAnomaly;
  double? _sunGrossMeanAnomaly;
  double? _earthOrbitalEccentricity;
  double? _sunEquationOfCenter;
  double? _sunTrueLongitude;
  double? _sunTrueAnomaly;
  double? _sunRadiusVector;
  double? _sunApparentLongitude;
  double? _meanObliquityOfEcliptic;
  double? _correctedObliquityOfEcliptic;
  double? _equationOfTime;

  EquatorialCoordinate? _sunPosition;

  late final double _julianCenturies = julianDate.julianCenturies;

  CalculatorCore(this.julianDate);

  /// The mean longitude of the Sun in degrees.
  ///
  /// The mean longitude is the ecliptic longitude at which an orbiting body could be found if its orbit were circular and
  /// free of perturbations.
  double get sunMeanLongitude {
    if (_sunMeanLongitude == null) {
      var l0 = 280.46646 + (36000.76983 * _julianCenturies) + (0.0003032 * pow(_julianCenturies, 2));
      _sunMeanLongitude = l0.correctedDegrees;
    }

    return _sunMeanLongitude!;
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
  double get sunMeanAnomaly => _sunMeanAnomaly ??= sunGrossMeanAnomaly.correctedDegrees;

  /// The geometric mean anomaly of the Sun in degrees, uncorrected.
  ///
  /// Anomaly here refers to the non-uniform apparent motion of the Sun and planets along the plane of the ecliptic.
  /// It is defined as the angular distance from perihelion which the Earth would have if it moved around the Sun with
  /// a constant angular velocity.
  ///
  /// Note that the word "apparent" is always used to denote that the Sun, planets, and stars appear to move across the
  /// sky in a 24-hour period. Obviously, the true movement is the rotation of the Earth on its axis but it is convenient
  /// to talk of the apparent motion of the Sun and planets across the sky.
  double get sunGrossMeanAnomaly =>
      _sunGrossMeanAnomaly ??= 357.52911 + (35999.05029 * _julianCenturies) - (0.0001537 * pow(_julianCenturies, 2));

  /// The eccentricity of the Earth orbit (unitless).
  ///
  /// The eccentricity refers to the "flatness" of the ellipse swept out by the Earth in its orbit around the Sun.
  double get earthOrbitalEccentricity => _earthOrbitalEccentricity ??=
      0.016708634 - (0.000042037 * _julianCenturies) - (0.0000001267 * pow(_julianCenturies, 2));

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
  double get sunEquationOfCenter {
    if (_sunEquationOfCenter == null) {
      var mRadians = sunMeanAnomaly.toRadians();

      _sunEquationOfCenter =
          (1.914602 - (0.004817 * _julianCenturies) - (0.000014 * pow(_julianCenturies, 2))) * sin(mRadians) +
              (0.019993 - (0.000101 * _julianCenturies)) * sin(mRadians * 2.0) +
              (0.000289 * sin(mRadians * 3.0));
    }

    return _sunEquationOfCenter!;
  }

  /// The true longitude of the Sun in degrees.
  ///
  /// In celestial mechanics, true longitude is the ecliptic longitude at which an orbiting body could actually be found if
  /// its inclination were zero. Together with the inclination and the ascending node, the true longitude can tell us
  /// the precise direction from the central object at which the body would be located at a particular time.
  double get sunTrueLongitude => _sunTrueLongitude ??= (sunMeanLongitude + sunEquationOfCenter).correctedDegrees;

  /// The true anomaly of the Sun in degrees.
  ///
  /// In celestial mechanics, true anomaly is an angular parameter that defines the position of a body moving along a
  /// Keplerian orbit. It is the angle between the direction of periapsis and the current position of the body, as seen
  /// from the main focus of the ellipse (the point around which the object orbits).
  double get sunTrueAnomaly => _sunTrueAnomaly ??= (sunMeanAnomaly + sunEquationOfCenter).correctedDegrees;

  /// The radius vector in AUs.
  ///
  /// It is the distance (measured in astronomical units or AU) between the center of the Sun and the center of the Earth.
  double get sunRadiusVector {
    // var v = sunTrueAnomaly;
    // var e = earthOrbitalEccentricity;

    // var r = (1.000001018 * (1 - pow(e, 2))) / (1 + e * cos(_k * v));

    if (_sunRadiusVector == null) {
      // U.S. Naval Observatory function for radius vector
      var mRadians = sunMeanAnomaly.toRadians();
      _sunRadiusVector = 1.00014 - (0.01671 * cos(mRadians)) - (0.00014 * cos(2 * mRadians));
    }

    return _sunRadiusVector!;

    // return r;
  }

  /// The apparent longitude of the Sun in degrees.
  ///
  /// Apparent longitude is celestial longitude corrected for aberration and nutation as opposed to mean longitude.
  double get sunApparentLongitude => _sunApparentLongitude ??=
      sunTrueLongitude - 0.00569 - (0.00478 * sin(nutationAndAberrationCorrection.toRadians()));

  /// The correction factor for nutation and aberration.
  ///
  /// In astronomy, aberration is a phenomenon which produces an apparent motion of celestial objects about their true positions,
  /// dependent on the velocity of the observer. It causes objects to appear to be displaced towards the direction of motion
  /// of the observer compared to when the observer is stationary.
  ///
  /// Astronomical nutation is a phenomenon which causes the orientation of the axis of rotation of a spinning astronomical
  /// object to vary over time. It is caused by the gravitational forces of other nearby bodies acting upon the spinning object.
  double get nutationAndAberrationCorrection => 125.04 - (1934.136 * _julianCenturies);

  /// The mean obliquity of the ecliptic in degrees, that is the obliquity free from short-term variations.
  ///
  /// The ecliptic is the plane of Earth's orbit around the Sun. It is the apparent path of the Sun throughout the course of a year.
  ///
  /// The obliquity is an effect caused by the tilt of the Earth on its axis with respect to the celestial equator.
  /// In other words, it is the angle between the plane of the Earth’s equator and the plane across which the Sun and planets
  /// appear to travel.
  double get meanObliquityOfEcliptic {
    // ε = 23° 26' 21.448" − 46.8150" T − 0.00059" T^2 + 0.001813" T^3
    // ε = 23° 26' 21".406 − 46".836769 T − 0".0001831 T2 + 0".00200340 T^3 − 0".576×10−6 T^4 − 4".34×10−8 T^5

    // High precision formula:
    // ε = 23° 26' 21.448" − 4680.93″ t − 1.55" t^2 + 1999.25" t^3 − 51.38" t^4 − 249.67" t^5 − 39.05" t^6 + 7.12" t^7 + 27.87" t^8 + 5.79" t^9 + 2.45" t^10
    // wheret is multiples of 10,000 Julian years from J2000.0

    if (_meanObliquityOfEcliptic == null) {
      var u = _julianCenturies / 100;
      _meanObliquityOfEcliptic = Angle(degrees: 23, minutes: 26, seconds: 21.448).degrees -
          Angle(seconds: 4680.93).degrees * u -
          1.55 * pow(u, 2) +
          1999.25 * pow(u, 3) -
          51.38 * pow(u, 4) -
          249.67 * pow(u, 5) -
          39.05 * pow(u, 6) +
          7.12 * pow(u, 7) +
          27.87 * pow(u, 8) +
          5.79 * pow(u, 9) +
          2.45 * pow(u, 10);
    }

    return _meanObliquityOfEcliptic!;
  }

  /// The mean obliquity of the ecliptic in degrees, corrected for nutation and aberration.
  double get correctedObliquityOfEcliptic => _correctedObliquityOfEcliptic ??=
      meanObliquityOfEcliptic + (0.00256 * cos(nutationAndAberrationCorrection.toRadians()));

  /// The equation of time in minutes.
  ///
  /// Equation of time is an astronomical term accounting for changes in the time of solar noon for a given location over the course of a year.
  /// Earth's elliptical orbit and Kepler's law of equal areas in equal times are the culprits behind this phenomenon.
  double get equationOfTime {
    if (_equationOfTime != null) return _equationOfTime!;

    var epsilonRadians = correctedObliquityOfEcliptic.toRadians();
    var l0Radians = sunMeanLongitude.toRadians();
    var e = earthOrbitalEccentricity;
    var mRadians = sunGrossMeanAnomaly.toRadians();

    var y = pow(tan(epsilonRadians / 2), 2);

    var eTime = (y * sin(2.0 * l0Radians)) -
        (2.0 * e * sin(mRadians)) +
        (4.0 * e * y * sin(mRadians) * cos(2.0 * l0Radians)) -
        (0.5 * pow(y, 2) * sin(4.0 * l0Radians)) -
        (1.25 * pow(e, 2) * sin(2.0 * mRadians));

    return eTime.toDegrees() * 4.0;
  }

  /// Apparent position of the Sun in the Equatorial Coordinate System.
  ///
  /// Its declination angle varies from -23.44° at the (northern hemisphere) winter solstice, through 0° at the vernal equinox,
  /// to +23.44° at the summer solstice.
  /// The variation in solar declination is the astronomical description of the sun going south (in the northern hemisphere)
  /// for the winter.
  EquatorialCoordinate get sunEquatorialPosition {
    if (_sunPosition == null) {
      var rightAscension = atan2(
        cos(correctedObliquityOfEcliptic.toRadians()) * sin(sunApparentLongitude.toRadians()),
        cos(sunApparentLongitude.toRadians()),
      );

      var declination = asin(sin(correctedObliquityOfEcliptic.toRadians()) * sin(sunApparentLongitude.toRadians()));

      _sunPosition = EquatorialCoordinate(HourAngle.fromRadians(rightAscension), declination.toDegrees());
    }

    return _sunPosition!;
  }

  /// Gets the apparent position of the Sun in the Horizontal Coordinate System.
  HorizontalCoordinate getSunHorizontalPosition(double latitude, double longitude) {
    var timeOffset = equationOfTime + (4.0 * longitude); // - 60.0 * zone
    // var earthRadVec = calcSunRadVector(T)
    var utcTime = julianDate.gregorianDateTime.toUtc();
    var time = Duration(
        hours: utcTime.hour,
        minutes: utcTime.minute,
        seconds: utcTime.second,
        milliseconds: utcTime.millisecond,
        microseconds: utcTime.microsecond);

    var trueSolarTime = time.totalMinutes + timeOffset;

    while (trueSolarTime > Duration.minutesPerDay) {
      trueSolarTime -= Duration.minutesPerDay;
    }

    var hourAngle = (trueSolarTime / 4.0) - 180.0; // Solar hour angle in degrees
    if (hourAngle < -180) hourAngle += 360.0;

    var latitudeRadians = latitude.toRadians();
    var sunDeclinationRadians = sunEquatorialPosition.declination.toRadians();
    var hourAngleRadians = hourAngle.toRadians();

    // Calculate the cosinus of the solar zenith angle.
    var csz = (sin(latitudeRadians) * sin(sunDeclinationRadians)) +
        (cos(latitudeRadians) * cos(sunDeclinationRadians) * cos(hourAngleRadians));

    if (csz > 1.0) {
      csz = 1.0;
    } else if (csz < -1.0) csz = -1.0;

    var zenithRadians = acos(csz);
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

    var exoatmElevation = 90.0 - zenith;

    // Atmospheric Refraction correction
    var refractionCorrection = _getAtmosphericRefractionCorrection(exoatmElevation);

    var correctedSolarZenith = zenith - refractionCorrection;
    var elevation = 90.0 - correctedSolarZenith;

    return HorizontalCoordinate(azimuth, elevation);
  }

  /// Gets the approximate Atmospheric Refraction Correction in degrees for the given [elevation].
  ///
  /// As light from the sun (or another celestial body) travels from the vacuum of space into Earth's atmosphere, the path of the light
  /// is bent due to refraction. This causes stars and planets near the horizon to appear higher in the sky than they actually are,
  /// and explains how the sun can still be visible after it has physically passed beyond the horizon at sunset.
  ///
  /// https://www.esrl.noaa.gov/gmd/grad/solcalc/calcdetails.html
  double _getAtmosphericRefractionCorrection(double elevation) {
    if (elevation > 85.0) {
      return 0.0;
    } else {
      var tanElevation = tan(elevation.toRadians());
      double correction;

      if (elevation > 5.0) {
        correction = (58.1 / tanElevation) - (0.07 / pow(tanElevation, 3)) + (0.000086 / pow(tanElevation, 5));
      } else if (elevation > -0.575) {
        correction = 1735.0 -
            (518.2 * elevation) +
            (103.4 * pow(elevation, 2)) -
            (12.79 * pow(elevation, 3)) +
            (0.711 * pow(elevation, 4));
      } else {
        correction = -20.774 / tanElevation;
      }

      return correction / 3600.0;
    }
  }
}