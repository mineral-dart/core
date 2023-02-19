import 'package:collection/collection.dart';
import 'package:mineral/src/exceptions/not_exist_exception.dart';

extension Collection<K, V> on Map<K, V> {
  /// Returns the value associated from the [K] parameter
  ///
  /// Example :
  /// ```dart
  /// Channel? channel = guild.channels.cache.get('991686152585232404');
  /// print(channel);
  /// ```
  T? get<T extends V?> (K? key) => this[key] as T?;

  /// Returns the value associated from the [K] parameter or defined value
  ///
  /// Example :
  /// ```dart
  /// Channel firstChannel = guild.channels.cache.getOrFail('991686152585232404', defaultValue: myChannel );
  /// Channel? secondChannel = guild.channels.cache.getOr('991686152585232404', defaultValue: firstChannel );
  /// print(secondChannel);
  /// ```
  T? getOr<T extends V?> (K? key, Never Function() param1, { T? defaultValue }) {
    V? result = get(key);
    if (result == null && defaultValue != null) {
      return defaultValue;
    }
    return result as T;
  }

  /// Inserts or replaces data in the collection
  ///
  /// Example :
  /// ```dart
  /// Channel channel = Channel.from({...});
  /// guild.channels.cache.set(channel.id, channel);
  /// ```
  void set (K key, V value) => this[key] = value;

  /// Replaces the value associated with a key if it exists
  ///
  /// Example :
  /// ```dart
  /// Channel channel = Channel.from({...});
  /// guild.channels.cache.overrideIfPresent(channel.id, () => channel);
  /// ```
  V? overrideIfPresent (K key, V Function() ifPresent) {
    if (this[key] != null) this[key] = ifPresent();
    return this[key];
  }

  /// Returns the value associated from the [K] parameter
  ///
  /// Example :
  /// ```dart
  /// Channel channel = guild.channels.cache.getOrFail('991686152585232404');
  /// print(channel);
  /// ```
  /// You can define an error customized message
  ///
  /// Example :
  /// ```dart
  /// Channel channel = guild.channels.cache.getOrFail('991686152585232404', message: 'Channel is undefined');
  /// print(channel);
  /// ```
  T getOrFail<T extends V> (K? key, { String? message }) {
    final T? result = get(key);
    if (result == null) {
      throw NotExistException(message ?? 'No values are attached to $key key.');
    }

    return result;
  }

  /// Returns the first element satisfying test, or null if there are none.
  ///
  /// Example :
  /// ```dart
  /// Channel? channel = guild.channels.cache.find((channel) => channel.id == '991686152585232404');
  /// print(channel);
  /// ```
  T? find<T extends V> (bool Function(V element) callback) {
    final MapEntry<K, V>? result = entries.firstWhereOrNull((item) => callback(item.value));
    return result?.value as T?;
  }

  /// Returns the first element satisfying test, or throw if there are none.
  ///
  /// Example :
  /// ```dart
  /// Channel? channel = guild.channels.cache.find((channel) => channel.id == '991686152585232404');
  /// print(channel);
  /// ```
  /// You can define an error customized message
  ///
  /// Example :
  /// ```dart
  /// Channel channel = guild.channels.cache.find((channel) => channel.id == '991686152585232404', message: 'Channel is undefined');
  /// print(channel);
  /// ```
  T findOrFail<T extends V> (bool Function(V element) callback, { String? message }) {
    final V? result = find(callback);
    if (result == null) {
      throw NotExistException(message ?? 'No values were found.');
    }

    return result as T;
  }

  Map<K, T> where<T extends V> (bool Function(V element) callback) {
    Map<K, T> result = {};
    forEach((key, value) {
      if (callback(value)) {
        result.putIfAbsent(key, () => value as T);
      }
    });

    return result;
  }

  Map<K, V> get clone => Map.from(this);
}
