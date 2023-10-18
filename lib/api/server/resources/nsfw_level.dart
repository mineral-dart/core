final class NsfwLevel {
  static NsfwLevel initial = NsfwLevel._(0, "Default");
  static NsfwLevel explicit = NsfwLevel._(1, "Explicit");
  static NsfwLevel safe = NsfwLevel._(2, "Safe");
  static NsfwLevel ageRestricted = NsfwLevel._(3, "Age restricted");

  final int value;
  final String description;

  const NsfwLevel._(this.value, this.description);

  factory NsfwLevel.of(final int value) => switch (value) {
    0 => NsfwLevel.initial,
    1 => NsfwLevel.explicit,
    2 => NsfwLevel.safe,
    3 => NsfwLevel.ageRestricted,
    _ => throw ArgumentError('Unknown NSFW level: $value'),
  };
}