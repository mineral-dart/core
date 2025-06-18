import 'package:mineral/api/common/snowflake.dart';

/// Represents the type of action to take when an auto moderation rule is triggered
enum AutoModActionType {
  /// Block the content of a message
  blockMessage(1),
  
  /// Send an alert to a specified channel
  sendAlertMessage(2),
  
  /// Timeout the user
  timeout(3);
  
  /// The numeric code for this action type
  final int code;
  
  const AutoModActionType(this.code);
  
  /// Get an [AutoModActionType] from its numeric code
  static AutoModActionType fromCode(int code) {
    return AutoModActionType.values.firstWhere(
      (type) => type.code == code,
      orElse: () => throw ArgumentError('Invalid AutoModActionType code: $code'),
    );
  }
}

/// Represents the action to take when an auto moderation rule is triggered
final class AutoModAction {
  /// The type of action
  final AutoModActionType type;
  
  /// Additional metadata needed depending on the action type
  final AutoModActionMetadata? metadata;
  
  const AutoModAction({
    required this.type,
    this.metadata,
  });
}

/// Additional metadata for an auto moderation action
final class AutoModActionMetadata {
  /// Channel ID to which user content should be logged
  final Snowflake? channelId;
  
  /// Timeout duration in seconds
  final int? durationSeconds;
  
  /// Custom message that is shown to the user when their message is blocked
  final String? customMessage;
  
  const AutoModActionMetadata({
    this.channelId,
    this.durationSeconds,
    this.customMessage,
  });
}