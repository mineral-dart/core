import 'dart:io';

import 'package:mineral/application/environment/environment_schema.dart';

abstract interface class EnvironmentContract {
  T get<T>(EnvironmentSchema variable);
}

final class Environment implements EnvironmentContract {
  final Map<String, String> _values = Map.fromEntries(Platform.environment.entries);

  Environment() {
    final isContained = Platform.environment['DEPLOY_WITH_DOCKER'];

    if (isContained == null) {
      initFromDisk();
    }
  }

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
  T get<T>(EnvironmentSchema variable) {
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

  void validate(List<EnvironmentSchema> values) {
    for (final key in values) {
      get(key);
    }
  }

  void initFromDisk() {
    final dir = Directory.current;
    final elements = dir.listSync();

    final environments = elements
        .where((element) => element is File && element.uri.pathSegments.last.contains('.env'))
        .toList();

    final orderedFiles = orderEnvFiles(environments);
    final environment = orderedFiles.first;

    final lines = File.fromUri(environment.uri).readAsLinesSync();
    for (final line in lines.nonNulls.where((element) => element.isNotEmpty)) {
      final [key, value] = line.split('=');
      _values[key] = value;
    }
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
}
