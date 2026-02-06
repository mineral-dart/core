/// Represents an error that occurred during audio playback
final class PlaybackError implements Exception {
  /// The error message
  final String message;

  /// The underlying error, if any
  final Object? cause;

  PlaybackError(this.message, [this.cause]);

  @override
  String toString() => 'PlaybackError: $message${cause != null ? ' ($cause)' : ''}';
}
