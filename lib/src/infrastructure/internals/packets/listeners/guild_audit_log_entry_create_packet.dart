import 'package:mineral/src/infrastructure/internals/marshaller/marshaller.dart';
import 'package:mineral/src/infrastructure/internals/packets/listenable_packet.dart';
import 'package:mineral/src/infrastructure/internals/packets/packet_type.dart';
import 'package:mineral/src/infrastructure/internals/wss/shard_message.dart';
import 'package:mineral/src/domains/services/logger/logger_contract.dart';

final class GuildAuditLogEntryCreatePacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.guildAuditLogEntryCreate;

  final LoggerContract logger;
  final MarshallerContract marshaller;

  const GuildAuditLogEntryCreatePacket(this.logger, this.marshaller);

  @override
  Future<void> listen(ShardMessage message, DispatchEvent dispatch) async {
    // TODO: Implement this packet
  }
}
