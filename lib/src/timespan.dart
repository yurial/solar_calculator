/// Represents a span of time.
///
/// Enhanced [Duration] object allowing to create a span of time from fractional values.
///
/// See [Duration] for more information.
class Timespan extends Duration {
  /// Creates a span of time from fractional [milliseconds].
  Timespan.fromMilliseconds(double milliseconds)
      : super(
          milliseconds: milliseconds.toInt(),
          microseconds:
              ((milliseconds * Duration.microsecondsPerMillisecond) % Duration.microsecondsPerMillisecond).toInt(),
        );

  /// Creates a span of time from fractional [seconds].
  Timespan.fromSeconds(double seconds)
      : super(
          seconds: seconds.toInt(),
          milliseconds: ((seconds * Duration.millisecondsPerSecond) % Duration.millisecondsPerSecond).toInt(),
          microseconds: ((seconds * Duration.microsecondsPerSecond) % Duration.microsecondsPerMillisecond).toInt(),
        );

  /// Creates a span of time from fractional [minutes].
  Timespan.fromMinutes(double minutes)
      : super(
          minutes: minutes.toInt(),
          seconds: ((minutes * Duration.secondsPerMinute) % Duration.secondsPerMinute).toInt(),
          milliseconds: ((minutes * Duration.millisecondsPerMinute) % Duration.millisecondsPerSecond).toInt(),
          microseconds: ((minutes * Duration.microsecondsPerMinute) % Duration.microsecondsPerMillisecond).toInt(),
        );

  /// Creates a span of time from fractional [hours].
  Timespan.fromHours(double hours)
      : super(
          hours: hours.toInt(),
          minutes: ((hours * Duration.minutesPerHour) % Duration.minutesPerHour).toInt(),
          seconds: ((hours * Duration.secondsPerHour) % Duration.secondsPerMinute).toInt(),
          milliseconds: ((hours * Duration.millisecondsPerHour) % Duration.millisecondsPerSecond).toInt(),
          microseconds: ((hours * Duration.microsecondsPerHour) % Duration.microsecondsPerMillisecond).toInt(),
        );

  /// Creates a span of time from fractional [days].
  Timespan.fromDays(double days)
      : super(
          days: days.toInt(),
          hours: ((days * Duration.hoursPerDay) % Duration.hoursPerDay).toInt(),
          minutes: ((days * Duration.minutesPerDay) % Duration.minutesPerHour).toInt(),
          seconds: ((days * Duration.secondsPerDay) % Duration.secondsPerMinute).toInt(),
          milliseconds: ((days * Duration.millisecondsPerDay) % Duration.millisecondsPerSecond).toInt(),
          microseconds: ((days * Duration.microsecondsPerDay) % Duration.microsecondsPerMillisecond).toInt(),
        );
}
