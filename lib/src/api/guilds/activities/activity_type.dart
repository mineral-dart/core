/// The type of an [Activity].
enum ActivityType {
  /// Playing a game.
  game(0),

  /// Streaming a game.
  streaming(1),

  /// Listening to a song.
  listening(2),

  /// Watching a stream.
  watching(3),

  /// Custom activity.
  custom(4),

  /// Competing in a game.
  competing(5);

  final int value;
  const ActivityType(this.value);
}