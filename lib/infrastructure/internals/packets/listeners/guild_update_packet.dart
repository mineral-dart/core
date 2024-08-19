import 'package:mineral/domains/events/event.dart';
import 'package:mineral/infrastructure/internals/marshaller/marshaller.dart';
import 'package:mineral/infrastructure/internals/packets/listenable_packet.dart';
import 'package:mineral/infrastructure/internals/packets/packet_type.dart';
import 'package:mineral/infrastructure/internals/wss/shard_message.dart';
import 'package:mineral/infrastructure/services/logger/logger.dart';

final class GuildUpdatePacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.guildUpdate;

  final LoggerContract logger;
  final MarshallerContract marshaller;

  const GuildUpdatePacket(this.logger, this.marshaller);

  @override
  Future<void> listen(ShardMessage message, DispatchEvent dispatch) async {
    final before = await marshaller.dataStore.server.getServer(message.payload['id']);
    final after = await marshaller.serializers.server.serializeRemote(message.payload);

    final cacheKey = marshaller.cacheKey.server(after.id);
    final rawServer = await marshaller.serializers.server.deserialize(after);

    dispatch(event: Event.serverUpdate, params: [before, after]);

    marshaller.cache.put(cacheKey, rawServer);
  }
}
