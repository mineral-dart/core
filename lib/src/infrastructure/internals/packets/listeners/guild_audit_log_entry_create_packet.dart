import 'package:mineral/src/api/server/audit_log/actions/role.dart';
import 'package:mineral/src/api/server/audit_log/audit_log.dart';
import 'package:mineral/src/infrastructure/internals/packets/listenable_packet.dart';
import 'package:mineral/src/infrastructure/internals/packets/packet_type.dart';
import 'package:mineral/src/infrastructure/internals/wss/shard_message.dart';

final class GuildAuditLogEntryCreatePacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.guildAuditLogEntryCreate;

  @override
  Future<void> listen(ShardMessage message, DispatchEvent dispatch) async {
    final auditLog = AuditLog.fromJson(message.payload);
    // TODO: Implement this packet
  }
}
