import 'package:mineral/infrastructure/services/logger/logger.dart';
import 'package:mineral/domains/events/types/listenable_packet.dart';
import 'package:mineral/domains/events/types/packet_type.dart';
import 'package:mineral/infrastructure/internals/marshaller/marshaller.dart';
import 'package:mineral/infrastructure/internals/wss/shard_message.dart';

final class GuildAuditLogEntryCreatePacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.guildAuditLogEntryCreate;

  final LoggerContract logger;
  final MarshallerContract marshaller;

  const GuildAuditLogEntryCreatePacket(this.logger, this.marshaller);

  @override
  Future<void> listen(ShardMessage message, DispatchEvent dispatch) async {
    final server = await marshaller.dataStore.server.getServer(message.payload['guild_id']);


   // dispatch(event: MineralEvent.serverPresenceUpdate, params: [member, server, presence]);
  }
}
