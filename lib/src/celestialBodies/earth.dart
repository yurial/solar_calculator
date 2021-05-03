import 'dart:math';

import 'package:solar_calculator/src/angles/angle.dart';
import 'package:solar_calculator/src/julianDate.dart';
import 'package:solar_calculator/src/math.dart';
import 'package:solar_calculator/src/extensions.dart';

class Earth {
  static final Map<double, Earth> _cache = <double, Earth>{};

  final JulianDate julianDate;

  double? _meanObliquityOfEcliptic;
  double? _correctedObliquityOfEcliptic;
  double? _earthOrbitalEccentricity;

  factory Earth(JulianDate julianDate) => _cache.putIfAbsent(
      julianDate.julianDay, () => Earth._internal(julianDate));

  Earth._internal(this.julianDate);

  /// The mean obliquity of the ecliptic in degrees, that is the obliquity free from short-term variations.
  ///
  /// The ecliptic is the plane of Earth's orbit around the Sun. It is the apparent path of the Sun throughout the course of a year.
  ///
  /// The obliquity is an effect caused by the tilt of the Earth on its axis with respect to the celestial equator.
  /// In other words, it is the angle between the plane of the Earth’s equator and the plane across which the Sun and planets
  /// appear to travel.
  double get meanObliquityOfEcliptic {
    if (_meanObliquityOfEcliptic == null) {
      var u = julianDate.julianCenturies / 100;
      _meanObliquityOfEcliptic = evaluatePolynomial(u, [
        Angle(degrees: 23, minutes: 26, seconds: 21.448).degrees,
        -Angle(seconds: 4680.93).degrees,
        -1.55,
        1999.25,
        -51.38,
        -249.67,
        -39.05,
        7.12,
        27.87,
        5.79,
        2.45
      ]);
    }

    return _meanObliquityOfEcliptic!;
  }

  /// The mean obliquity of the ecliptic in degrees, corrected for nutation and aberration.
  double get correctedObliquityOfEcliptic =>
      _correctedObliquityOfEcliptic ??= meanObliquityOfEcliptic +
          (0.00256 * cos(nutationAndAberrationCorrection.toRadians()));

  /// The eccentricity of the Earth orbit (unitless).
  ///
  /// The eccentricity refers to the "flatness" of the ellipse swept out by the Earth in its orbit around the Sun.
  double get orbitalEccentricity =>
      _earthOrbitalEccentricity ??= evaluatePolynomial(
          julianDate.julianCenturies,
          [0.016708634, -0.000042037, -0.0000001267]);

  /// The correction factor for nutation and aberration.
  ///
  /// In astronomy, aberration is a phenomenon which produces an apparent motion of celestial objects about their true positions,
  /// dependent on the velocity of the observer. It causes objects to appear to be displaced towards the direction of motion
  /// of the observer compared to when the observer is stationary.
  ///
  /// Astronomical nutation is a phenomenon which causes the orientation of the axis of rotation of a spinning astronomical
  /// object to vary over time. It is caused by the gravitational forces of other nearby bodies acting upon the spinning object.
  double get nutationAndAberrationCorrection =>
      125.04 - (1934.136 * julianDate.julianCenturies);
}
