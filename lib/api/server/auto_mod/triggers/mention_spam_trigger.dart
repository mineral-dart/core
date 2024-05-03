import 'package:mineral/api/server/auto_mod/auto_moderation_trigger.dart';
import 'package:mineral/api/server/auto_mod/enums/preset_type.dart';
import 'package:mineral/api/server/auto_mod/enums/trigger_type.dart';

final class MentionSpamTrigger implements AutoModerationTrigger {
  @override
  final TriggerType type = TriggerType.mentionSpam;

  final int mentionTotalLimit;
  final bool hasMentionRaidProtectionEnabled;

  MentionSpamTrigger({
    required this.mentionTotalLimit,
    required this.hasMentionRaidProtectionEnabled,
  });
}
