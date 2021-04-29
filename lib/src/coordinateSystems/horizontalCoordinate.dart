/// Horizontal coordinate system.
///
/// The horizontal coordinate system is a celestial coordinate system that uses the observer's local horizon as the fundamental
/// plane. It is usually used to specify a location in the sky using angles called elevation and azimuth.
///
/// This coordinate system is based on the position of the observer on Earth, which revolves around
/// its own axis once per sidereal day (23 hours, 56 minutes and 4.091 seconds) in relation to the star background.
/// The positioning of a celestial object by the horizontal system varies with time, but is a useful coordinate system for
/// locating and tracking objects for observers on Earth. It is based on the position of stars relative to an observer's ideal
/// horizon.
///
/// https://en.wikipedia.org/wiki/Horizontal_coordinate_system
class HorizontalCoordinate {
  /// Azimuth in degrees.
  ///
  /// It is the angle of the object measured clockwise (eastward) from true north to the point on the horizon directly below the object.
  final double azimuth;

  /// Elevation in degrees.
  ///
  /// It is the angle of the object measured vertically from the point on the horizon directly below the object up to the object.
  /// For visible objects, it is an angle between 0° and 90°.
  final double elevation;

  HorizontalCoordinate(this.azimuth, this.elevation);
}
