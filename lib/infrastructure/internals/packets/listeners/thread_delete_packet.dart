import 'package:mineral/domains/events/event.dart';
import 'package:mineral/infrastructure/internals/marshaller/marshaller.dart';
import 'package:mineral/infrastructure/internals/packets/listenable_packet.dart';
import 'package:mineral/infrastructure/internals/packets/packet_type.dart';
import 'package:mineral/infrastructure/internals/wss/shard_message.dart';
import 'package:mineral/infrastructure/services/logger/logger.dart';

final class ThreadDeletePacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.threadDelete;

  final LoggerContract logger;
  final MarshallerContract marshaller;

  ThreadDeletePacket(this.logger, this.marshaller);

  @override
  Future<void> listen(ShardMessage message, DispatchEvent dispatch) async {
    final payload = message.payload;

    final server = await marshaller.dataStore.server.getServer(payload['guild_id']);

    final threadCacheKey = marshaller.cacheKey.thread(payload['id']);
    final threadRaw = await marshaller.cache.getOrFail(threadCacheKey);
    final thread = await marshaller.serializers.thread.serialize(threadRaw);

    await marshaller.cache.remove(threadCacheKey);

    dispatch(event: Event.serverThreadDelete, params: [thread, server]);
  }
}
