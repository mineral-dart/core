extension type Snowflake(String value) {
  static Snowflake? nullable(Object? value) {
    return switch (value) {
      final String value => Snowflake(value),
      final int value => Snowflake(value.toString()),
      _ => null,
    };
  }

  factory Snowflake.parse(dynamic value) {
    return switch (value) {
      final String value => Snowflake(value),
      final int value => Snowflake(value.toString()),
      _ => throw ArgumentError('Invalid value $value'),
    };
  }

  bool equals(String value) => this.value == value;
}
