final class MfaLevel {
  static MfaLevel none = MfaLevel._(0, "No MFA requirement for server members");
  static MfaLevel elevated = MfaLevel._(1, "MFA requirement for server members with a role");

  final int value;
  final String description;

  const MfaLevel._(this.value, this.description);

  factory MfaLevel.of(final int value) => switch (value) {
    0 => MfaLevel.none,
    1 => MfaLevel.elevated,
    _ => throw ArgumentError('Unknown MFA level: $value')
  };
}