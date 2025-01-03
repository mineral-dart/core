import 'package:mineral/api.dart';
import 'package:mineral/container.dart';
import 'package:mineral/contracts.dart';
import 'package:mineral/src/api/server/audit_log/actions/emoji.dart';
import 'package:mineral/src/api/server/audit_log/audit_log_action.dart';

abstract class AuditLogActionContract {
  DataStoreContract get _datastore => ioc.resolve<DataStoreContract>();

  AuditLogType type;
  Snowflake serverId;
  Snowflake? userId;

  AuditLogActionContract(this.type, this.serverId, this.userId);

  Future<Server> resolveServer() => _datastore.server.get(serverId.value, true);
}

abstract class AuditLog {
  DataStoreContract get _datastore => ioc.resolve<DataStoreContract>();

  AuditLogType type;
  Snowflake serverId;
  Snowflake? userId;

  AuditLog(this.type, this.serverId, this.userId);

  Future<Server> resolveServer() => _datastore.server.get(serverId.value, true);

  factory AuditLog.fromJson(Map<String, dynamic> json) {
    final logger = ioc.resolve<LoggerContract>();

    final auditLogType = AuditLogType.values.firstWhere(
        (element) => element.value == json['action_type'],
        orElse: () => AuditLogType.unknown);

    final auditLog = switch (auditLogType) {
      AuditLogType.emojiCreate => EmojiCreateAuditLog.fromJson(json),
      AuditLogType.emojiUpdate => EmojiUpdateAuditLog.fromJson(json),
      AuditLogType.emojiDelete => EmojiDeleteAuditLog.fromJson(json),
      _ => UnknownAuditLogAction.fromJson(json),
    };

    if (auditLog case UnknownAuditLogAction()) {
      logger.warn('Audit log action not found ${json['action_type']}');
    }

    return auditLog;
  }
}

enum AuditLogType implements EnhancedEnum<int> {
  unknown(0),
  guildUpdate(1),
  channelCreate(10),
  channelUpdate(11),
  channelDelete(12),
  channelOverwriteCreate(13),
  channelOverwriteUpdate(14),
  channelOverwriteDelete(15),
  memberKick(20),
  memberPrune(21),
  memberBanAdd(22),
  memberBanRemove(23),
  memberUpdate(24),
  memberRoleUpdate(25),
  memberMove(26),
  memberDisconnect(27),
  botAdd(28),
  roleCreate(30),
  roleUpdate(31),
  roleDelete(32),
  inviteCreate(40),
  inviteUpdate(41),
  inviteDelete(42),
  webhookCreate(50),
  webhookUpdate(51),
  webhookDelete(52),
  emojiCreate(60),
  emojiUpdate(61),
  emojiDelete(62),
  messageDelete(72),
  messageBulkDelete(73),
  messagePin(74),
  messageUnpin(75),
  integrationCreate(80),
  integrationUpdate(81),
  integrationDelete(82),
  stageInstanceCreate(83),
  stageInstanceUpdate(84),
  stageInstanceDelete(85),
  stickerCreate(90),
  stickerUpdate(91),
  stickerDelete(92),
  guildScheduledEventCreate(100),
  guildScheduledEventUpdate(101),
  guildScheduledEventDelete(102),
  threadCreate(110),
  threadUpdate(111),
  threadDelete(112),
  applicationCommandPermissionUpdate(121),
  autoModerationRuleCreate(140),
  autoModerationRuleUpdate(141),
  autoModerationRuleDelete(142),
  autoModerationBlockMessage(143),
  autoModerationFlagToChannel(144),
  autoModerationUserCommunicationDisabled(145),
  creatorMonetizationRequestCreated(150),
  creatorMonetizationTermsAccepted(151),
  onboardingPromptCreate(163),
  onboardingPromptUpdate(164),
  onboardingPromptDelete(165),
  onboardingCreate(166),
  onboardingUpdate(167),
  homeSettingsCreate(190),
  homeSettingsUpdate(191);

  @override
  final int value;

  const AuditLogType(this.value);
}
