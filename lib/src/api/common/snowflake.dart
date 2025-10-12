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

  DateTime get createdAt {
    const discordEpochMs = 1420070400000;
    final intSnowflake = int.parse(value);
    final timestampMs = (intSnowflake >> 22) + discordEpochMs;
    return DateTime.fromMillisecondsSinceEpoch(timestampMs, isUtc: true);
  }

  int get internalWorkerId {
    final intSnowflake = int.parse(value);
    return (intSnowflake & 0x3E0000) >> 17;
  }

  int get internalProcessId {
    final intSnowflake = int.parse(value);
    return (intSnowflake & 0x1F000) >> 12;
  }

  int get increment {
    final intSnowflake = int.parse(value);
    return intSnowflake & 0xFFF;
  }
}
