import 'dart:io';

import 'package:mineral/src/commands/templates/event.dart';
import 'package:mineral_cli/mineral_cli.dart';
import 'package:mineral_console/mineral_console.dart';
import 'package:path/path.dart';
import 'package:recase/recase.dart';

class MakeEvent extends CliCommand {
  MakeEvent(Console console): super(console, 'make:event', 'Create new event file', ['name']);

  @override
  Future<void> handle(Map args) async {
    final placeInRootFolder = Confirm('Would you like to change the location of your ?', defaultValue: false).build();

    if (!placeInRootFolder) {
      final file = File(join(Directory.current.path, 'src', '${ReCase(args['name']).snakeCase}.dart'));
      _createFile(file, args);
      return;
    }

    final location = Ask('Where do you want to create your event file ?').build();
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