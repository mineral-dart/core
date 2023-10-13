final class Snowflake {
  final String _value;

  Snowflake(this._value);

  @override
  int get hashCode => _value.hashCode;

  @override
  bool operator ==(Object other) => switch (other) {
    Snowflake(_value: final String value) => _value == value,
    String() => _value == other,
    _ => false
  };
}

extension SnowflakeExtension on dynamic {
  Snowflake toSnowflake() => Snowflake(this);
}

