import 'dart:io';
import 'package:mineral/src/internal/services/console/console_service.dart';
import 'package:mineral_contract/mineral_contract.dart';
import 'package:prompts/prompts.dart' as prompts;

import 'package:mineral/src/commands/templates/event.dart';
import 'package:path/path.dart';
import 'package:recase/recase.dart';

class MakeService extends CliCommandContract {
  MakeService(ConsoleService console): super(console, 'make:service', 'Create new service file', ['name']);

  @override
  Future<void> handle(Map args) async {
    final placeInRootFolder = prompts.getBool('Would you like to change the location of your ?', defaultsTo: false);

    if (!placeInRootFolder) {
      final file = File(join(Directory.current.path, 'src', '${ReCase(args['name']).snakeCase}.dart'));
      _createFile(file, args);
      return;
    }

    final location = prompts.get('Where do you want to create your service ?');
    final file = File(join(Directory.current.path, 'src', location, '${ReCase(args['name']).snakeCase}.dart'));
    await _createFile(file, args);
  }

  Future<void> _createFile (File file, Map args) async {
    await file.create(recursive: true);

    final sink = file.openWrite();
    sink.write(template.replaceAll('&ClassName', ReCase(args['name']).pascalCase));

    await sink.close();
  }
}