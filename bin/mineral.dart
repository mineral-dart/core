import 'package:args/args.dart';
import 'package:mineral/api.dart';
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

  final startProjectParser = ArgParser();
  parser.addCommand('start', startProjectParser);

  final helpParser = ArgParser();
  parser.addCommand('help', helpParser);

  ArgResults results = parser.parse(arguments);

  MineralCliCommand? command = kernel.cli.commands.get(results.command?.name ?? 'help');
  if (command != null) {
    command.parser = parser;
    return await command.handle(results);
  }
}
