import 'package:mineral/api.dart';
import 'package:mineral/src/api/server/moderation/enums/auto_moderation_event_type.dart';
import 'package:mineral/src/api/server/moderation/enums/trigger_type.dart';
import 'package:mineral/src/api/server/moderation/trigger_metadata.dart';

final class AutoModerationRule {
  final Snowflake id;
  final Snowflake serverId;
  final String name;
  final Snowflake creatorId;
  final AutoModerationEventType eventTypes;
  final TriggerType triggerTypes;
  final TriggerMetadata triggerMetadata;
  final List<Action> action;
  final bool isEnabled;
  final List<Snowflake> exemptRoles;
  final List<Snowflake> exemptChannels;

  AutoModerationRule({
    required this.id,
    required this.serverId,
    required this.name,
    required this.creatorId,
    required this.eventTypes,
    required this.triggerTypes,
    required this.triggerMetadata,
    required this.action,
    required this.isEnabled,
    required this.exemptRoles,
    required this.exemptChannels,
  });
}
