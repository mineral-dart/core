import 'dart:io';

import 'package:args/args.dart';
import 'package:interact/interact.dart';
import 'package:mineral/console.dart';
import 'package:mineral/helper.dart';
import 'package:mineral/src/internal/entities/cli_manager.dart';
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

    String filename = Helper.toCapitalCase(args.arguments.elementAt(1));

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

      directory = Directory(join(directories[selection].path, Helper.toSnakeCase(filename)));
      file = File(join(directory.path, '${Helper.toSnakeCase(filename)}.dart'));
    } else {
      final location = Input(
        prompt: 'Target folder location',
        defaultValue: 'App/folder',
      ).interact();

      directory = Directory(join(Directory.current.path, 'src', location.replaceAll('App/', ''), Helper.toSnakeCase(filename)));
      file = File(join(directory.path, '${Helper.toSnakeCase(filename)}.dart'));
    }

    await Directory(join(directory.path, 'events')).create(recursive: true);
    await Directory(join(directory.path, 'commands')).create(recursive: true);
    await Directory(join(directory.path, 'stores')).create(recursive: true);

    await file.create(recursive: true);
    await writeFileContent(file, getTemplate(filename));

    Console.success(message: 'The file was created in the location ${file.uri}');
    Console.success(message: 'Don\'t forget to add your file to the main.dart file');
  }

  String getTemplate (String filename) => '''
import 'package:mineral/core.dart';

@Module(identifier: '${Helper.toSnakeCase(filename)}', label: '${Helper.toCapitalCase(filename)} module')
class ${Helper.toPascalCase(filename)} extends MineralModule {
  @override
  List<MineralCommand> commands = [];

  @override
  List<MineralEvent> events = [];

  @override
  List<MineralStore> stores = [];
}
  ''';
}
