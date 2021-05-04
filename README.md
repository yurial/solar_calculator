A Dart library that calculates the position of the Sun, the sunrise, sunset, solar noon times, and the different twilight periods, for any given moment in time and position on Earth.

The calculations are based on equations from Astronomical Algorithms, by Jean Meeus. The sunrise and sunset results are theoretically accurate to within a minute for locations between +/- 72° of latitude, and within 10 minutes outside of those latitudes. However, due to variations in atmospheric composition, temperature, pressure and conditions, the calculated values may differ from the observed values.

## Features

For a given moment in time and position on Earth:

* Get the apparent position of the Sun in equatorial coordinates (right ascension and declination);
* Get the apparent position of the Sun in horizontal coordinates (azimuth and elevation);
* Get the sunrise time in UTC;
* Get the solar noon time in UTC;
* Get the sunset time in UTC;
* Get the morning and evening astronomical twilights (begining and ending times in UTC);
* Get the morning and evening nautical twilights (begining and ending times in UTC);
* Get the morning and evening civil twilights (begining and ending times in UTC);
* Get if, at that moment and position, it is hours of darkness (based on the civil twilight).

## Limitations

For sunrise, sunset and twilights calculations, 0.833° of atmospheric refraction is assumed.

The effects of the atmosphere vary with atmospheric pressure, humidity and other variables. Therefore the Sun position calculated is approximate. Related to these effects, the further away you are from the equator, errors in sunrise, sunset and twilight times can be expected to increase because the sun rises and sets at a very shallow angle; in this condition, small variations in the atmosphere can have a larger effect.

The approximations used in this calculator are very good for years between 1800 and 2100. Results should still be sufficiently accurate for the range from -1000 to 3000. Outside of this range, the potential for error is higher.

## Usage

Create a SolarCalculator instance with the desired date, latitude and longitude.

```dart
import 'package:solar_calculator/solar_calculator.dart';

  var latitude = 41.29708;
  var longitude = 2.07846;
  var date = DateTime.now();

  var calc = SolarCalculator(date, latitude, longitude);

  bool isHoursOfDarkness = calc.isHoursOfDarkness;
}
```