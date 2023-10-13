final class NotificationLevel {
  static NotificationLevel allMessages = NotificationLevel._(0, "All messages");
  static NotificationLevel onlyMentions = NotificationLevel._(1, "Only @mentions");

  final int value;
  final String description;

  const NotificationLevel._(this.value, this.description);

  factory NotificationLevel.of(final int value) => switch (value) {
    0 => NotificationLevel.allMessages,
    1 => NotificationLevel.onlyMentions,
    _ => throw ArgumentError('Unknown notification level: $value')
  };
}