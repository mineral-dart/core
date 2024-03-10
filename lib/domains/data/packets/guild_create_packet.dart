import 'package:mineral/application/logger/logger.dart';
import 'package:mineral/domains/data/types/listenable_packet.dart';
import 'package:mineral/domains/data/types/packet_type.dart';
import 'package:mineral/domains/marshaller/marshaller.dart';
import 'package:mineral/domains/shared/mineral_event.dart';
import 'package:mineral/domains/wss/shard_message.dart';

final class GuildCreatePacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.guildCreate;

  final LoggerContract logger;
  final MarshallerContract marshaller;

  const GuildCreatePacket(this.logger, this.marshaller);

  @override
  Future<void> listen(ShardMessage message, DispatchEvent dispatch) async {
    final server = await marshaller.serializers.server.serialize(message.payload);

    marshaller.cache.put(server.id, message.payload);
    for (final channel in List<Map<String, dynamic>>.from(message.payload['channels'])) {
      marshaller.cache.put(channel['id'], channel);
    }

    dispatch(event: MineralEvent.serverCreate, params: [server]);
  }
}
