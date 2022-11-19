import 'dart:convert';
import 'dart:io';

import 'package:interact/interact.dart';
import 'package:mineral/framework.dart';
import 'package:mineral/src/exceptions/not_exist.dart';
import 'package:mineral_ioc/ioc.dart';
import 'package:path/path.dart';

abstract class EnvironmentContract {
  /// Map including all environment variables
  Map<String, String> get data;

  /// Get environment key from .env file as [T]
  T get<T> (String key, { T? defaultValue });

  /// Get environment key from .env file as T
  T getOrFail<T> (String key, { String? message });
}

class Environment extends MineralService implements EnvironmentContract {
  final Map<String, String> _cache = Map.from(Platform.environment);

  Environment(): super(inject: true);

  @override
  Map<String, String> get data => _cache;

  Future<Environment> load () async {
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

    return this;
  }

  @override
  T get<T> (String key, { T? defaultValue }) => (_cache.get(key) ?? defaultValue) as T;

  @override
  T getOrFail<T> (String key, { String? message }) {
    final result = get(key);
    _exist(key, result);

    return result as T;
  }

 void _exist<T> (String key, T result, { String? message }) {
   if (result == null) {
     throw NotExist(prefix: 'Missing value', cause: message ?? 'No values are attached to $key key.');
   }
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

    final environmentFile = File(join(Directory.current.path, '.env'));
    final sink = environmentFile.openWrite();
    sink.write(['APP_NAME: My mineral application', 'APP_TOKEN: $token', 'LOG_LEVEL: info', 'REPORTER: debug'].join('\n'));

    await sink.flush();
    await sink.close();
  }
}
