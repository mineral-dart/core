extension Collection<K, V> on Map<K, V> {
  /// Returns the value associated from the [key] parameter
  /// ```dart
  /// Channel? channel = guild.channels.cache.get('991686152585232404');
  /// print(channel);
  /// ```
  T? get<T extends V?> (K? key) => this[key] as T?;

  /// Inserts or replaces data in the collection
  /// ```dart
  /// Channel channel = Channel.from({...});
  /// guild.channels.cache.set(channel.id, channel);
  /// ```
  void set (K key, V value) => this[key] = value;

  /// Replaces the value associated with a key if it exists
  /// ```dart
  /// Channel channel = Channel.from({...});
  /// guild.channels.cache.overrideIfPresent(channel.id, () => channel);
  /// ```
  V? overrideIfPresent (K key, V Function() ifPresent) {
    if (this[key] != null) this[key] = ifPresent();
    return this[key];
  }
}
