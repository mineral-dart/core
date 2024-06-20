import 'package:mineral/api/server/auto_mod/auto_moderation_trigger.dart';
import 'package:mineral/api/server/auto_mod/enums/trigger_type.dart';

final class MessageSpamTrigger implements AutoModerationTrigger {
  @override
  final TriggerType type = TriggerType.spam;

  MessageSpamTrigger();

  @override
  Map<String, dynamic> toJson() {
    return {};
  }
}
