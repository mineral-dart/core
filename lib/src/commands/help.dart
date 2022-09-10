import 'package:collection/collection.dart';
import 'package:mineral/api.dart';
import 'package:mineral/console.dart';
import 'package:mineral/core.dart';
import 'package:mineral/src/internal/managers/cli_manager.dart';

class Help extends MineralCliCommand {
  @override
  String name = 'help';

  @override
  String description = 'Displays the list of commands';

  @override
  Future<void> handle(args) async {
    Map<String, List> commands = {};
    for (final command in parser.commands.entries) {
      final String key = command.key.contains(':')
          ? command.key.split(':').first
          : 'Available commands';

      CliManager cli = ioc.singleton(ioc.services.cli);
      MineralCliCommand? mineralCommand = cli.commands.get(command.key);

      if (commands.containsKey(key)) {
        commands.get(key)?.add({ 'name': command.key, 'args': mineralCommand?.description });
      } else {
        commands.putIfAbsent(key, () => [{ 'name': command.key, 'args': mineralCommand?.description }]);
      }
    }

    String display = '\n';
    for (final group in commands.entries.sorted((a, b) => b.key.length.compareTo(a.key.length))) {
      display += ColorList.blue(group.key) + '\n';
      for (final command in group.value) {
        int length = command['name']!.length;
        String commandName = ColorList.green(command['name']);
        String args = ColorList.dim(command['args']);

        display += '  $commandName${List.filled(20 - length, ' ').join()}$args${ColorList.reset()}\n';
      }

      display += '\n';
    }

    print(display);
  }
}
