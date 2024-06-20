import 'dart:async';

import 'package:mineral/api/server/auto_mod/enums/trigger_type.dart';
import 'package:mineral/api/server/auto_mod/triggers/member_profile_trigger.dart';
import 'package:mineral/infrastructure/internals/marshaller/types/trigger_factory.dart';

final class MemberProfileTriggerFactory implements TriggerFactory<MemberProfileTrigger> {
  @override
  TriggerType get type => TriggerType.memberProfile;

  @override
  FutureOr<MemberProfileTrigger> serialize(Map<String, dynamic> payload) {
    return MemberProfileTrigger(
      allowList: List<String>.from(payload['allow_list']),
      keywordFilter: payload['keyword_filter'],
      regexPatterns: payload['regex_patterns'],
    );
  }

  @override
  FutureOr<Map<String, dynamic>> deserialize(MemberProfileTrigger trigger) {
    return {
      'type': trigger.type,
      'regex_patterns': trigger.regexPatterns,
      'allowList': trigger.allowList,
    };
  }
}
