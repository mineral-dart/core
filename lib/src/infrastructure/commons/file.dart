import 'dart:convert';
import 'dart:io';

import 'package:yaml/yaml.dart';

extension YamlFile on File {
  Future<T> readAsYaml<T extends dynamic>(
      {T Function(Map<String, dynamic> payload)? constructor}) async {
    final stringifyContent = await readAsString();
    final YamlMap yamlContent = loadYaml(stringifyContent);
    final Map<String, dynamic> map = {};

    for (final entry in yamlContent.entries) {
      map[entry.key.toString()] = entry.value;
    }

    return constructor != null ? constructor(map) : map;
  }

  T readAsYamlSync<T extends dynamic>(
      {T Function(Map<String, dynamic> payload)? constructor}) {
    final stringifyContent = readAsStringSync();
    final YamlMap yamlContent = loadYaml(stringifyContent);
    final Map<String, dynamic> map = {};

    for (final entry in yamlContent.entries) {
      map[entry.key.toString()] = entry.value;
    }

    return constructor != null ? constructor(map) : map;
  }
}

extension JsonFile on File {
  Future<T> readAsJson<T extends dynamic>(
      {T Function(Map<String, dynamic> payload)? constructor}) async {
    final content = await readAsString();
    final Map<String, dynamic> map = jsonDecode(content);

    return constructor != null ? constructor(map) : map;
  }

  T readAsJsonSync<T extends dynamic>(
      {T Function(Map<String, dynamic> payload)? constructor}) {
    final content = readAsStringSync();
    final Map<String, dynamic> map = jsonDecode(content);

    return constructor != null ? constructor(map) : map;
  }
}

extension YamlWriter<K, V> on Map<K, V> {
  void writeAsYaml({required StringBuffer buffer, required List<MapEntry> payload, int spacing = 2}) {
    for (final entry in payload) {
      final spaces = ' ' * spacing;

      if (entry.value is String) {
        buffer.writeln('$spaces${entry.key}: ${entry.value}');
      } else if (entry.value is Map) {
        buffer.writeln('$spaces${entry.key}:');

        writeAsYaml(
            buffer: buffer,
            payload: (entry.value as dynamic).entries.toList(),
            spacing: spacing + 2);
      }
    }
  }
}
