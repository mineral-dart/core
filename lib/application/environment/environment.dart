import 'dart:io';

import 'package:collection/collection.dart';

abstract interface class EnvironmentContract {}

final class Environment implements EnvironmentContract {
  final Map<String, String> _values = Map.fromEntries(Platform.environment.entries);

  Environment() {
    final isContained = Platform.environment['DEPLOY_WITH_DOCKER'];

    if (isContained == null) {
      initFromDisk();
    }
  }

  T? getOrNull<T>(String key) {
    final value = _values.entries
        .firstWhereOrNull((element) => element.key == key)
        ?.value;

    return switch(T) {
      int => int.tryParse(value ?? ''),
      double => double.tryParse(value ?? ''),
      bool => bool.tryParse(value ?? ''),
      _ => value,
    } as T?;
  }

  T getOrFail<T>(String key) {
    final value = getOrNull<T>(key);

    if (value == null) {
      throw Exception('Environment variable $key not found');
    }

    return value;
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
    for (final line in lines) {
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
