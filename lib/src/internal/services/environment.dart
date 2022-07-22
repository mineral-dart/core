import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as path;

class Environment {
  final Map<String, String> _cache = Map.from(Platform.environment);

  Future<Environment> load (String environment) async {
    File file = File(path.join(Directory.current.path, environment));
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
