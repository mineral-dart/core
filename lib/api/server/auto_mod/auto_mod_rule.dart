import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/server/auto_mod/auto_mod_action.dart';
import 'package:mineral/api/server/auto_mod/auto_mod_trigger_metadata.dart';
import 'package:mineral/api/server/auto_mod/auto_mod_trigger_type.dart';
import 'package:mineral/api/server/auto_mod/auto_mod_event_type.dart';
import 'package:mineral/api/server/server.dart';

/// Represents an auto moderation rule in a server.
final class AutoModRule {
  /// The unique ID of this auto moderation rule
  final Snowflake id;
  
  /// The ID of the guild this rule belongs to
  final Snowflake guildId;
  
  /// Reference to the server this rule belongs to
  Server? server;
  
  /// The name of this rule
  final String name;
  
  /// The user ID that created this rule
  final Snowflake creatorId;
  
  /// The rule trigger type
  final AutoModTriggerType triggerType;
  
  /// The trigger metadata for this rule
  final AutoModTriggerMetadata triggerMetadata;
  
  /// The actions which will execute when the rule is triggered
  final List<AutoModAction> actions;
  
  /// Whether the rule is enabled
  final bool enabled;
  
  /// The role IDs that are exempt from this rule
  final List<Snowflake> exemptRoles;
  
  /// The channel IDs that are exempt from this rule
  final List<Snowflake> exemptChannels;
  
  /// The event types this rule applies to
  final List<AutoModEventType> eventTypes;
  
  AutoModRule({
    required this.id,
    required this.guildId,
    this.server,
    required this.name,
    required this.creatorId,
    required this.triggerType,
    required this.triggerMetadata,
    required this.actions,
    required this.enabled,
    required this.exemptRoles,
    required this.exemptChannels,
    required this.eventTypes,
  });
}