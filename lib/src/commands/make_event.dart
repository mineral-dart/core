
import 'dart:io';

import 'package:mineral/api.dart';
import 'package:mineral/console.dart';
import 'package:path/path.dart';
import 'package:args/args.dart';
import 'package:interact/interact.dart';
import 'package:mineral/core.dart';
import 'package:mineral/src/internal/managers/cli_manager.dart';

class MakeEvent extends MineralCliCommand {
  @override
  String name = 'make:event';

  @override
  String description = 'Make a new event file';

  @override
  Future<void> handle (ArgResults args) async {
    if (args.arguments.length == 1) {
      Console.error(message: 'The name argument is not defined');
      return;
    }

    String filename = args.arguments.elementAt(1).capitalCase;

    final event = Console.cli.choice(
      label: 'Which event would you like to use ?',
      list: Events.values,
      items: Events.values.map((e) => e.toString()).toList()
    );

    final useExistLocation = Confirm(
      prompt: 'Do you want to use an existing location on your disk ?',
      defaultValue: true,
    ).interact();

    late File file;

    if (useExistLocation) {
      List<Directory> directories = await getDirectories();

      final location = Console.cli.choice(
        label: 'Where do you want to place your file ?',
        list: directories,
        items: directories.map((directory) => directory.path
          .replaceAll(join(Directory.current.path, 'src'), 'App')
          .replaceAll('\\', '/'))
          .toList()
      );

      file = File(join(location.path, '${filename.snakeCase}.dart'));
    } else {
      final location = Input(
        prompt: 'Target folder location',
        defaultValue: 'App/folder', // optional, will provide the user as a hint
      ).interact();

      file = File(join(Directory.current.path, 'src', location.replaceAll('App/', '').replaceAll('App', ''), '${filename.snakeCase}.dart'));
    }

    await file.create(recursive: true);
    await writeFileContent(file, getTemplate(filename, event));

    Console.cli.success(message: 'File created ${file.uri}');
  }

  String getTemplate (String filename, Events event) {
    List<String> params = [];
    for (MapEntry<String, dynamic> param in event.params.entries) {
      params.add('${param.value} ${param.key}');
    }

    return '''
import 'package:mineral/core.dart';
import 'package:mineral/api.dart';

@Event(${event.toString()})
class ${filename.pascalCase} extends MineralEvent {
  Future<void> handle (${params.join(', ')}) async {
    // Your code here
  }
}
    ''';
  }
}
