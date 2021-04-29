import '../angles/hourAngle.dart';

/// Equatorial coordinate system.
///
/// The equatorial coordinate system is a celestial coordinate system widely used to specify the positions of celestial objects.
///
/// The coordinates are defined by an origin at the centre of Earth, a fundamental plane consisting of the projection of
/// Earth's equator onto the celestial sphere (forming the celestial equator), a primary direction towards the vernal equinox,
/// and a right-handed convention.
///
/// https://en.wikipedia.org/wiki/Equatorial_coordinate_system
class EquatorialCoordinate {
  /// Right ascension in degrees.
  ///
  /// The right ascension measures the angular distance of an object eastward along the celestial equator from the vernal equinox
  /// (the Sun at the March equinox) to the hour circle passing through the object.
  ///
  /// Note: the hour circle, is the great circle through the object and the two celestial poles.
  final double rightAscension;

  /// Gets the right ascension as hour angle.
  ///
  /// The right ascension measures the angular distance of an object eastward along the celestial equator from the vernal equinox
  /// (the Sun at the March equinox) to the hour circle passing through the object.
  ///
  /// Note: the hour circle, is the great circle through the object and the two celestial poles.
  HourAngle get rightAscensionHourAngle => HourAngle.fromDegrees(rightAscension);

  /// Declination angle in degrees.
  ///
  /// The declination measures the angular distance of an object perpendicular to the celestial equator, positive to the north,
  /// negative to the south. For example, the north celestial pole has a declination of +90°. The origin for declination is
  /// the celestial equator, which is the projection of the Earth's equator onto the celestial sphere.
  /// Declination is analogous to terrestrial latitude.
  ///
  /// As an example, the declination angle of the Sun is the angle between the Earth's equator and a line drawn from
  /// the centre of the Earth to the centre of the Sun.
  final double declination;

  EquatorialCoordinate(this.rightAscension, this.declination);
}
