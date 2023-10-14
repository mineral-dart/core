import 'dart:collection';

import 'package:mineral/api/common/snowflake.dart';

class Collection<K, V> extends MapBase<K, V> {
  final Map<K, V> _map = HashMap.identity();

  V? get(K key) {
    final element = key is Snowflake
        ? _map.entries.firstWhere((element) => (element.key as Snowflake).value == key.value).value
        : _map[key];

    return element;
  }

  V getOrFail(K key, { String? message }) {
    final element = key is Snowflake
      ? _map.entries.firstWhere((element) => (element.key as Snowflake).value == key.value).value
      : _map[key];

    return element ?? (throw Exception(message ?? 'Key $key not found in $V collection'));
  }

  @override
  void clear() =>_map.clear();

  @override
  Iterable<K> get keys => _map.keys;

  @override
  V? remove(Object? key) => _map.remove(key);

  @override
  operator [](Object? key) => _map[key];

  @override
  void operator []=(key, value) => _map[key] = value;
}