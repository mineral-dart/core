extension type Snowflake(String value) {
  static Snowflake? nullable(String? value) => switch(value) {
    final String value => Snowflake(value),
    _ => null,
  };

  bool equals(String value) => this.value == value;
}
