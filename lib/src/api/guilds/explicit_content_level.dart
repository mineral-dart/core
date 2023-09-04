/// Explicit content filter level.
enum ExplicitContentLevel {
  /// Don't scan any messages.
  disabled(0),

  /// Scan messages from members without a role.
  membersWithoutRoles(1),

  /// Scan messages sent by all members.
  allMembers(2);

  final int value;
  const ExplicitContentLevel(this.value);
}