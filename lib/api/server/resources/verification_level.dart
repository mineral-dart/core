enum VerificationLevel {
  NONE(0, "Unrestricted"),
  LOW(1, "Must have verified email on account"),
  MEDIUM(2, "Must be registered on Discord for longer than 5 minutes"),
  HIGH(3, "Must be a member of the server for longer than 10 minutes"),
  VERY_HIGH(4, "Must have a verified phone number");

  final int value;
  final String description;

  const VerificationLevel(this.value, this.description);

  static VerificationLevel from(final int value) {
    switch (value) {
      case 0: return VerificationLevel.NONE;
      case 1: return VerificationLevel.LOW;
      case 2: return VerificationLevel.MEDIUM;
      case 3: return VerificationLevel.HIGH;
      case 4: return VerificationLevel.VERY_HIGH;
      default: throw ArgumentError('Unknown verification level: $value');
    }
  }
}