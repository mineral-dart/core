import 'dart:io';

import 'package:mineral_cli/mineral_cli.dart';
import 'package:path/path.dart';

class CompileJavascript extends CliCommand {
  CompileJavascript(Console console): super(console, 'compile:js', 'Compile your application to an javascript file', []);

  @override
  Future<void> handle(args) async {
    console.info('The compilation of your application will start, please wait..');

    final Directory directory = Directory(join(Directory.current.path, 'dist', 'js'));
    await directory.create(recursive: true);

    ProcessResult process = await Process.run('dart', ['compile', 'js', './src/main.dart', '-o', 'dist/js/mineral.js']);

    switch (process.exitCode) {
      case 0:
        console.success('Your application is compiled in ${directory.uri}');
        break;
      default: {
        print(process.stderr);
      }
    }
  }
}