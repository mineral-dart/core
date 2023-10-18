final class PremiumTier {
  static PremiumTier none = PremiumTier._(0, "No boost");
  static PremiumTier firstTier = PremiumTier._(1, "Tier 1");
  static PremiumTier secondTier = PremiumTier._(2, "Tier 2");
  static PremiumTier thirdTier = PremiumTier._(3, "Tier 3");

  final int value;
  final String description;

  const PremiumTier._(this.value, this.description);

  factory PremiumTier.of(final int value) => switch (value) {
    0 => PremiumTier.none,
    1 => PremiumTier.firstTier,
    2 => PremiumTier.secondTier,
    3 => PremiumTier.thirdTier,
    _ => throw ArgumentError('Unknown premium tier: $value'),
  };
}