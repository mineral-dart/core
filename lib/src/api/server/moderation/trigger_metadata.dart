import 'package:mineral/src/api/server/moderation/enums/keyword_preset_type.dart';

final class TriggerMetadata {
  final List<String> keywordFilter;
  final List<String> regexPatterns;
  final List<KeywordPresetType> presets;
  final List<String> allowList;
  final int? mentionTotalLimit;
  final bool? mentionRaidProtectionEnabled;

  TriggerMetadata({
    required this.keywordFilter,
    required this.regexPatterns,
    required this.presets,
    required this.allowList,
    this.mentionTotalLimit,
    this.mentionRaidProtectionEnabled,
  });
}