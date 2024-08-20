import 'package:mineral/domains/events/event.dart';
import 'package:mineral/infrastructure/internals/marshaller/marshaller.dart';
import 'package:mineral/infrastructure/internals/packets/listenable_packet.dart';
import 'package:mineral/infrastructure/internals/packets/packet_type.dart';
import 'package:mineral/infrastructure/internals/wss/shard_message.dart';
import 'package:mineral/infrastructure/services/logger/logger.dart';

final class GuildDeletePacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.guildDelete;

  final LoggerContract logger;
  final MarshallerContract marshaller;

  const GuildDeletePacket(this.logger, this.marshaller);

  @override
  Future<void> listen(ShardMessage message, DispatchEvent dispatch) async {
    final cacheKey = marshaller.cacheKey.server(message.payload['id']);
    final rawServer = await marshaller.cache.get(cacheKey);
    final server = rawServer != null
        ? await marshaller.serializers.server.serialize(rawServer)
        : null;

    dispatch(event: Event.serverDelete, params: [server]);

    marshaller.cache.remove(cacheKey);
  }
}
