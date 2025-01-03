import 'package:mineral/container.dart';
import 'package:mineral/contracts.dart';
import 'package:mineral/src/api/server/audit_log/audit_log.dart';
import 'package:mineral/src/domains/contracts/logger/logger_contract.dart';
import 'package:mineral/src/domains/contracts/marshaller/marshaller.dart';
import 'package:mineral/src/infrastructure/internals/packets/listenable_packet.dart';
import 'package:mineral/src/infrastructure/internals/packets/packet_type.dart';
import 'package:mineral/src/infrastructure/internals/wss/shard_message.dart';

final class GuildAuditLogEntryCreatePacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.guildAuditLogEntryCreate;

  DataStoreContract get _datastore => ioc.resolve<DataStoreContract>();

  @override
  Future<void> listen(ShardMessage message, DispatchEvent dispatch) async {
    final server = await _datastore.server.get(message.payload['guild_id'], false);

    final auditLog = AuditLog.fromJson(message.payload);
    print('GuildAuditLogEntryCreatePacket ${message.payload} ${auditLog}');
    // TODO: Implement this packet
  }
}
