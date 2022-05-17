import 'dart:collection';

class Collection<K, V> implements Map<K, V> {
  final _base = {};
  bool Function(K)? _isValidKeyFn;

  Collection();

  Collection.from(Map<K, V> other, this._isValidKeyFn) {
    addAll(other);
  }

  @override
  V? operator [](Object? key) {
    if (!_isValidKey(key)) return null;
    var pair = _base[key as K];
    return pair?.value;
  }

  @override
  void operator []=(K key, V value) {
    if (!_isValidKey(key)) return;
    _base[key] = MapEntry(key, value);
  }

  @override
  void addAll(Map<K, V> other) {
    other.forEach((key, value) => this[key] = value);
  }

  @override
  void addEntries(Iterable<MapEntry<K, V>> entries) => _base.addEntries(entries
      .map((e) => MapEntry(e.key, e.value)));

  @override
  Map<K2, V2> cast<K2, V2>() => _base.cast<K2, V2>();

  @override
  void clear() {
    _base.clear();
  }

  T? get<T extends V?> (K? key) {
    return this[key] as T?;
  }

  @override
  bool containsKey(Object? key) {
    if (!_isValidKey(key)) return false;
    return _base.containsKey(key as K);
  }

  @override
  bool containsValue(Object? value) =>
      _base.values.any((pair) => pair.value == value);

  @override
  Iterable<MapEntry<K, V>> get entries =>
      _base.entries.map((e) => MapEntry(e.value.key, e.value.value));

  @override
  void forEach(void Function(K, V) f) {
    _base.forEach((key, pair) => f(pair.key, pair.value));
  }

  @override
  bool get isEmpty => _base.isEmpty;

  @override
  bool get isNotEmpty => _base.isNotEmpty;

  @override
  Iterable<K> get keys => _base.values.map((pair) => pair.key);

  @override
  int get length => _base.length;

  @override
  Map<K2, V2> map<K2, V2>(MapEntry<K2, V2> Function(K, V) transform) =>
      _base.map((_, pair) => transform(pair.key, pair.value));

  @override
  V putIfAbsent(K key, V Function() ifAbsent) {
    return _base
        .putIfAbsent(key, () => MapEntry(key, ifAbsent()))
        .value;
  }

  @override
  V? remove(Object? key) {
    if (!_isValidKey(key)) return null;
    var pair = _base.remove(key as K);
    return pair?.value;
  }

  @override
  void removeWhere(bool Function(K key, V value) test) {
    _base.removeWhere((_, pair) => test(pair.key, pair.value));
  }


  @override
  V update(K key, V Function(V) update, {V Function()? ifAbsent}) =>
      _base.update(key, (pair) {
        var value = pair.value;
        var newValue = update(value);
        if (identical(newValue, value)) return pair;
        return MapEntry(key, newValue);
      },
          ifAbsent:
          ifAbsent == null ? null : () => MapEntry(key, ifAbsent())).value;

  @override
  void updateAll(V Function(K key, V value) update) =>
      _base.updateAll((_, pair) {
        var value = pair.value;
        var key = pair.key;
        var newValue = update(key, value);
        if (identical(value, newValue)) return pair;
        return MapEntry(key, newValue);
      });

  @override
  Iterable<V> get values => _base.values.map((pair) => pair.value);

  @override
  String toString() => MapBase.mapToString(this);

  bool _isValidKey(Object? key) =>
      (key is K) && (_isValidKeyFn == null || _isValidKeyFn!(key));
}
