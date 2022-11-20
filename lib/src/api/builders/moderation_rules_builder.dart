import 'package:mineral/core/api.dart';
import 'package:mineral/src/exceptions/too_many.dart';

class ModerationRulesBuilder {
  final String label;
  final ModerationEventType moderationEventType;
  final ModerationTriggerType moderationTriggerType;
  final List<Snowflake> exemptRoles;
  final List<Snowflake> exemptChannels;
  final bool enabled;
  final List<ModerationAction> actions;
  final ModerationTriggerMetadata? triggerMetadata;

  ModerationRulesBuilder(
    this.label,
    this.moderationEventType,
    this.moderationTriggerType,
    this.exemptRoles,
    this.exemptChannels,
    this.enabled,
    this.actions,
    this.triggerMetadata
  );

  factory ModerationRulesBuilder.spam ({ required String label, required List<ModerationAction> actions, List<Snowflake>? exemptRoles, List<Snowflake>? exemptChannels, bool enabled = true }) {
    if (exemptRoles != null && exemptRoles.length > 50) {
      throw TooMany(cause: 'You cannot define more than 50 roles in the exclusion zone of the moderation rule.');
    }

    if (exemptChannels != null && exemptChannels.length > 20) {
      throw TooMany(cause: 'You cannot define more than 20 channels in the exclusion zone of the moderation rule.');
    }

    return ModerationRulesBuilder(
      label,
      ModerationEventType.messageSend,
      ModerationTriggerType.spam,
      exemptRoles ?? [],
      exemptChannels ?? [],
      enabled,
      actions,
      null
    );
  }

  factory ModerationRulesBuilder.banKeywords ({ required String label, required List<ModerationAction> actions, required ModerationTriggerMetadata? triggerMetadata, List<Snowflake>? exemptRoles, List<Snowflake>? exemptChannels, bool enabled = true }) {
    if (exemptRoles != null && exemptRoles.length > 50) {
      throw TooMany(cause: 'You cannot define more than 50 roles in the exclusion zone of the moderation rule.');
    }

    if (exemptChannels != null && exemptChannels.length > 20) {
      throw TooMany(cause: 'You cannot define more than 20 channels in the exclusion zone of the moderation rule.');
    }

    return ModerationRulesBuilder(
      label,
      ModerationEventType.messageSend,
      ModerationTriggerType.keywords,
      exemptRoles ?? [],
      exemptChannels ?? [],
      enabled,
      actions,
      triggerMetadata,
    );
  }

  factory ModerationRulesBuilder.mentionSpam ({ required String label, required List<ModerationAction> actions, required ModerationTriggerMetadata? triggerMetadata, List<Snowflake>? exemptRoles, List<Snowflake>? exemptChannels, bool enabled = true }) {
    if (exemptRoles != null && exemptRoles.length > 50) {
      throw TooMany(cause: 'You cannot define more than 50 roles in the exclusion zone of the moderation rule.');
    }

    if (exemptChannels != null && exemptChannels.length > 20) {
      throw TooMany(cause: 'You cannot define more than 20 channels in the exclusion zone of the moderation rule.');
    }

    return ModerationRulesBuilder(
      label,
      ModerationEventType.messageSend,
      ModerationTriggerType.mentionSpam,
      exemptRoles ?? [],
      exemptChannels ?? [],
      enabled,
      actions,
      triggerMetadata,
    );
  }
}