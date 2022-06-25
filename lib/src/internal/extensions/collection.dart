extension Collection<K, V> on Map<K, V> {
  T? get<T extends V?> (K? key) => this[key] as T?;

  void set (K key, V value) {
    this[key] = value;
  }
}
