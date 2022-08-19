import 'dart:convert';
import 'dart:io';
import 'package:mineral/src/exceptions/not_exist.dart';
import 'package:path/path.dart' as path;

class Environment {
  static String development = '.env';
  static String production = '.env.prod';

  final Map<String, String> _cache = Map.from(Platform.environment);

  Future<Environment> load (String environment) async {
    add('ENVIRONMENT', () => environment == '.env.prod' ? 'production' : 'development');

    File file = File(path.join(Directory.current.path, environment));

    if (!file.existsSync()) {
      throw NotExist(cause: 'The $environment file does not exist, please create one.');
    }

    List<String> content = await file.readAsLines(encoding: utf8);

    for (String line in content) {
      if (line.isNotEmpty) {
        List<String> content = line.split(':');
        String key = content[0].trim();
        String value = content[1].trim();

        _cache.putIfAbsent(key, () => value);
      }
    }

    return this;
  }

  String? get (String key) {
    return _cache[key];
  }

  Environment add (String key, dynamic value) {
    _cache.putIfAbsent(key, () => value);
    return this;
  }
}
