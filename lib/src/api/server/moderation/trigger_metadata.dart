import 'package:mineral/src/api/server/moderation/enums/keyword_preset_type.dart';
import 'package:mineral/src/domains/common/utils/utils.dart';

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

  static fromJson(Map<String, dynamic> json) {
    return TriggerMetadata(
      keywordFilter: List<String>.from(json['keyword_filter'] ?? []),
      regexPatterns: List<String>.from(json['regex_patterns'] ?? []),
      presets: (json['presets'] as List<dynamic>?)
              ?.map((e) => findInEnum(KeywordPresetType.values, e))
              .whereType<KeywordPresetType>()
              .toList() ??
          [],
      allowList: List<String>.from(json['allow_list'] ?? []),
      mentionTotalLimit: json['mention_total_limit'],
      mentionRaidProtectionEnabled: json['mention_raid_protection_enabled'],
    );
  }
}