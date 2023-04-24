import 'dart:io';

import 'package:mineral/src/internal/services/console/console_service.dart';
import 'package:mineral_contract/mineral_contract.dart';
import 'package:path/path.dart';

class CompileExecutable extends CliCommandContract {
  CompileExecutable(ConsoleService console): super(console, 'compile:exe', 'Compile your application to an executable file', []);

  @override
  Future<void> handle(args) async {
    console.info('The compilation of your application will start, please wait..');

    final Directory directory = Directory(join(Directory.current.path, 'dist', 'executable'));
    await directory.create(recursive: true);

    ProcessResult process = await Process.run('dart', ['compile', 'exe', './src/main.dart', '-o', 'dist/executable/mineral.exe']);

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