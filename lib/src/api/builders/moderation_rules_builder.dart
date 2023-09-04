import 'package:mineral/core/api.dart';
import 'package:mineral/src/api/messages/message_mention.dart';
import 'package:mineral/src/exceptions/too_many_exception.dart';

/// Moderation rules of [Guild]
class ModerationRulesBuilder {
  /// Label of this.
  final String label;

  /// The [ModerationEventType] of event that triggers this.
  final ModerationEventType moderationEventType;

  /// The [ModerationTriggerType] of event that triggers this.
  final ModerationTriggerType moderationTriggerType;

  /// The roles that are exempt from this as [Snowflake].
  final List<Snowflake> exemptRoles;

  /// The channels that are exempt from this as [Snowflake].
  final List<Snowflake> exemptChannels;

  /// Whether this is enabled.
  final bool enabled;

  /// The actions of this.
  final List<ModerationAction> actions;

  /// The metadata of this.
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

  /// Create a new moderation rule for [Guild] that triggers when a user spam many messages.
  factory ModerationRulesBuilder.spam ({ required String label, required List<ModerationAction> actions, List<Snowflake>? exemptRoles, List<Snowflake>? exemptChannels, bool enabled = true }) {
    if (exemptRoles != null && exemptRoles.length > 50) {
      throw TooManyException('You cannot define more than 50 roles in the exclusion zone of the moderation rule.');
    }

    if (exemptChannels != null && exemptChannels.length > 20) {
      throw TooManyException('You cannot define more than 20 channels in the exclusion zone of the moderation rule.');
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

  /// Create a new moderation rule for [Guild] that triggers when a user send a message with a blacklisted word.
  factory ModerationRulesBuilder.banKeywords ({ required String label, required List<ModerationAction> actions, required ModerationTriggerMetadata? triggerMetadata, List<Snowflake>? exemptRoles, List<Snowflake>? exemptChannels, bool enabled = true }) {
    if (exemptRoles != null && exemptRoles.length > 50) {
      throw TooManyException('You cannot define more than 50 roles in the exclusion zone of the moderation rule.');
    }

    if (exemptChannels != null && exemptChannels.length > 20) {
      throw TooManyException('You cannot define more than 20 channels in the exclusion zone of the moderation rule.');
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

  /// Create a new moderation rule for [Guild] that triggers when a user [MessageMention] many users.
  factory ModerationRulesBuilder.mentionSpam ({ required String label, required List<ModerationAction> actions, required ModerationTriggerMetadata? triggerMetadata, List<Snowflake>? exemptRoles, List<Snowflake>? exemptChannels, bool enabled = true }) {
    if (exemptRoles != null && exemptRoles.length > 50) {
      throw TooManyException('You cannot define more than 50 roles in the exclusion zone of the moderation rule.');
    }

    if (exemptChannels != null && exemptChannels.length > 20) {
      throw TooManyException('You cannot define more than 20 channels in the exclusion zone of the moderation rule.');
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