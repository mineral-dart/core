import 'package:mineral/infrastructure/services/logger/logger.dart';
import 'package:mineral/domains/data/types/listenable_packet.dart';
import 'package:mineral/domains/data/types/packet_type.dart';
import 'package:mineral/infrastructure/internals/marshaller/marshaller.dart';
import 'package:mineral/infrastructure/commons/mineral_event.dart';
import 'package:mineral/infrastructure/internals/wss/shard_message.dart';

final class GuildUpdatePacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.guildUpdate;

  final LoggerContract logger;
  final MarshallerContract marshaller;

  const GuildUpdatePacket(this.logger, this.marshaller);

  @override
  Future<void> listen(ShardMessage message, DispatchEvent dispatch) async {
    final before = await marshaller.dataStore.server.getServer(message.payload['id']);
    final after = await marshaller.serializers.server.serialize(message.payload);

    final rawServer = await marshaller.serializers.server.deserialize(after);
    marshaller.cache.put(after.id, rawServer);

    dispatch(event: MineralEvent.serverUpdate, params: [before, after]);
  }
}
