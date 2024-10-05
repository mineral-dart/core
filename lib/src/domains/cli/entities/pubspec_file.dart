import 'dart:convert';
import 'dart:io';

import 'package:mineral/src/domains/cli/entities/mineral_pubspec_context.dart';
import 'package:mineral/src/domains/cli/entities/pubspec_dependency.dart';
import 'package:path/path.dart';

final class PubspecFile {
  final String location;
  final String name;
  final String version;
  final String description;
  final List<PubSpecDependency> dependencies;
  final MineralPubSpecContext? mineral;

  PubspecFile({
    required this.location,
    required this.name,
    required this.version,
    required this.description,
    required this.dependencies,
    this.mineral,
  });

  Future<void> loadDependencies() async {
    final dependenciesMapperFile = File('.dart_tool/package_config.json');
    final content = await dependenciesMapperFile.readAsString();
    final jsonContent = json.decode(content);

    for (final dependency in jsonContent['packages']) {
      final String rootLoc = dependency['rootUri'];
      final path = rootLoc.startsWith('..')
          ? join(Directory.current.path, rootLoc.replaceFirst('../', ''))
          : rootLoc.replaceAll('file://', '');

      final dep = PubSpecDependency(
        name: dependency['name'],
        location: path,
      );

      dependencies.add(dep);
    }
  }

  factory PubspecFile.fromJson(String location, Map<String, dynamic> json) {

    return PubspecFile(
      location: location,
      name: json['name'],
      version: json['version'],
      description: json['description'],
      dependencies: [],
      mineral: json['mineral'] != null
          ? MineralPubSpecContext.fromJson(location, json['mineral'])
          : null,
    );
  }
}
