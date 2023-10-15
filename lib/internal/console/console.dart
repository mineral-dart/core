import 'package:args/args.dart';
import 'package:mineral/internal/console/command.dart';
import 'package:mineral/internal/console/option_bucket.dart';
import 'package:mineral/internal/fold/injectable.dart';
import 'package:mineral/services/logger/logger.dart';
import 'package:mineral/services/logger/logger_contract.dart';

final class Console extends Injectable {
  final Map<String, Command> commands = {};
  final ArgParser _commandParser = ArgParser();
  final Logger logger;

  Console(this.logger);

  void handle(List<String> args) {
    final result = _commandParser.parse(args);
    final command = commands[result.command?.name];

    if (result.command == null || command == null) {
      logger.console.info('No command was provided');
      return;
    }

    final List<String> arguments = List.from(result.arguments)
        ..removeAt(0);

    for (final argument in arguments) {
      final int index = arguments.indexOf(argument);
      (command.options as OptionBucket).options.elementAtOrNull(index)?.value = argument;
    }

    command.handle();
  }

  void addCommand(Command command) {
    final ArgParser args = ArgParser();

    for (final option in (command.options as OptionBucket).options) {
      args.addOption(option.name, abbr: option.abbr, help: option.usage);
    }

    commands.putIfAbsent(command.name, () => command);
    _commandParser.addCommand(command.name, args);
  }
}