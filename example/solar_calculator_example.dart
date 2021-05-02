import 'package:solar_calculator/solar_calculator.dart';

void main() {
  var latitude = 41.29708;
  var longitude = 2.07846;

  var date = DateTime(2021, 04, 29, 19, 54);

  var calc = SolarCalculator(date, latitude, longitude);

  var sunEquatorialPosition = calc.calculateSunEquatorialPosition();
  print('Sun Equatorial position:');
  print(
      '    Right ascension: ${sunEquatorialPosition.rightAscension} = ${sunEquatorialPosition.rightAscension.decimalDegrees}');
  print('    Declination: ${sunEquatorialPosition.declination}');

  var sunHorizontalPosition = calc.calculateSunHorizontalPosition();
  print('Sun Horizontal position:');
  print('    Azimuth: ${sunHorizontalPosition.azimuth}');
  print('    Elevation: ${sunHorizontalPosition.elevation}');

  var morningAstronomicalTwilight = calc.calculateMorningAstronomicalTwilight();
  print('Morning astronomical twilight:');
  print('    Begining: ${morningAstronomicalTwilight.begining}');
  print('    Ending: ${morningAstronomicalTwilight.ending}');
  print('    Duration: ${morningAstronomicalTwilight.duration}');

  var morningNauticalTwilight = calc.calculateMorningNauticalTwilight();
  print('Morning nautical twilight:');
  print('    Begining: ${morningNauticalTwilight.begining}');
  print('    Ending: ${morningNauticalTwilight.ending}');
  print('    Duration: ${morningNauticalTwilight.duration}');

  var morningCivilTwilight = calc.calculateMorningCivilTwilight();
  print('Morning civil twilight:');
  print('    Begining: ${morningCivilTwilight.begining}');
  print('    Ending: ${morningCivilTwilight.ending}');
  print('    Duration: ${morningCivilTwilight.duration}');

  print('Sunrise: ${calc.calculateSunriseTime()}');
  print('Noon: ${calc.calculateSunTransitTime()}');
  print('Sunset: ${calc.calculateSunseTime()}');

  var eveningCivilTwilight = calc.calculateEveningCivilTwilight();
  print('Evening civil twilight:');
  print('    Begining: ${eveningCivilTwilight.begining}');
  print('    Ending: ${eveningCivilTwilight.ending}');
  print('    Duration: ${eveningCivilTwilight.duration}');

  var eveningNauticalTwilight = calc.calculateEveningNauticalTwilight();
  print('Evening nautical twilight:');
  print('    Begining: ${eveningNauticalTwilight.begining}');
  print('    Ending: ${eveningNauticalTwilight.ending}');
  print('    Duration: ${eveningNauticalTwilight.duration}');

  var eveningAstronomicalTwilight = calc.calculateEveningAstronomicalTwilight();
  print('Evening astronomical twilight:');
  print('    Begining: ${eveningAstronomicalTwilight.begining}');
  print('    Ending: ${eveningAstronomicalTwilight.ending}');
  print('    Duration: ${eveningAstronomicalTwilight.duration}');

  if (calc.isHoursOfDarkness) print('===> IS DARK <===');
}
