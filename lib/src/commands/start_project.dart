import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';
import 'package:mineral/console.dart';
import 'package:mineral/src/exceptions/code_error_exception.dart';
import 'package:mineral/src/internal/managers/cli_manager.dart';
import 'package:path/path.dart';

class StartProject extends MineralCliCommand {
  @override
  String name = 'start';

  @override
  String description = 'Start the current mineral project';

  @override
  Future<void> handle(ArgResults args) async {
    Console.info(message: 'Starting project..');
    final projectDirectory = Directory(join(Directory.current.path, 'src', 'main.dart'));

    Process process = await Process.start('dart', ['run', projectDirectory.path]);
    process.stdout
      .transform(utf8.decoder)
      .forEach(stdout.write);

    await process.stderr.forEach((error) async {
      switch (await process.exitCode) {
        case 254:
          throw CodeErrorException(prefix: 'Code error', cause: String.fromCharCodes(error));
        default:
          print(process.stderr);
      }
    });
  }
}
