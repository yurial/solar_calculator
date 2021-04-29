import 'package:solar_calculator/solar_calculator.dart';

void main() {
  var latitude = 41.29708;
  var longitude = 2.07846;

  var date = DateTime.utc(2021, 04, 29, 19, 54);

  var calc = SolarCalculator(date, latitude, longitude);

  var sunEquatorialPosition = calc.getSunEquatorialPosition();
  print('Sun Equatorial position:');
  print(
      '    Right ascension: ${sunEquatorialPosition.rightAscension} = ${sunEquatorialPosition.rightAscension.decimalDegrees}');
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
