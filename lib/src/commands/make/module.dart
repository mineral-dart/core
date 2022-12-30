import 'dart:io';

import 'package:mineral/src/commands/templates/module.dart';
import 'package:mineral_cli/mineral_cli.dart';
import 'package:mineral_console/mineral_console.dart';
import 'package:path/path.dart';
import 'package:recase/recase.dart';

class MakeModule extends CliCommand {
  MakeModule(Console console): super(console, 'make:module', 'Create new module structure', ['name']);

  @override
  Future<void> handle(Map args) async {
    final placeInRootFolder = Confirm('Would you like to change the location of your ?', defaultValue: false).build();
    final Directory directory = Directory(join(Directory.current.path, 'src', ReCase(args['name']).snakeCase));

    if (!placeInRootFolder) {
      final file = File(join(directory.path, '${ReCase(args['name']).snakeCase}.dart'));
      _createFile(directory, file, args);
      return;
    }

    final location = Ask('Where do you want to create your command file ?').build();
    final file = File(join(directory.path, location, '${ReCase(args['name']).snakeCase}.dart'));

    await _createFile(directory, file, args);
  }

  Future<void> _createFile (Directory directory, File file, Map args) async {
    await file.create(recursive: true);

    await Directory(join(directory.path, 'events')).create(recursive: true);
    await Directory(join(directory.path, 'commands')).create(recursive: true);
    await Directory(join(directory.path, 'states')).create(recursive: true);

    await file.create(recursive: true);
    final sink = file.openWrite();
    sink.write(template
      .replaceAll('&ClassName', ReCase(args['name']).pascalCase)
      .replaceAll('&FilenameLowerCase', args['name'].toLowerCase())
      .replaceAll('&FilenameCapitalCase', ReCase(args['name']).pascalCase)
      .replaceAll('&ClassNameSnakeCase', ReCase(args['name']).snakeCase));

    await sink.close();

    console.success('The file was created in ${file.uri}');
  }
}