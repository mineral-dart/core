import 'dart:async';

import 'package:mineral/api/server/auto_mod/enums/trigger_type.dart';
import 'package:mineral/api/server/auto_mod/triggers/mention_spam_trigger.dart';
import 'package:mineral/infrastructure/internals/marshaller/types/trigger_factory.dart';

final class MemberSpamTriggerFactory implements TriggerFactory<MentionSpamTrigger> {
  @override
  TriggerType get type => TriggerType.mentionSpam;

  @override
  FutureOr<MentionSpamTrigger> serialize(Map<String, dynamic> payload) {
    return MentionSpamTrigger(
      hasMentionRaidProtectionEnabled: payload['mention_raid_protection_enabled'],
      mentionTotalLimit: payload['mention_total_limit'],
    );
  }

  @override
  FutureOr<Map<String, dynamic>> deserialize(MentionSpamTrigger trigger) {
    return {
      'mention_raid_protection_enabled': trigger.hasMentionRaidProtectionEnabled,
      'mention_total_limit': trigger.mentionTotalLimit,
    };
  }
}
