import 'dart:convert';
import 'dart:io';

import 'package:mineral/framework.dart';
import 'package:mineral_contract/mineral_contract.dart';
import 'package:path/path.dart';

class EnvironmentService extends EnvironmentServiceContract with Console {
  final Map<String, String> _cache = Map.from(Platform.environment);

  EnvironmentService(): super(inject: true);

  Future<void> load () async {
    if (hasValidEnvironment()) {
      _cache.putIfAbsent('APP_TOKEN', () => Platform.environment.getOrFail('APP_TOKEN'));
      _cache.putIfAbsent('LOG_LEVEL', () => Platform.environment.getOrFail('LOG_LEVEL'));
      _cache.putIfAbsent('DEBUGGER', () => Platform.environment.getOrFail('DEBUGGER'));
    }

    File file = File(join(Directory.current.path, '.env'));
    if (!await file.exists()) {
      await createEnvironmentFile();
      exit(0);
    }

    List<String> content = await file.readAsLines(encoding: utf8);

    for (String line in content) {
      if (line.isNotEmpty) {
        List<String> content = line.split(':');
        String key = content.removeAt(0).trim();
        String value = content.join(':').trim();

        _cache.putIfAbsent(key, () => value);
      }
    }
  }

  Future<void> createEnvironmentFile () async {
    String token = '';
    console.info('We will create your environment file..');

    final environmentFile = File(join(Directory.current.path, '.env'));
    final sink = environmentFile.openWrite();
    sink.write(['APP_NAME: My mineral application', 'APP_TOKEN: $token', 'LOG_LEVEL: info', 'REPORTER: debug'].join('\n'));

    await sink.flush();
    await sink.close();
  }

  bool hasValidEnvironment () {
    final requiredEnvironmentKeys = ['APP_TOKEN', 'APP_NAME', 'LOG_LEVEL', 'DEBUGGER'];
    final requiredKeysChecked = requiredEnvironmentKeys.fold([], (previousValue, element) => [...previousValue, Platform.environment.get(element) != null]);

    return !requiredKeysChecked.contains(false);
  }

  @override
  Map<String, String> get data => _cache;

  @override
  T get<T> (String key, { T? defaultValue }) => (_cache[key] ?? defaultValue) as T;

  @override
  T getOrFail<T> (String key, { String? message }) {
    final result = get(key);
    _exist(key, result);

    return result as T;
  }

  void _exist<T> (String key, T result, { String? message }) {
    if (result == null) {
      throw Exception(message ?? 'No values are attached to $key key.');
    }
  }

  @override
  void delete(String key) {
    _cache.remove(key);
  }

  @override
  bool has(String key) => _cache.containsKey(key);
}