import 'dart:io';

import 'package:mineral/src/internal/services/console/console_service.dart';
import 'package:path/path.dart';

abstract class CliCommand {
  final ConsoleService _console;
  final String _name;
  final String _description;
  final List<String> _args;

  CliCommand(this._console, this._name, this._description, this._args);

  ConsoleService get console => _console;
  String get name => _name;
  String get description => _description;
  List<String> get arguments => _args;

  Future<void> handle (Map args);

  Future<List<Directory>> getDirectories (String location) async {
    List<Directory> directories = [];
    directories.add(Directory(join(Directory.current.path, location)));

    Stream<FileSystemEntity> files = Directory(join(Directory.current.path, location)).list(recursive: true);

    await files.forEach((element) {
      if (element is Directory) {
        directories.add(element);
      }
    });

    return directories;
  }
}
