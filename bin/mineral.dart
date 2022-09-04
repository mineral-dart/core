import 'package:args/args.dart';
import 'package:collection/collection.dart';
import 'package:mineral/api.dart';
import 'package:mineral/console.dart';
import 'package:mineral/core.dart';
import 'package:mineral/src/internal/managers/cli_manager.dart';

Future<void> main (List<String> arguments) async {
  Kernel kernel = Kernel();
  kernel.loadConsole();

  final ArgParser parser = ArgParser();

  final makeCommandParser = ArgParser();
  makeCommandParser.addOption('filename');
  parser.addCommand('make:command', makeCommandParser);

  final makeEventParser = ArgParser();
  makeEventParser.addOption('filename');
  parser.addCommand('make:event', makeEventParser);

  final makeModuleParser = ArgParser();
  makeModuleParser.addOption('filename', help: 'test');
  parser.addCommand('make:module', makeModuleParser);

  final makeStoreParser = ArgParser();
  makeStoreParser.addOption('filename');
  parser.addCommand('make:store', makeStoreParser);

  final createProjectParser = ArgParser();
  createProjectParser.addOption('project-name');
  parser.addCommand('create', createProjectParser);

  ArgResults results = parser.parse(arguments);

  MineralCliCommand? command = kernel.cli.commands.get(results.command?.name);
  if (command != null) {
    return await command.handle(results);
  }

  Map<String, List> commands = {};

  for (final command in parser.commands.entries) {
    final String key = command.key.split(':').first;

    MineralCliCommand? mineralCommand = kernel.cli.commands.get(command.key);

    if (commands.containsKey(key)) {
      commands.get(key)?.add({ 'name': command.key, 'args': mineralCommand?.description });
    } else {
      commands.putIfAbsent(key, () => [{ 'name': command.key, 'args': mineralCommand?.description }]);
    }
  }

  String display = '';
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

  // for (final int value in List.generate(255, (index) => index)) {
  //   print('$value → \x1B[${value}mtest\x1B[0m');
  // }
}
