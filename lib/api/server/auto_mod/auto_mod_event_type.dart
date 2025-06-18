/// Represents the event types that can trigger an auto moderation rule
enum AutoModEventType {
  /// Rule is triggered when a member sends a message
  messageSend(1);

  /// The numeric code for this event type
  final int code;

  const AutoModEventType(this.code);

  /// Get an [AutoModEventType] from its numeric code
  static AutoModEventType fromCode(int code) {
    return AutoModEventType.values.firstWhere(
      (type) => type.code == code,
      orElse: () => throw ArgumentError('Invalid AutoModEventType code: $code'),
    );
  }
}
