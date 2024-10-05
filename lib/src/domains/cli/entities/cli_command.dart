import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:yaml/yaml.dart';

abstract interface class CliCommandContract {
  String get name;
  String get description;
  FutureOr handle(List<String> arguments);
}

final class MineralCommand {
  final String name;
  final String description;
  final File? entrypoint;
  final FutureOr Function(List<String>)? handle;

  MineralCommand({
    required this.name,
    required this.description,
    this.entrypoint,
    this.handle,
  });

  factory MineralCommand.fromJson(String root, YamlMap json) {
    return MineralCommand(
      name: json['name'],
      description: json['description'],
      entrypoint: File(join(root, json['entrypoint'])),
    );
  }
}
