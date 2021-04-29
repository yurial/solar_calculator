A library that calculates the position of the Sun, the solar noon time, and the sunrise, sunset, and twilight times, for any given moment in time and position on Earth.

The calculations are based on equations from Astronomical Algorithms, by Jean Meeus. The sunrise and sunset results are theoretically accurate to within a minute for locations between +/- 72° of latitude, and within 10 minutes outside of those latitudes. However, due to variations in atmospheric composition, temperature, pressure and conditions, observed values may vary from calculations.

## Features

For a given moment in time and position on Earth:

* Get the apparent position of the Sun in equatorial coordinates (right ascension and declination);
* Get the apparent position of the Sun in horizontal coordinates (azimuth and elevation);
* Get the sunrise time;
* Get the solar noon time;
* Get the sunset time;
* Get the morning and evening astronomical twilights (begining and ending times);
* Get the morning and evening nautical twilights (begining and ending times);
* Get the morning and evening civil twilights (begining and ending times);
* Get if, at that moment and position, it is hours of darkness (based on the nautical twilight).

## Limitations

For sunrise, sunset and twilights calculations, 0.833° of atmospheric refraction is assumed.

The effects of the atmosphere vary with atmospheric pressure, humidity and other variables. Therefore the Sun position calculated is approximate. Related to these effects, the further away you are from the equator, errors in sunrise, sunset and twilight times can be expected to increase because the sun rises and sets at a very shallow angle; in this condition, small variations in the atmosphere can have a larger effect.

The approximations used in this calculator are very good for years between 1800 and 2100. Results should still be sufficiently accurate for the range from -1000 to 3000. Outside of this range, results may be given, but the potential for error is higher.

## Usage

Create a SolarCalculator instance with the desired date, latitude and longitude.

```dart
import 'package:solar_calculator/solar_calculator.dart';

void main() {
  var latitude = 41.29708;
  var longitude = 2.07846;

  var date = DateTime.utc(2021, 04, 29, 19, 54);

  var calc = SolarCalculator(date, latitude, longitude);

  var sunEquatorialPosition = calc.getSunEquatorialPosition();
  print('Sun Equatorial position:');
  print('    Right ascension: ${sunEquatorialPosition.rightAscension} = ${sunEquatorialPosition.rightAscension.decimalDegrees}');
  print('    Declination: ${sunEquatorialPosition.declination}');

  var sunHorizontalPosition = calc.getSunHorizontalPosition();
  print('Sun Horizontal position:');
  print('    Azimuth: ${sunHorizontalPosition.azimuth}');
  print('    Elevation: ${sunHorizontalPosition.elevation}');

  var morningAstronomicalTwilight = calc.getMorningAstronomicalTwilight();
  print('Morning astronomical twilight:');
  print('    Begining: ${morningAstronomicalTwilight.begining}');
  print('    Ending: ${morningAstronomicalTwilight.ending}');
  print('    Duration: ${morningAstronomicalTwilight.duration}');

  var morningNauticalTwilight = calc.getMorningNauticalTwilight();
  print('Morning nautical twilight:');
  print('    Begining: ${morningNauticalTwilight.begining}');
  print('    Ending: ${morningNauticalTwilight.ending}');
  print('    Duration: ${morningNauticalTwilight.duration}');

  var morningCivilTwilight = calc.getMorningCivilTwilight();
  print('Morning civil twilight:');
  print('    Begining: ${morningCivilTwilight.begining}');
  print('    Ending: ${morningCivilTwilight.ending}');
  print('    Duration: ${morningCivilTwilight.duration}');

  print('Sunrise: ${calc.getSunrise()}');
  print('Noon: ${calc.getNoon()}');
  print('Sunset: ${calc.getSunset()}');

  var eveningCivilTwilight = calc.getEveningCivilTwilight();
  print('Evening civil twilight:');
  print('    Begining: ${eveningCivilTwilight.begining}');
  print('    Ending: ${eveningCivilTwilight.ending}');
  print('    Duration: ${eveningCivilTwilight.duration}');

  var eveningNauticalTwilight = calc.getEveningNauticalTwilight();
  print('Evening nautical twilight:');
  print('    Begining: ${eveningNauticalTwilight.begining}');
  print('    Ending: ${eveningNauticalTwilight.ending}');
  print('    Duration: ${eveningNauticalTwilight.duration}');

  var eveningAstronomicalTwilight = calc.getEveningAstronomicalTwilight();
  print('Evening astronomical twilight:');
  print('    Begining: ${eveningAstronomicalTwilight.begining}');
  print('    Ending: ${eveningAstronomicalTwilight.ending}');
  print('    Duration: ${eveningAstronomicalTwilight.duration}');

  if (calc.getIfHoursOfDarkness()) print('===> IS DARK <===');
}
```

Output:

```
Sun Equatorial position:
    Right ascension: 2h 29m 14.00s = 37.30831827274789
    Declination: 14.72187192722585

Sun Horizontal position:
    Azimuth: 302.2738125537525
    Elevation: -12.056315681698479

Morning astronomical twilight:
    Begining: 2021-04-29 03:06:15.089604Z
    Ending: 2021-04-29 03:45:31.718728Z
    Duration: 0:39:16.629124

Morning nautical twilight:
    Begining: 2021-04-29 03:45:31.718728Z
    Ending: 2021-04-29 04:21:52.757833Z
    Duration: 0:36:21.039105

Morning civil twilight:
    Begining: 2021-04-29 04:21:52.757833Z
    Ending: 2021-04-29 04:51:42.002224Z
    Duration: 0:29:49.244391

Sunrise: 2021-04-29 04:51:42.002224Z
Noon: 2021-04-29 11:49:00.682314Z
Sunset: 2021-04-29 18:47:01.214311Z

Evening civil twilight:
    Begining: 2021-04-29 18:47:01.214311Z
    Ending: 2021-04-29 19:16:57.015741Z
    Duration: 0:29:55.801430

Evening nautical twilight:
    Begining: 2021-04-29 19:16:57.015741Z
    Ending: 2021-04-29 19:53:28.465862Z
    Duration: 0:36:31.450121

Evening astronomical twilight:
    Begining: 2021-04-29 19:53:28.465862Z
    Ending: 2021-04-29 20:33:00.927636Z
    Duration: 0:39:32.461774

===> IS DARK <===
```