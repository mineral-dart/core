import 'package:mineral/container.dart';
import 'package:mineral/contracts.dart';
import 'package:mineral/events.dart';
import 'package:mineral/src/api/server/audit_log/audit_log.dart';
import 'package:mineral/src/api/server/audit_log/audit_log_action.dart';
import 'package:mineral/src/infrastructure/internals/packets/listenable_packet.dart';
import 'package:mineral/src/infrastructure/internals/packets/listeners/audit_logs/_default.dart';
import 'package:mineral/src/infrastructure/internals/packets/listeners/audit_logs/application_command_permission.dart';
import 'package:mineral/src/infrastructure/internals/packets/listeners/audit_logs/auto_moderation.dart';
import 'package:mineral/src/infrastructure/internals/packets/listeners/audit_logs/channel.dart';
import 'package:mineral/src/infrastructure/internals/packets/listeners/audit_logs/channel_overwrite.dart';
import 'package:mineral/src/infrastructure/internals/packets/listeners/audit_logs/emoji.dart';
import 'package:mineral/src/infrastructure/internals/packets/listeners/audit_logs/guild_scheduled_event.dart';
import 'package:mineral/src/infrastructure/internals/packets/listeners/audit_logs/integration.dart';
import 'package:mineral/src/infrastructure/internals/packets/listeners/audit_logs/invite.dart';
import 'package:mineral/src/infrastructure/internals/packets/listeners/audit_logs/member.dart';
import 'package:mineral/src/infrastructure/internals/packets/listeners/audit_logs/message.dart';
import 'package:mineral/src/infrastructure/internals/packets/listeners/audit_logs/other.dart';
import 'package:mineral/src/infrastructure/internals/packets/listeners/audit_logs/role.dart';
import 'package:mineral/src/infrastructure/internals/packets/listeners/audit_logs/server.dart';
import 'package:mineral/src/infrastructure/internals/packets/listeners/audit_logs/stage_instance.dart';
import 'package:mineral/src/infrastructure/internals/packets/listeners/audit_logs/sticker.dart';
import 'package:mineral/src/infrastructure/internals/packets/listeners/audit_logs/thread.dart';
import 'package:mineral/src/infrastructure/internals/packets/listeners/audit_logs/webhook.dart';
import 'package:mineral/src/infrastructure/internals/packets/packet_type.dart';
import 'package:mineral/src/infrastructure/internals/wss/shard_message.dart';

final class GuildAuditLogEntryCreatePacket implements ListenablePacket {
  LoggerContract get logger => ioc.resolve<LoggerContract>();

  @override
  PacketType get packetType => PacketType.guildAuditLogEntryCreate;

