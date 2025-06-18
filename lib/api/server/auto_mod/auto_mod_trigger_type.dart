/// Represents the trigger types for auto moderation rules
enum AutoModTriggerType {
  /// Rule is triggered based on a keyword filter
  keyword(1),
  
  /// Rule is triggered based on regex patterns
  harmful_link(2),
  
  /// Rule is triggered based on specific words in a server's custom list
  spam(3),
  
  /// Rule is triggered based on detection of promotion of other servers
  keyword_preset(4),
  
  /// Rule is triggered based on detection of mentions that exceed a specified threshold  
  mention_spam(5);
  
  /// The numeric code for this trigger type
  final int code;
  
  const AutoModTriggerType(this.code);
  
  /// Get an [AutoModTriggerType] from its numeric code
  static AutoModTriggerType fromCode(int code) {
    return AutoModTriggerType.values.firstWhere(
      (type) => type.code == code,
      orElse: () => throw ArgumentError('Invalid AutoModTriggerType code: $code'),
    );
  }
}