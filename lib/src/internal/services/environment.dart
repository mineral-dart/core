import 'dart:convert';
import 'dart:io';
import 'package:interact/interact.dart';
import 'package:mineral/console.dart';
import 'package:mineral/src/exceptions/not_exist.dart';
import 'package:path/path.dart' as path;

class Environment {
  final Map<String, String> _cache = Map.from(Platform.environment);

  Future<Environment> load () async {
    File file = File(path.join(Directory.current.path, '.env'));

    if (!await file.exists()) {
      await createEnvironmentFile();
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

    return this;

  }

  /// Get environment key from .env file
  String? get (String key) => _cache[key];

  /// Get environment key from .env file
  String getOrFail (String key, { String? message }) {
    final result = get(key);
    if (result == null) {
      throw NotExist(prefix: 'Missing value', cause: message ?? 'No values are attached to $key key.');
    }

    return result;
  }

  T? getOr<T extends dynamic> (String key, { T? defaultValue }) {
    T? result = get(key) as T?;
    if (result == null) {
      return defaultValue;
    }
    return result;
  }

  Environment add (String key, dynamic value) {
    _cache.putIfAbsent(key, () => value);
    return this;
  }

  Future<void> createEnvironmentFile () async {
    String token = '';
    Console.info(message: 'We will create your environment file..');

    final withToken = Confirm(
      prompt: 'Would you like to define your token now?',
      defaultValue: true,
    ).interact();
    
    if (!withToken) {
      Console.warn(message: 'Don\'t forget to set your token before restarting your application');
    } else {
      token = Input(prompt: 'What is your token ?').interact();
    }

    final environmentFile = File(path.join(Directory.current.path, '.env'));
    final sink = environmentFile.openWrite();
    sink.write('''
  APP_NAME: My mineral application
  APP_TOKEN: $token
  LOG_LEVEL: info
  REPORTER: debug
    ''');

    await sink.flush();
    await sink.close();
  }
}
