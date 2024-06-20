import 'package:mineral/api/server/auto_mod/auto_moderation_trigger.dart';
import 'package:mineral/api/server/auto_mod/enums/trigger_type.dart';

final class MemberProfileTrigger implements AutoModerationTrigger {
  @override
  final TriggerType type = TriggerType.memberProfile;

  final List<String> keywordFilter;
  final List<String> regexPatterns;
  final List<String> allowList;

  MemberProfileTrigger({
    this.keywordFilter = const [],
    this.regexPatterns = const[],
    this.allowList = const [],
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'keyword_filter': keywordFilter,
      'regex_patterns': regexPatterns,
      'allow_list': allowList,
    };
  }
}
