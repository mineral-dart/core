import 'dart:io';

import 'package:mineral/src/commands/templates/command.dart';
import 'package:mineral/src/internal/services/console/console_service.dart';
import 'package:mineral_contract/mineral_contract.dart';
import 'package:path/path.dart';
import 'package:prompts/prompts.dart' as prompts;
import 'package:recase/recase.dart';

class MakeCommand extends CliCommandContract {
  MakeCommand(ConsoleService console): super(console, 'make:command', 'Create new command file', ['name']);

  @override
  Future<void> handle(Map args) async {
    final placeInRootFolder = prompts.getBool('Would you like to change the location of your ?', defaultsTo: false);

    if (!placeInRootFolder) {
      final file = File(join(Directory.current.path, 'src', '${ReCase(args['name']).snakeCase}.dart'));
      _createFile(file, args);
      return;
    }

    final location = prompts.get('Where do you want to create your command file ?');
    final file = File(join(Directory.current.path, 'src', location, '${ReCase(args['name']).snakeCase}.dart'));

    await _createFile(file, args);
  }

  Future<void> _createFile (File file, Map args) async {
    await file.create(recursive: true);

    final sink = file.openWrite();
    sink.write(template
      .replaceAll('&ClassName', ReCase(args['name']).pascalCase)
      .replaceAll('&FilenameLowerCase', args['name'].toLowerCase())
      .replaceAll('&FilenameCapitalCase', ReCase(args['name']).pascalCase));

    await sink.close();

    console.success('The file was created in ${file.uri}');
  }
}