final class CommandOptions {
  final Map<String, dynamic> _values;

  const CommandOptions(this._values);

  T? get<T>(String name) {
    final value = _values[name];

    if (value == null) {
      return null;
    }

    if (value is! T) {
      throw ArgumentError.value(
        value.runtimeType,
        'type',
        'Option "$name" expected type $T but got ${value.runtimeType}',
      );
    }

    return value;
  }

  T require<T>(String name) {
    if (!_values.containsKey(name)) {
      throw ArgumentError.value(name, 'option', 'Required option is missing');
    }

    final value = _values[name];
    if (value is! T) {
      throw ArgumentError.value(
        value.runtimeType,
        'type',
        'Option "$name" expected type $T but got ${value.runtimeType}',
      );
    }

    return value;
  }

  bool has(String name) => _values.containsKey(name);

  Map<String, dynamic> toMap() => Map.unmodifiable(_values);

  @override
  String toString() => 'CommandOptions($_values)';
}
