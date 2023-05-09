import 'dart:io';

import 'package:mineral/src/internal/services/console/console_service.dart';
import 'package:mineral_contract/mineral_contract.dart';
import 'package:path/path.dart';

/// Base class for all [CliCommandContract] commands
abstract class CliCommand {
  final ConsoleService _console;
  final String _name;
  final String _description;
  final List<String> _args;

  CliCommand(this._console, this._name, this._description, this._args);

  /// The [ConsoleService] used to display messages in this
  ConsoleService get console => _console;

  /// The name of the command
  String get name => _name;

  /// The description of the command
  String get description => _description;

  /// The arguments of the command
  List<String> get arguments => _args;

  /// Handle the command line arguments to execute the given entry command.
  Future<void> handle (Map args);

  /// Get all directories from the given location
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
