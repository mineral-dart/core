/// Represents the type of activity a bot can display in its Discord presence.
///
/// Each [GamePresence] type determines how Discord formats and displays the
/// bot's activity status to users. The activity type affects both the text
/// shown and any special indicators (like the "LIVE" badge for streaming).
///
/// ## Usage
///
/// Use with [BotActivity] to set the bot's presence:
///
/// ```dart
/// final activity = BotActivity(
///   type: GamePresence.game,
///   name: 'Minecraft',
/// );
/// ```
///
/// ## Activity Display Format
///
/// - [game]: "Playing {name}"
/// - [streaming]: "Streaming {name}" with a purple "LIVE" indicator
/// - [listening]: "Listening to {name}"
/// - [watching]: "Watching {name}"
/// - [custom]: Custom status with optional emoji
/// - [competing]: "Competing in {name}"
///
/// See also:
/// - [BotActivity] for creating bot activities
/// - [StatusType] for setting the bot's online status
enum GamePresence {
  /// Playing activity type.
  ///
  /// Displays as "Playing {name}" in Discord.
  /// Commonly used for games or interactive activities.
  ///
  /// Example: "Playing Minecraft"
  game(0),

  /// Streaming activity type with live indicator.
  ///
  /// Displays as "Streaming {name}" with a purple "LIVE" badge.
  /// Requires a valid Twitch or YouTube URL.
  ///
  /// Example: "Streaming Live Coding"
  streaming(1),

  /// Listening activity type.
  ///
  /// Displays as "Listening to {name}" in Discord.
  /// Commonly used for music or audio content.
  ///
  /// Example: "Listening to Spotify"
  listening(2),

  /// Watching activity type.
  ///
  /// Displays as "Watching {name}" in Discord.
  /// Commonly used for video or streaming content.
  ///
  /// Example: "Watching YouTube"
  watching(3),

  /// Custom activity type.
  ///
  /// Allows for custom status text with optional emoji.
  /// Displays exactly as specified without a prefix.
  custom(4),

  /// Competing activity type.
  ///
  /// Displays as "Competing in {name}" in Discord.
  /// Used for competitive activities or events.
  ///
  /// Example: "Competing in Arena"
  competing(5);

  /// The numeric value used by Discord's API to represent this activity type.
  /// The numeric value used by Discord's API to represent this activity type.
  final int value;

  const GamePresence(this.value);

  @override
  String toString() => value.toString();
}

/// Represents a time range for activities that have start and end times.
///
/// [Timestamp] is used with [Activity] to indicate when an activity started
/// and optionally when it will end. This is particularly useful for rich presence
/// features that display elapsed time or countdown timers.
///
/// ## Usage
///
/// ```dart
/// final timestamp = Timestamp(
///   start: DateTime.now().subtract(Duration(minutes: 30)),
///   end: DateTime.now().add(Duration(hours: 1)),
/// );
/// ```
///
/// See also:
/// - [Activity] for rich presence activities
class Timestamp {
  /// The start time of the activity.
  ///
  /// Represents when the activity began. Can be null if the start time
  /// is not applicable or unknown.
  DateTime? start;

  /// The end time of the activity.
  ///
  /// Represents when the activity will end or is expected to end.
  /// Can be null if there's no defined end time.
  DateTime? end;

  /// Creates a timestamp with the specified start and end times.
  ///
  /// Example:
  /// ```dart
  /// final timestamp = Timestamp(
  ///   start: DateTime.now(),
  ///   end: DateTime.now().add(Duration(hours: 2)),
  /// );
  /// ```
  Timestamp({required this.start, required this.end});

  /// Creates a timestamp from a JSON payload received from Discord's API.
  ///
  /// The [payload] should contain millisecond timestamps for 'start' and 'end'.
  /// This factory is used internally when deserializing activity data.
  ///
  /// Example payload:
  /// ```json
  /// {
  ///   "start": 1638360000000,
  ///   "end": 1638367200000
  /// }
  /// ```
  factory Timestamp.from({required dynamic payload}) {
    return Timestamp(
      start: payload['start'] != null
          ? DateTime.fromMillisecondsSinceEpoch(payload['start'])
          : null,
      end: payload['end'] != null
          ? DateTime.fromMillisecondsSinceEpoch(payload['end'])
          : null,
    );
  }
}
