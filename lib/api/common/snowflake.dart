final class Snowflake {
  final String value;

  Snowflake(this.value);

  @override
  int get hashCode => value.hashCode;

  @override
  bool operator ==(Object other) => switch (other) {
    Snowflake(value: final String value) => value == this.value,
    String() => value == other,
    _ => false
  };
}

