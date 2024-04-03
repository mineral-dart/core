import 'dart:io';

import 'package:mineral/application/container/ioc_container.dart';
import 'package:mineral/application/environment/env_schema.dart';

abstract interface class EnvContract {
  Map<String, String> get list;

  T get<T>(EnvSchema variable);

  void validate(List<EnvSchema> values);
}

final class Environment implements EnvContract {
  final Map<String, String> _values = {};

  Environment() {
    loadEnvironment();
  }

  @override
  Map<String, String> get list => _values;

  T getRawOrFail<T>(String key) {
    final value = _values.entries
        .firstWhere((element) => element.key == key,
            orElse: () => throw Exception('Environment variable $key not found'))
        .value;

    return switch (T) {
      int => int.parse(value),
      double => double.parse(value),
      bool => bool.parse(value),
      _ => value,
    } as T;
  }

  @override
  T get<T>(EnvSchema variable) {
    final value = _values.entries
        .firstWhere((element) => element.key == variable.key,
            orElse: () => throw Exception('Environment variable ${variable.key} not found'))
        .value;

    return switch (T) {
      int => int.parse(value),
      double => double.parse(value),
      bool => bool.parse(value),
      _ => value,
    } as T;
  }

  @override
  void validate(List<EnvSchema> values) {
    for (final key in values) {
      get(key);
    }
  }

  void loadEnvironment() {
    final dir = Directory.current;
    final elements = dir.listSync();

    final environments = elements
        .where((element) => element is File && element.uri.pathSegments.last.contains('.env'))
        .toList();

    final orderedFiles = orderEnvFiles(environments);
    if (orderedFiles.isNotEmpty) {
      final environment = orderedFiles.first;

      final lines = File.fromUri(environment.uri).readAsLinesSync();
      for (final line in lines.nonNulls.where((element) => element.isNotEmpty)) {
        final [key, value] = line.split('=');
        _values[key] = value;
      }
    }

    _values.addEntries(Platform.environment.entries);
  }

  List<FileSystemEntity> orderEnvFiles(List<FileSystemEntity> files) {
    files.sort((a, b) {
      final orderMap = {'.env.prod': 1, '.env.dev': 2, '.env': 3};
      final aOrder = orderMap[a.uri.pathSegments.last] ?? 4;
      final bOrder = orderMap[b.uri.pathSegments.last] ?? 4;

      return aOrder.compareTo(bOrder);
    });

    return files;
  }

  factory Environment.singleton() => ioc.resolve('environment');
}
