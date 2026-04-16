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

  factory TriggerMetadata.fromJson(Map<String, dynamic> json) {
    return TriggerMetadata(
      keywordFilter: List<String>.from(json['keyword_filter'] as Iterable<dynamic>? ?? []),
      regexPatterns: List<String>.from(json['regex_patterns'] as Iterable<dynamic>? ?? []),
      presets: (json['presets'] as List<dynamic>?)
              ?.map((e) => findInEnum(KeywordPresetType.values, e,
                  orElse: KeywordPresetType.unknown))
              .whereType<KeywordPresetType>()
              .toList() ??
          [],
      allowList: List<String>.from(json['allow_list'] as Iterable<dynamic>? ?? []),
      mentionTotalLimit: json['mention_total_limit'] as int?,
      mentionRaidProtectionEnabled: json['mention_raid_protection_enabled'] as bool?,
    );
  }
}
