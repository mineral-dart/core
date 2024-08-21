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
    final serverCacheKey = marshaller.cacheKey.server(message.payload['id']);
    final rawServer = await marshaller.cache.get(serverCacheKey);
    final before =
        rawServer != null ? await marshaller.serializers.server.serialize(rawServer) : null;

    final rawAfter = await marshaller.serializers.server.normalize(message.payload);
    final after = await marshaller.serializers.server.serialize(rawAfter);

    dispatch(event: Event.serverUpdate, params: [before, after]);
  }
}
