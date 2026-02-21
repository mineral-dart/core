import 'package:mineral/src/api/common/commands/command_option.dart';

final class CommandRegistration {
  final String name;
  final Function handler;
  final List<CommandOption> declaredOptions;

  const CommandRegistration({
    required this.name,
    required this.handler,
    required this.declaredOptions,
  });
}
