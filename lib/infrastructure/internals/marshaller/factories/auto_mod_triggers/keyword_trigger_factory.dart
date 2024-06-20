import 'dart:async';

import 'package:mineral/api/server/auto_mod/enums/trigger_type.dart';
import 'package:mineral/api/server/auto_mod/triggers/keyword_trigger.dart';
import 'package:mineral/infrastructure/internals/marshaller/types/trigger_factory.dart';

final class KeywordTriggerFactory implements TriggerFactory<KeywordTrigger> {
  @override
  TriggerType get type => TriggerType.keyword;

  @override
  FutureOr<KeywordTrigger> serialize(Map<String, dynamic> payload) {
    return KeywordTrigger(
      allowList: List<String>.from(payload['allow_list']),
      regexPatterns: List<String>.from(['regex_patterns']),
      keywordFilter: List<String>.from(payload['keyword_filter']),
    );
  }

  @override
  FutureOr<Map<String, dynamic>> deserialize(KeywordTrigger trigger) {
    return {
      'type': trigger.type,
      'regex_patterns': trigger.regexPatterns,
      'allowList': trigger.allowList,
    };
  }
}
