import 'dart:async';

import 'package:mineral/api/server/auto_mod/enums/trigger_type.dart';
import 'package:mineral/api/server/auto_mod/triggers/message_spam_trigger.dart';
import 'package:mineral/infrastructure/internals/marshaller/types/trigger_factory.dart';

final class MessageSpamTriggerFactory implements TriggerFactory<MessageSpamTrigger> {
  @override
  TriggerType get type => TriggerType.mentionSpam;

  @override
  FutureOr<MessageSpamTrigger> serialize(Map<String, dynamic> payload) {
    return MessageSpamTrigger();
  }

  @override
  FutureOr<Map<String, dynamic>> deserialize(MessageSpamTrigger trigger) {
    return {};
  }
}
