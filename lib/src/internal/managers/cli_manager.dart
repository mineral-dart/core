import 'dart:io';

import 'package:args/args.dart';
import 'package:path/path.dart';

class CliManager {
  final Map<String, MineralCliCommand> _commands = {};

  Map<String, MineralCliCommand> get commands => _commands;

  add (MineralCliCommand command) {
    _commands.putIfAbsent(command.name, () => command);
  }
}

abstract class MineralCliCommand {
  abstract String name;
  Future<void> handle (ArgResults args);

  Future<List<Directory>> getDirectories () async {
    List<Directory> directories = [];
    directories.add(Directory(join(Directory.current.path, 'src')));

    Stream<FileSystemEntity> files = Directory(join(Directory.current.path, 'src')).list(recursive: true);

    await files.forEach((element) {
      if (element is Directory) {
        directories.add(element);
      }
    });

    return directories;
  }

  Future<void> writeFileContent (File file, String content) async {
    var sink = file.openWrite();
    sink.write(content);

    await sink.flush();
    await sink.close();
  }
}
