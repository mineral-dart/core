import 'dart:io';
import 'package:mineral/src/internal/services/console/console_service.dart';
import 'package:mineral_contract/mineral_contract.dart';
import 'package:prompts/prompts.dart' as prompts;

import 'package:mineral/src/commands/templates/module.dart';
import 'package:path/path.dart';
import 'package:recase/recase.dart';

class MakePackage extends CliCommandContract {
  MakePackage(ConsoleService console): super(console, 'make:package', 'Create new package structure', ['name']);

  @override
  Future<void> handle(Map args) async {
    final placeInRootFolder = prompts.getBool('Would you like to change the location of your ?', defaultsTo: false);
    final Directory directory = Directory(join(Directory.current.path, 'src', ReCase(args['name']).snakeCase));

    if (!placeInRootFolder) {
      final file = File(join(directory.path, '${ReCase(args['name']).snakeCase}.dart'));
      _createFile(directory, file, args);
      return;
    }

    final location = prompts.get('Where do you want to create your package ?');
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