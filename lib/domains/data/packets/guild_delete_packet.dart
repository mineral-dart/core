import 'package:mineral/application/logger/logger.dart';
import 'package:mineral/domains/data/types/listenable_packet.dart';
import 'package:mineral/domains/data/types/packet_type.dart';
import 'package:mineral/domains/marshaller/marshaller.dart';
import 'package:mineral/domains/shared/mineral_event.dart';
import 'package:mineral/domains/wss/shard_message.dart';

final class GuildDeletePacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.guildDelete;

  final LoggerContract logger;
  final MarshallerContract marshaller;

  const GuildDeletePacket(this.logger, this.marshaller);

  @override
  void listen(ShardMessage message, DispatchEvent dispatch) {
    final String serverId = message.payload['id'];
    final server = marshaller.storage.servers[serverId];

    dispatch(event: MineralEvent.serverDelete, params: [server]);

    marshaller.storage.servers.remove(serverId);
  }
}
