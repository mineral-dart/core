
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
  Future<void> handle (ArgResults args) async {
    if (args.arguments.length == 1) {
      Console.error(message: 'The name argument is not defined');
      return;
    }

    String filename = args.arguments.elementAt(1).capitalCase;

    final eventKey = Select(
      prompt: 'Which event would you like to use ?',
      options: Events.values.map((e) => e.toString()).toList(),
    ).interact();

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
    await writeFileContent(file, getTemplate(filename, Events.values.elementAt(eventKey)));

    Console.success(message: 'File created : ${file.uri}');
    Console.warn(message: 'Don\'t forget to add your file to the main or module file');
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
class ${filename.capitalCase} extends MineralEvent {
  Future<void> handle (${params.join(', ')}) async {
    // Your code here
  }
}
    ''';
  }
}
