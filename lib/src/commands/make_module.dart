import 'dart:io';

import 'package:args/args.dart';
import 'package:interact/interact.dart';
import 'package:mineral/api.dart';
import 'package:mineral/console.dart';
import 'package:mineral/src/internal/managers/cli_manager.dart';
import 'package:path/path.dart';

class MakeModule extends MineralCliCommand {
  @override
  String name = 'make:module';

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
    late Directory directory;

    if (useExistLocation) {
      List<Directory> directories = await getDirectories();

      final selection = Select(
        prompt: 'Your favorite programming language',
        options: directories.map((directory) => directory.path
          .replaceAll(join(Directory.current.path, 'src'), 'App')
          .replaceAll('\\', '/'))
          .toList(),
      ).interact();

      directory = Directory(join(directories[selection].path, filename.snakeCase));
      file = File(join(directory.path, '${filename.snakeCase}.dart'));
    } else {
      final location = Input(
        prompt: 'Target folder location',
        defaultValue: 'App/folder',
      ).interact();

      directory = Directory(join(Directory.current.path, 'src', location.replaceAll('App/', '').replaceAll('App', ''), filename.snakeCase));
      file = File(join(directory.path, '${filename.snakeCase}.dart'));
    }

    await Directory(join(directory.path, 'events')).create(recursive: true);
    await Directory(join(directory.path, 'commands')).create(recursive: true);
    await Directory(join(directory.path, 'stores')).create(recursive: true);

    await file.create(recursive: true);
    await writeFileContent(file, getTemplate(filename));

    Console.success(message: 'File created : ${file.uri}');
    Console.warn(message: 'Don\'t forget to add your file to the main file');
  }

  String getTemplate (String filename) => '''
import 'package:mineral/core.dart';

@Module(identifier: '${filename.snakeCase}', label: '${filename.capitalCase} module')
class ${filename.pascalCase} extends MineralModule {
  @override
  List<MineralCommand> commands = [];

  @override
  List<MineralEvent> events = [];

  @override
  List<MineralStore> stores = [];
}
  ''';
}
