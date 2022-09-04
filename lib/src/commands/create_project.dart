import 'dart:io';

import 'package:args/args.dart';
import 'package:mineral/api.dart';
import 'package:mineral/console.dart';
import 'package:mineral/src/internal/managers/cli_manager.dart';
import 'package:path/path.dart';

class CreateProject extends MineralCliCommand {
  @override
  String name = 'create';

  @override
  String description = 'Create new mineral project';

  @override
  Future<void> handle(ArgResults args) async {
    if (args.arguments.length == 1) {
      Console.error(message: 'The name argument is not defined');
      return;
    }

    String filename = args.arguments.elementAt(1).snakeCase;

    final projectDirectory = Directory(join(Directory.current.path, filename));

    ProcessResult process = await Process.run('git', ['clone', 'https://github.com/mineral-dart/base-structure.git', filename.snakeCase]);

    switch (process.exitCode) {
      case 0:
        final gitDirectory = Directory(join(projectDirectory.path, '.git'));
        await gitDirectory.delete(recursive: true);

        Console.success(message: 'Project $filename has been created at the following location ${projectDirectory.uri}');
        break;
      case 128:
        Console.error(message: 'Path ${projectDirectory.uri} already exists, please select another one.');
        break;

      default: {
        print(process.stderr);
      }
    }
  }
}
