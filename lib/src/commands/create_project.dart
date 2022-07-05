import 'dart:io';

import 'package:args/args.dart';
import 'package:mineral/console.dart';
import 'package:mineral/helper.dart';
import 'package:mineral/src/internal/entities/cli_manager.dart';
import 'package:path/path.dart';

class CreateProject extends MineralCliCommand {
  @override
  String name = 'create';

  @override
  Future<void> handle(ArgResults args) async {
    if (args.arguments.length == 1) {
      Console.error(message: 'The name argument is not defined');
      return;
    }

    String filename = Helper.toSnakeCase(args.arguments.elementAt(1));

    final projectDirectory = Directory(join(Directory.current.path, filename));

    ProcessResult process = await Process.run('git', ['clone', 'https://github.com/mineral-dart/base-structure.git', Helper.toSnakeCase(filename)]);

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
