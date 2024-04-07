import 'dart:io';
import 'package:yaml/yaml.dart';

extension YamlFile on File {
  Future<T> readAsYaml<T extends dynamic>({T Function(Map<dynamic, dynamic> payload)? constructor}) async {
    final stringifyContent = await readAsString();
    final YamlMap yamlContent = loadYaml(stringifyContent);
    final Map<String, dynamic> map = {};

    for (final entry in yamlContent.entries) {
      map[entry.key.toString()] = entry.value;
    }

    return constructor != null ? constructor(map) : map;
  }

  T readAsYamlSync<T extends dynamic>({T Function(Map<dynamic, dynamic> payload)? constructor}) {
    final stringifyContent = readAsStringSync();
    final YamlMap yamlContent = loadYaml(stringifyContent);
    final Map<String, dynamic> map = {};

    for (final entry in yamlContent.entries) {
      map[entry.key.toString()] = entry.value;
    }

    return constructor != null ? constructor(map) : yamlContent;
  }
}
