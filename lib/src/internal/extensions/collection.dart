import 'package:collection/collection.dart';
import 'package:mineral/src/exceptions/not_exist.dart';

extension Collection<K, V> on Map<K, V> {
  /// Returns the value associated from the [K] parameter
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

  /// Returns the value associated from the [K] parameter
  /// ```dart
  /// Channel channel = guild.channels.cache.getOrFail('991686152585232404');
  /// print(channel);
  /// ```
  /// You can define an error customized message
  /// ```dart
  /// Channel channel = guild.channels.cache.getOrFail('991686152585232404', message: 'Channel is undefined');
  /// print(channel);
  /// ```
  T getOrFail<T extends V> (K? key, { String? message }) {
    final T? result = get(key);
    if (result == null) {
      throw NotExist(prefix: 'Invalid value', cause: message ?? 'No values are attached to $key key.');
    }

    return result;
  }

  /// Returns the first element satisfying test, or null if there are none.
  /// ```dart
  /// Channel? channel = guild.channels.cache.find((channel) => channel.id == '991686152585232404');
  /// print(channel);
  /// ```
  T? find<T extends V> (bool Function(V element) callback) {
    final MapEntry<K, V>? result = entries.firstWhereOrNull((item) => callback(item.value));
    return result?.value as T?;
  }

  /// Returns the first element satisfying test, or throw if there are none.
  /// ```dart
  /// Channel? channel = guild.channels.cache.find((channel) => channel.id == '991686152585232404');
  /// print(channel);
  /// ```
  /// You can define an error customized message
  /// ```dart
  /// Channel channel = guild.channels.cache.find((channel) => channel.id == '991686152585232404', message: 'Channel is undefined');
  /// print(channel);
  /// ```
  T findOrFail<T extends V> (bool Function(V element) callback, { String? message }) {
    final V? result = find(callback);
    if (result == null) {
      throw NotExist(prefix: 'Invalid value', cause: message ?? 'No values were found.');
    }

    return result as T;
  }
}
