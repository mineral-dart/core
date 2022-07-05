import 'package:args/args.dart';
import 'package:mineral/api.dart';
import 'package:mineral/core.dart';
import 'package:mineral/src/internal/entities/cli_manager.dart';

Future<void> main (List<String> arguments) async {
  Kernel kernel = Kernel();
  final ArgParser parser = ArgParser();

  final makeCommandParser = ArgParser();
  makeCommandParser.addOption('name');
  parser.addCommand('make:command', makeCommandParser);

  final makeEventParser = ArgParser();
  makeEventParser.addOption('name');
  parser.addCommand('make:event', makeEventParser);

  final makeModuleParser = ArgParser();
  makeModuleParser.addOption('name');
  parser.addCommand('make:module', makeModuleParser);

  final makeStoreParser = ArgParser();
  makeStoreParser.addOption('name');
  parser.addCommand('make:store', makeStoreParser);

  final createProjectParser = ArgParser();
  createProjectParser.addOption('name');
  parser.addCommand('create', createProjectParser);

  ArgResults results = parser.parse(arguments);

  MineralCliCommand? command = kernel.cli.commands.get(results.command?.name);
  if (command != null) {
    return await command.handle(results);
  }
}
