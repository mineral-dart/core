import 'dart:io';

import 'package:args/args.dart';
import 'package:interact/interact.dart';
import 'package:mineral/api.dart';
import 'package:mineral/console.dart';
import 'package:mineral/src/internal/managers/cli_manager.dart';
import 'package:path/path.dart';

class MakeCommand extends MineralCliCommand {
  @override
  String name = 'make:command';

  @override
  Future<void> handle (ArgResults args) async {
    if (args.arguments.length == 1) {
      Console.error(message: 'The name argument is not defined');
      return;
    }

    String filename = args.arguments.elementAt(1).capitalCase;

    final useExistLocation = Confirm(
      prompt: 'Do you want to use an existing location on your disk ?',
      defaultValue: true,
    ).interact();

    late File file;

    if (useExistLocation) {
      List<Directory> directories = await getDirectories();

      final selection = Select(
        prompt: 'Your favorite programming language',
        options: directories.map((directory) => directory.path
          .replaceAll(join(Directory.current.path, 'src'), 'App')
          .replaceAll('\\', '/'))
          .toList(),
      ).interact();

      file = File(join(directories[selection].path, '${filename.snakeCase}.dart'));
    } else {
      final location = Input(
        prompt: 'Target folder location',
        defaultValue: 'App/folder', // optional, will provide the user as a hint
      ).interact();

      file = File(join(Directory.current.path, 'src', location.replaceAll('App/', '').replaceAll('App', ''), '${filename.snakeCase}.dart'));
    }

    await file.create(recursive: true);
    await writeFileContent(file, getTemplate(filename));

    Console.success(message: 'File created : ${file.uri}');
    Console.warn(message: 'Don\'t forget to add your file to the main or module file');
  }

  String getTemplate (String filename) => '''
import 'package:mineral/core.dart';
import 'package:mineral/api.dart';

@Command(name: '${filename.toLowerCase()}', description: '${filename.capitalCase} command description', scope: 'GUILD')
class ${filename.pascalCase} extends MineralCommand {
  Future<void> handle (CommandInteraction interaction) async {
    // Your code here
    await interaction.reply(content: 'Hello World ! 💪');
  }
}
  ''';
}
