import 'package:solar_calculator/solar_calculator.dart';

void main() {
  var latitude = 41.29708;
  var longitude = 2.07846;

  var date = DateTime.utc(2021, 04, 29, 19, 54);

  var calc = SolarCalculator(date);

  var sunPosition = calc.getSunEquatorialPosition();
  print('Sun Equatorial position:');
  print('    Right ascension: ${sunPosition.rightAscension} = ${sunPosition.rightAscensionHourAngle}');
  print('    Declination: ${sunPosition.declination}');

  var azimuthElevation = calc.getSunHorizontalPosition(latitude, longitude);
  print('Sun Horizontal position:');
  print('    Azimuth: ${azimuthElevation.azimuth}');
  print('    Elevation: ${azimuthElevation.elevation}');

  var morningAstronomicalTwilight = calc.getMorningAstronomicalTwilight(latitude, longitude);
  print('Morning astronomical twilight:');
  print('    Begining: ${morningAstronomicalTwilight.begining}');
  print('    Ending: ${morningAstronomicalTwilight.ending}');
  print('    Duration: ${morningAstronomicalTwilight.duration}');

  var morningNauticalTwilight = calc.getMorningNauticalTwilight(latitude, longitude);
  print('Morning nautical twilight:');
  print('    Begining: ${morningNauticalTwilight.begining}');
  print('    Ending: ${morningNauticalTwilight.ending}');
  print('    Duration: ${morningNauticalTwilight.duration}');

  var morningCivilTwilight = calc.getMorningCivilTwilight(latitude, longitude);
  print('Morning civil twilight:');
  print('    Begining: ${morningCivilTwilight.begining}');
  print('    Ending: ${morningCivilTwilight.ending}');
  print('    Duration: ${morningCivilTwilight.duration}');

  print('Sunrise: ${calc.getSunrise(latitude, longitude)}');
  print('Noon: ${calc.getNoon(longitude)}');
  print('Sunset: ${calc.getSunset(latitude, longitude)}');

  var eveningCivilTwilight = calc.getEveningCivilTwilight(latitude, longitude);
  print('Evening civil twilight:');
  print('    Begining: ${eveningCivilTwilight.begining}');
  print('    Ending: ${eveningCivilTwilight.ending}');
  print('    Duration: ${eveningCivilTwilight.duration}');

  var eveningNauticalTwilight = calc.getEveningNauticalTwilight(latitude, longitude);
  print('Evening nautical twilight:');
  print('    Begining: ${eveningNauticalTwilight.begining}');
  print('    Ending: ${eveningNauticalTwilight.ending}');
  print('    Duration: ${eveningNauticalTwilight.duration}');

  var eveningAstronomicalTwilight = calc.getEveningAstronomicalTwilight(latitude, longitude);
  print('Evening astronomical twilight:');
  print('    Begining: ${eveningAstronomicalTwilight.begining}');
  print('    Ending: ${eveningAstronomicalTwilight.ending}');
  print('    Duration: ${eveningAstronomicalTwilight.duration}');

  if (calc.getIfHoursOfDarkness(latitude, longitude)) print('===> IS DARK <===');
}
