/// Represents additional metadata for an auto moderation rule trigger
final class AutoModTriggerMetadata {
  /// Substrings that will be searched for in content
  final List<String>? keywordFilter;
  
  /// Regular expression patterns that will be matched against content
  final List<String>? regexPatterns;
  
  /// Presets of words to match against
  final List<String>? presets;
  
  /// Substrings that should not trigger the rule
  final List<String>? allowList;
  
  /// Number of mentions that trigger the mention spam rule
  final int? mentionTotalLimit;
  
  /// Whether to automatically detect mention raids
  final bool? mentionRaidProtectionEnabled;
  
  const AutoModTriggerMetadata({
    this.keywordFilter,
    this.regexPatterns,
    this.presets,
    this.allowList,
    this.mentionTotalLimit,
    this.mentionRaidProtectionEnabled,
  });
}