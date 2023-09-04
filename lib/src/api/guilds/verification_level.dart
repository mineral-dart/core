enum VerificationLevel {
  /// Unrestricted
  none(0),

  /// Must have verified email on account
  low(1),

  /// Must be registered on Discord for longer than 5 minutes
  medium(2),

  /// Must be a member of the server for longer than 10 minutes
  high(3),

  /// Must have a verified phone number
  veryHigh(4);

  final int value;
  const VerificationLevel(this.value);
}