/// The notification level of a [Guild].
enum NotificationLevel {
  /// All messages will trigger notifications.
  allMessages(0),

  /// Only messages that mention the user will trigger notifications.
  onlyMentions(1);

  final int value;
  const NotificationLevel(this.value);
}