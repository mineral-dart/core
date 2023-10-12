import 'dart:collection';

class Collection<K, V> extends MapBase<K, V> {
  final Map<K, V> _map = HashMap.identity();

  V? get(K key) => _map[key];

  V getOrFail(K key, { String? message }) {
    final value = _map[key];

    return value ?? (throw Exception(message ?? 'Key $key not found in $V collection'));
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