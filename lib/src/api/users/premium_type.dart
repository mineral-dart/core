enum PremiumType {
  /// The user does not have a premium subscription.
  none(0),

  /// The user has a classic subscription.
  classicNitro(1),

  /// The user has a premium subscription.
  nitro(2),

  /// The user has a basic subscription.
  basicNitro(3);

  final int value;
  const PremiumType(this.value);
}