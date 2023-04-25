import 'dart:io';
import 'package:mineral_contract/mineral_contract.dart';
import 'package:tint/tint.dart';

import 'package:collection/collection.dart';
import 'package:mineral/src/internal/services/console/console_service.dart';

class Help extends CliCommandContract {
  final Map<String, CliCommandContract> _commands;
  Help(ConsoleService console, this._commands): super(console, 'help', 'Displays the list of commands', []);

  @override
  Future<void> handle(args) async {
    Map<String, List<CliCommandContract>> commands = {};

    for (final command in _commands.values) {
      final String key = command.name.contains(':')
        ? command.name.split(':').first
        : 'Available commands';

      if (commands.containsKey(key)) {
        commands[key]?.add(command);
      } else {
        commands.putIfAbsent(key, () => [command]);
      }
    }

    String display = '';
    _commands.values.toList().sort((a, b) => a.arguments.length + b.arguments.length);
    int maxArgumentLength = _commands.values.last.arguments.map((argument) => '<$argument>').join('').length;

    for (final group in commands.entries.sorted((a, b) => b.key.length.compareTo(a.key.length))) {
      display += '${group.key.blue()}\n';

      for (final command in group.value) {
        int length = command.name.length;
        String commandName = command.name.green();
        String description = command.description.grey();
        String arguments = command.arguments.map((argument) => '<$argument>').join(' ').green();
        final indent = (20 + maxArgumentLength) - ((arguments.length - maxArgumentLength) + length);

        display += '  $commandName $arguments ${' ' * indent}$description\n';
      }
    }

    stdout.writeln(display);
  }
}
