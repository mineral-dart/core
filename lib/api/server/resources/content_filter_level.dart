final class ContentFilterLevel {
  static ContentFilterLevel disabled = ContentFilterLevel(0, "Don't scan any messages.");
  static ContentFilterLevel membersWithoutRoles = ContentFilterLevel(1, "Scan messages from members without a role.");
  static ContentFilterLevel allMembers = ContentFilterLevel(2, "Scan messages sent by all members.");

  final int value;
  final String description;

  const ContentFilterLevel(this.value, this.description);

  factory ContentFilterLevel.of(final int value) => switch (value) {
    0 => ContentFilterLevel.disabled,
    1 => ContentFilterLevel.membersWithoutRoles,
    2 => ContentFilterLevel.allMembers,
    _ => throw ArgumentError('Unknown content filter level: $value')
  };
}