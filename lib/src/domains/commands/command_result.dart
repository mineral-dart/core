sealed class CommandResult {
  const CommandResult();
}

final class CommandSuccess extends CommandResult {
  const CommandSuccess();
}

final class CommandFailure extends CommandResult {
  final String commandName;
  final Object error;
  final StackTrace stackTrace;

  const CommandFailure({
    required this.commandName,
    required this.error,
    required this.stackTrace,
  });

  @override
  String toString() => 'CommandFailure(command: "$commandName", error: $error)';
}
