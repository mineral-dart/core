/// Error captured from a command, event, or component handler that threw.
///
/// Tests assert on `bot.errors` instead of letting exceptions crash the test
/// — handlers are expected to be exercised in isolation.
final class HandlerError {
  /// Slash command name, if the error came from a command handler.
  final String? commandName;

  /// Component custom id, if the error came from a component handler.
  final String? customId;

  /// Event name, if the error came from an event listener.
  final String? eventName;

  /// The raised error.
  final Object error;

  /// The stack trace at the moment the error was raised.
  final StackTrace stackTrace;

  const HandlerError({
    required this.error,
    required this.stackTrace,
    this.commandName,
    this.customId,
    this.eventName,
  });

  @override
  String toString() {
    final source = commandName ?? customId ?? eventName ?? '<unknown>';
    return 'HandlerError(source: $source, error: $error)';
  }
}
