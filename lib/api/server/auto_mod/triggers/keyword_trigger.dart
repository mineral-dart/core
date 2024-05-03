import 'package:mineral/api/server/auto_mod/auto_moderation_trigger.dart';
import 'package:mineral/api/server/auto_mod/enums/trigger_type.dart';

final class KeywordTrigger implements AutoModerationTrigger {
  @override
  final TriggerType type = TriggerType.keyword;

  final List<String> keywordFilter;
  final List<String> regexPatterns;
  final List<String> allowList;

  KeywordTrigger({
    this.keywordFilter = const [],
    this.regexPatterns = const[],
    this.allowList = const [],
  });
}
