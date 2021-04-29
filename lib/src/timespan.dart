class Timespan extends Duration {
  Timespan.fromMilliseconds(double milliseconds)
      : super(
          milliseconds: milliseconds.toInt(),
          microseconds: ((milliseconds * Duration.microsecondsPerMillisecond) % 1000).toInt(),
        );

  Timespan.fromSeconds(double seconds)
      : super(
          seconds: seconds.toInt(),
          milliseconds: ((seconds * Duration.millisecondsPerSecond) % 1000).toInt(),
          microseconds: ((seconds * Duration.microsecondsPerSecond) % 1000).toInt(),
        );

  Timespan.fromMinutes(double minutes)
      : super(
          minutes: minutes.toInt(),
          seconds: ((minutes * Duration.secondsPerMinute) % 60).toInt(),
          milliseconds: ((minutes * Duration.millisecondsPerMinute) % 1000).toInt(),
          microseconds: ((minutes * Duration.microsecondsPerMinute) % 1000).toInt(),
        );

  Timespan.fromHours(double hours)
      : super(
          hours: hours.toInt(),
          minutes: ((hours * Duration.minutesPerHour) % 60).toInt(),
          seconds: ((hours * Duration.secondsPerHour) % 60).toInt(),
          milliseconds: ((hours * Duration.millisecondsPerHour) % 1000).toInt(),
          microseconds: ((hours * Duration.microsecondsPerHour) % 1000).toInt(),
        );

  Timespan.fromDays(double days)
      : super(
          days: days.toInt(),
          hours: ((days * Duration.hoursPerDay) % 24).toInt(),
          minutes: ((days * Duration.minutesPerDay) % 60).toInt(),
          seconds: ((days * Duration.secondsPerDay) % 60).toInt(),
          milliseconds: ((days * Duration.millisecondsPerDay) % 1000).toInt(),
          microseconds: ((days * Duration.microsecondsPerDay) % 1000).toInt(),
        );
}
