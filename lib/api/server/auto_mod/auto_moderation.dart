import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/server/auto_mod/auto_moderation_action.dart';
import 'package:mineral/api/server/auto_mod/auto_moderation_trigger.dart';
import 'package:mineral/api/server/auto_mod/enums/event_type.dart';

final class AutoModeration<T extends AutoModerationTrigger> {
  final Snowflake id;
  final String name;
  final Snowflake creatorId;
  final Snowflake serverId;
  final EventType eventType;
  final T trigger;
  final bool isEnabled;
  final List<Snowflake> exemptRoles;
  final List<Snowflake> exemptChannels;
  List<AutoModerationAction> actions = [];

  AutoModeration({
    required this.id,
    required this.name,
    required this.creatorId,
    required this.serverId,
    required this.eventType,
    required this.trigger,
    required this.isEnabled,
    required this.exemptRoles,
    required this.exemptChannels,
  });
}