  @override
  Future<void> listen(ShardMessage message, DispatchEvent dispatch) async {
    final auditLogType = AuditLogType.values.firstWhere(
        (element) => element.value == message.payload['action_type'],
        orElse: () => AuditLogType.unknown);

    final auditLog = await switch (auditLogType) {
      // Emoji
      AuditLogType.emojiCreate => emojiCreateAuditLogHandler(message.payload),
      AuditLogType.emojiUpdate => emojiUpdateAuditLogHandler(message.payload),
      AuditLogType.emojiDelete => emojiDeleteAuditLogHandler(message.payload),

      // Role
      AuditLogType.roleCreate => roleCreateAuditLogHandler(message.payload),
      AuditLogType.roleUpdate => roleUpdateAuditLogHandler(message.payload),
      AuditLogType.roleDelete => roleDeleteAuditLogHandler(message.payload),

      // Server
      AuditLogType.guildUpdate => serverUpdateAuditLogHandler(message.payload),

      // Channel
      AuditLogType.channelCreate =>
        channelCreateAuditLogHandler(message.payload),
      AuditLogType.channelUpdate =>
        channelUpdateAuditLogHandler(message.payload),
      AuditLogType.channelDelete =>
        channelDeleteAuditLogHandler(message.payload),

      // Channel Overwrite
      AuditLogType.channelOverwriteCreate =>
        channelOverwriteCreateAuditLogHandler(message.payload),
      AuditLogType.channelOverwriteUpdate =>
        channelOverwriteUpdateAuditLogHandler(message.payload),
      AuditLogType.channelOverwriteDelete =>
        channelOverwriteDeleteAuditLogHandler(message.payload),

      // Member
      AuditLogType.memberKick => memberKickAuditLogHandler(message.payload),
      AuditLogType.memberPrune => memberPruneAuditLogHandler(message.payload),
      AuditLogType.memberBanAdd => memberBanAddAuditLogHandler(message.payload),
      AuditLogType.memberBanRemove =>
        memberBanRemoveAuditLogHandler(message.payload),
      AuditLogType.memberUpdate => memberUpdateAuditLogHandler(message.payload),
      AuditLogType.memberRoleUpdate =>
        memberRoleUpdateAuditLogHandler(message.payload),
      AuditLogType.memberMove => memberMoveAuditLogHandler(message.payload),
      AuditLogType.memberDisconnect =>
        memberDisconnectAuditLogHandler(message.payload),
      AuditLogType.botAdd => botAddAuditLogHandler(message.payload),

      // Invite
      AuditLogType.inviteCreate => inviteCreateAuditLogHandler(message.payload),
      AuditLogType.inviteUpdate => inviteUpdateAuditLogHandler(message.payload),
      AuditLogType.inviteDelete => inviteDeleteAuditLogHandler(message.payload),

      // Webhook
      AuditLogType.webhookCreate =>
        webhookCreateAuditLogHandler(message.payload),
      AuditLogType.webhookUpdate =>
        webhookUpdateAuditLogHandler(message.payload),
      AuditLogType.webhookDelete =>
        webhookDeleteAuditLogHandler(message.payload),

      // Message
      AuditLogType.messageDelete =>
        messageDeleteAuditLogHandler(message.payload),
      AuditLogType.messageBulkDelete =>
        messageBulkDeleteAuditLogHandler(message.payload),
      AuditLogType.messagePin => messagePinAuditLogHandler(message.payload),
      AuditLogType.messageUnpin => messageUnpinAuditLogHandler(message.payload),

      // Integration
      AuditLogType.integrationCreate =>
        integrationCreateAuditLogHandler(message.payload),
      AuditLogType.integrationUpdate =>
        integrationUpdateAuditLogHandler(message.payload),
      AuditLogType.integrationDelete =>
        integrationDeleteAuditLogHandler(message.payload),

      // Stage Instance
      AuditLogType.stageInstanceCreate =>
        stageInstanceCreateAuditLogHandler(message.payload),
      AuditLogType.stageInstanceUpdate =>
        stageInstanceUpdateAuditLogHandler(message.payload),
      AuditLogType.stageInstanceDelete =>
        stageInstanceDeleteAuditLogHandler(message.payload),

      // Sticker
      AuditLogType.stickerCreate =>
        stickerCreateAuditLogHandler(message.payload),
      AuditLogType.stickerUpdate =>
        stickerUpdateAuditLogHandler(message.payload),
      AuditLogType.stickerDelete =>
        stickerDeleteAuditLogHandler(message.payload),

      // Guild Scheduled Event
      AuditLogType.guildScheduledEventCreate =>
        guildScheduledEventCreateAuditLogHandler(message.payload),
      AuditLogType.guildScheduledEventUpdate =>
        guildScheduledEventUpdateAuditLogHandler(message.payload),
      AuditLogType.guildScheduledEventDelete =>
        guildScheduledEventDeleteAuditLogHandler(message.payload),

      // Thread
      AuditLogType.threadCreate => threadCreateAuditLogHandler(message.payload),
      AuditLogType.threadUpdate => threadUpdateAuditLogHandler(message.payload),
      AuditLogType.threadDelete => threadDeleteAuditLogHandler(message.payload),

      // Application Command Permission
      AuditLogType.applicationCommandPermissionUpdate =>
        applicationCommandPermissionUpdateAuditLogHandler(message.payload),

      // Auto Moderation
      AuditLogType.autoModerationRuleCreate =>
        autoModerationRuleCreateAuditLogHandler(message.payload),
      AuditLogType.autoModerationRuleUpdate =>
        autoModerationRuleUpdateAuditLogHandler(message.payload),
      AuditLogType.autoModerationRuleDelete =>
        autoModerationRuleDeleteAuditLogHandler(message.payload),
      AuditLogType.autoModerationBlockMessage =>
        autoModerationBlockMessageAuditLogHandler(message.payload),
      AuditLogType.autoModerationFlagToChannel =>
        autoModerationFlagToChannelAuditLogHandler(message.payload),
      AuditLogType.autoModerationUserCommunicationDisabled =>
        autoModerationUserCommunicationDisabledAuditLogHandler(message.payload),

      // Creator Monetization
      AuditLogType.creatorMonetizationRequestCreated =>
        creatorMonetizationRequestCreatedAuditLogHandler(message.payload),
      AuditLogType.creatorMonetizationTermsAccepted =>
        creatorMonetizationTermsAcceptedAuditLogHandler(message.payload),

      // Onboarding
      AuditLogType.onboardingPromptCreate =>
        onboardingPromptCreateAuditLogHandler(message.payload),
      AuditLogType.onboardingPromptUpdate =>
        onboardingPromptUpdateAuditLogHandler(message.payload),
      AuditLogType.onboardingPromptDelete =>
        onboardingPromptDeleteAuditLogHandler(message.payload),
      AuditLogType.onboardingCreate =>
        onboardingCreateAuditLogHandler(message.payload),
      AuditLogType.onboardingUpdate =>
        onboardingUpdateAuditLogHandler(message.payload),

      // Home Settings
      AuditLogType.homeSettingsCreate =>
        homeSettingsCreateAuditLogHandler(message.payload),
      AuditLogType.homeSettingsUpdate =>
        homeSettingsUpdateAuditLogHandler(message.payload),
      _ => unknownAuditLogHandler(message.payload),
    };

    if (auditLog case final UnknownAuditLogAction action) {
      logger.warn('Audit log action not found ${action.type}');
    }

    dispatch(
      event: Event.serverAuditLog,
      params: [auditLog],
    );
  }
}
