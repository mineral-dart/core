import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:mineral/src/domains/cli/entities/cli_command.dart';
import 'package:mineral/src/domains/cli/entities/cli_context_type.dart';
import 'package:mineral/src/domains/cli/entities/mineral_pubspec_context.dart';
import 'package:mineral/src/domains/cli/entities/pubspec_file.dart';
import 'package:mineral/utils.dart';
import 'package:yaml/yaml.dart';

final class Cli {
  CliContextType context = CliContextType.unknown;

  final List<MineralCommand> commands = [];

  Future<bool> _getCurrentContext() async {
    final pubspecFile = File('pubspec.yaml');
    return pubspecFile.exists();
  }

  Future<void> _loadRemoteCommands() async {
    final pubspecFile = File('pubspec.yaml');
    final pubspecContent = await pubspecFile.readAsYaml();
    final pubspec = PubspecFile.fromJson(Directory.current.path, pubspecContent);

    _loadCommands(pubspec.mineral);

    await pubspec.loadDependencies();

    await Future.wait(pubspec.dependencies.map((dep) async {
      final file = File('${dep.location}/pubspec.yaml');
      final hasFile = await file.exists();

      if (hasFile) {
        final content = await file.readAsYaml();

        if (content['mineral'] case YamlMap()) {
          final depPubspec = PubspecFile.fromJson(dep.location, content);
          await depPubspec.loadDependencies();

          _loadCommands(depPubspec.mineral);
        }
      }
    }));
  }

  void _loadCommands(MineralPubSpecContext? mineral) {
    if (mineral?.commands case final List<MineralCommand> projectCommands) {
      commands.addAll(projectCommands);
    }
  }

  Future<void> _runCommand(List<String> arguments, MineralCommand command) async {
    print(command.description);
    if (command.handle
        case final Function(List<MineralCommand> commands, List<String> arguments) handle) {
      await handle(commands, arguments.skip(1).toList());
      return;
    }

    if (command.entrypoint case final File file) {
      final process = await Process.start('dart', [file.path]);

      process.stdout.listen((event) => print(utf8.decode(event)));
      process.stderr.listen((event) => print(utf8.decode(event)));

      await process.exitCode;
    }
  }

  Future<void> _findCommandAndRun(List<String> arguments) async {
    final targetCommand = commands.firstWhere((command) => command.name == arguments.firstOrNull,
        orElse: () => commands.firstWhere((command) => command.name == 'help'));

    return _runCommand(arguments, targetCommand);
  }

  void registerCommand(CliCommandContract command) {
    commands.add(MineralCommand(
        name: command.name,
        description: command.description,
        handle: (commands, List<String> arguments) => command.handle(commands, arguments)));
  }

  Future<void> handle(List<String> args) async {
    context = switch (await _getCurrentContext()) {
      true => CliContextType.project,
      false => CliContextType.global,
    };

    if (context == CliContextType.project) {
      await _loadRemoteCommands();
    }

    await _findCommandAndRun(args);
  }
}
