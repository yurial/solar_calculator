/// Represents a span of time.
///
/// Enhanced [Duration] object allowing to create a span of time from fractional values.
///
/// See [Duration] for more information.
class Timespan extends Duration {
  /// Creates a span of time from fractional [milliseconds].
  Timespan.fromMilliseconds(double milliseconds)
      : super(
          milliseconds: milliseconds.floor(),
          microseconds:
              ((milliseconds * Duration.microsecondsPerMillisecond) % Duration.microsecondsPerMillisecond).floor(),
        );

  /// Creates a span of time from fractional [seconds].
  Timespan.fromSeconds(double seconds)
      : super(
          seconds: seconds.floor(),
          milliseconds: ((seconds * Duration.millisecondsPerSecond) % Duration.millisecondsPerSecond).floor(),
          microseconds: ((seconds * Duration.microsecondsPerSecond) % Duration.microsecondsPerMillisecond).floor(),
        );

  /// Creates a span of time from fractional [minutes].
  Timespan.fromMinutes(double minutes)
      : super(
          minutes: minutes.floor(),
          seconds: ((minutes * Duration.secondsPerMinute) % Duration.secondsPerMinute).floor(),
          milliseconds: ((minutes * Duration.millisecondsPerMinute) % Duration.millisecondsPerSecond).floor(),
          microseconds: ((minutes * Duration.microsecondsPerMinute) % Duration.microsecondsPerMillisecond).floor(),
        );

  /// Creates a span of time from fractional [hours].
  Timespan.fromHours(double hours)
      : super(
          hours: hours.floor(),
          minutes: ((hours * Duration.minutesPerHour) % Duration.minutesPerHour).floor(),
          seconds: ((hours * Duration.secondsPerHour) % Duration.secondsPerMinute).floor(),
          milliseconds: ((hours * Duration.millisecondsPerHour) % Duration.millisecondsPerSecond).floor(),
          microseconds: ((hours * Duration.microsecondsPerHour) % Duration.microsecondsPerMillisecond).floor(),
        );

  /// Creates a span of time from fractional [days].
  Timespan.fromDays(double days)
      : super(
          days: days.floor(),
          hours: ((days * Duration.hoursPerDay) % Duration.hoursPerDay).floor(),
          minutes: ((days * Duration.minutesPerDay) % Duration.minutesPerHour).floor(),
          seconds: ((days * Duration.secondsPerDay) % Duration.secondsPerMinute).floor(),
          milliseconds: ((days * Duration.millisecondsPerDay) % Duration.millisecondsPerSecond).floor(),
          microseconds: ((days * Duration.microsecondsPerDay) % Duration.microsecondsPerMillisecond).floor(),
        );
}
