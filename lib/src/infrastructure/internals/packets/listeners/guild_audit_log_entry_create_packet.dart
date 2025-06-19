import 'package:mineral/container.dart';
import 'package:mineral/contracts.dart';
import 'package:mineral/events.dart';
import 'package:mineral/src/api/server/audit_log/audit_log.dart';
import 'package:mineral/src/api/server/audit_log/audit_log_action.dart';
import 'package:mineral/src/infrastructure/internals/packets/listenable_packet.dart';
import 'package:mineral/src/infrastructure/internals/packets/listeners/audit_logs/_default.dart';
import 'package:mineral/src/infrastructure/internals/packets/listeners/audit_logs/channel.dart';
import 'package:mineral/src/infrastructure/internals/packets/listeners/audit_logs/emoji.dart';
import 'package:mineral/src/infrastructure/internals/packets/listeners/audit_logs/role.dart';
import 'package:mineral/src/infrastructure/internals/packets/listeners/audit_logs/server.dart';
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
      AuditLogType.emojiCreate => emojiCreateAuditLogHandler(message.payload),
      AuditLogType.emojiUpdate => emojiUpdateAuditLogHandler(message.payload),
      AuditLogType.emojiDelete => emojiDeleteAuditLogHandler(message.payload),
      AuditLogType.roleCreate => roleCreateAuditLogHandler(message.payload),
      AuditLogType.roleUpdate => roleUpdateAuditLogHandler(message.payload),
      AuditLogType.roleDelete => roleDeleteAuditLogHandler(message.payload),
      AuditLogType.guildUpdate => serverUpdateAuditLogHandler(message.payload),
      AuditLogType.channelCreate =>
        channelCreateAuditLogHandler(message.payload),
      AuditLogType.channelUpdate =>
        channelUpdateAuditLogHandler(message.payload),
      AuditLogType.channelDelete =>
        channelDeleteAuditLogHandler(message.payload),
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
