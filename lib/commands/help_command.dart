import 'dart:io';

import 'package:collection/collection.dart';
import 'package:logging/logging.dart';
import 'package:mineral/internal/services/console/command.dart';
import 'package:mineral/internal/services/console/command_option.dart';
import 'package:mineral/internal/services/console/console.dart';
import 'package:tint/tint.dart';

final class HelpCommand extends Command {
  final Logger _logger;

  HelpCommand(this._logger): super(
    name: 'help',
    description: 'Displays help information',
    options: [
      CommandOption(name: 'name', description: 'description', usage: 'Usage !'),
    ]
  );

  @override
  Future<void> handle () async {
    final Map<String, Command> commands = Console.singleton().commands;

    final Map<String, List<Command>> displayCommands = {};

    for (final command in commands.values) {
      final String key = command.name.contains(':')
          ? command.name.split(':').first
          : 'Available commands';

      if (displayCommands.containsKey(key)) {
        displayCommands[key]?.add(command);
      } else {
        displayCommands.putIfAbsent(key, () => [command]);
      }
    }

    int maxArgumentLength = commands.values.last.options.bucket.map((options) => '<${options.name}>').join('').length;
    for (final group in displayCommands.entries.sorted((a, b) => b.key.length.compareTo(a.key.length))) {
      stdout.writeln();
      stdout.writeln(group.key.blue());

      for (final command in group.value) {
        int length = command.name.length;
        String commandName = command.name.green();
        String description = command.description?.grey() ?? 'No description provided';
        String arguments = command.options.bucket.map((option) => '<${option.name}>').join(' ').green();
        final indent = (20 + maxArgumentLength) - ((arguments.length - maxArgumentLength) + length);

        stdout.writeln(' $commandName $arguments ${' ' * indent}$description');
      }
    }
  }
}