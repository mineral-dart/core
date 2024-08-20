import 'package:mineral/domains/events/event.dart';
import 'package:mineral/infrastructure/internals/marshaller/marshaller.dart';
import 'package:mineral/infrastructure/internals/packets/listenable_packet.dart';
import 'package:mineral/infrastructure/internals/packets/packet_type.dart';
import 'package:mineral/infrastructure/internals/wss/shard_message.dart';
import 'package:mineral/infrastructure/services/logger/logger.dart';

final class ThreadUpdatePacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.threadUpdate;

  final LoggerContract logger;
  final MarshallerContract marshaller;

  ThreadUpdatePacket(this.logger, this.marshaller);

  @override
  Future<void> listen(ShardMessage message, DispatchEvent dispatch) async {
    final payload = message.payload;

    final server = await marshaller.dataStore.server.getServer(payload['guild_id']);
    final threadCacheKey = marshaller.cacheKey.threadChannel(serverId: server.id, threadId: payload['id']);
    final beforeRaw = await marshaller.cache.getOrFail(threadCacheKey);
    final before = await marshaller.serializers.thread.serializeCache(beforeRaw);

    before.server = server;
    before.owner.member.server = server;

    final after = await marshaller.serializers.thread.serializeRemote(payload);

    after.server = server;
    after.owner.member.server = server;

    final afterRaw = await marshaller.serializers.thread.deserialize(after);

    await marshaller.cache.put(threadCacheKey, afterRaw);

    dispatch(event: Event.serverThreadUpdate, params: [before, after, server]);
  }
}
