import 'dart:io';

import 'package:mineral/internal/fold/container.dart';
import 'package:mineral/internal/fold/injectable.dart';
import 'package:path/path.dart';

/// A class to handle environment variables
/// ```dart
/// final Environment env = Environment();
/// ```
class Environment extends Injectable {
  final Map<String, String> _env = Map.from(Platform.environment);

  Environment._internal() {
    File env = File(join(Directory.current.path, '.env'));

    if (env.existsSync()) {
      for (final line in env.readAsLinesSync()) {
        final [key, value] = line.split('=');
        add(key, value.trim());
      }
    }
  }

  factory Environment() => Environment._internal();
  factory Environment.singleton() => container.use<Environment>('environment');

  /// Creates a new environment file
  /// ```dart
  /// final Environment env = Environment();
  /// await env.createEnvironmentFile();
  /// ```
  Future<void> createEnvironmentFile () async {
    final File env = File(join(Directory.current.path, '.env'));
    await env.create();
  }

  /// Writes into the environment file
  /// ```dart
  /// final Environment env = Environment();
  /// env.write({ 'foo': 'bar' });
  /// ```
  void write (Map<String, dynamic> values) {
    final File env = File(join(Directory.current.path, '.env'));
    final sink = env.openWrite();

    sink.write(List.from(values.entries.map((e) => '${e.key}=${e.value}')));

    sink.flush();
    sink.close();
  }

  /// Adds a new environment variable
  /// ```dart
  /// final Environment env = Environment();
  /// env.add('foo', 'bar');
  /// ```
  void add (String key, String value) {
    _env.putIfAbsent(key, () => value);
  }

  /// Sets a new environment variable. Can be used to override existing variables
  /// ```dart
  /// final Environment env = Environment();
  /// env.set('foo', 'bar');
  /// ```
  void set (String key, String value) {
    _env[key] = value;
  }

  /// Gets an environment variable
  /// ```dart
  /// final Environment env = Environment();
  /// final String? foo = env.get<String>('foo');
  /// ```
  T? get<T> (String key) => switch (T) {
    int => int.parse(_env[key]!),
    double => double.parse(_env[key]!),
    String => _env[key],
    bool => _env[key] == 'true',
    _ => _env[key]
  } as T;

  /// Gets an environment variable or throws an exception if it doesn't exist
  /// ```dart
  /// final Environment env = Environment();
  ///
  /// final String? foo = env.getOrFail<String>('foo');
  /// final String? foo = env.getOrFail<String>('foo', message: 'Foo not found');
  /// ```
  T getOrFail<T> (String key, { String? message }) {
    if (!_env.containsKey(key)) {
      throw Exception(message ?? 'Environment variable $key not found');
    }

    return get<T>(key)!;
  }

  /// Removes an environment variable
  /// ```dart
  /// final Environment env = Environment();
  /// env.remove('foo');
  /// ```
  void remove (String key) {
    _env.remove(key);
  }
}