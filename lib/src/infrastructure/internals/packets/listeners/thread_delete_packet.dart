import 'package:mineral/container.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/marshaller.dart';
import 'package:mineral/src/infrastructure/internals/packets/listenable_packet.dart';
import 'package:mineral/src/infrastructure/internals/packets/packet_type.dart';
import 'package:mineral/src/infrastructure/internals/wss/shard_message.dart';
import 'package:mineral/src/infrastructure/services/logger/logger.dart';

final class ThreadDeletePacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.threadDelete;

  MarshallerContract get _marshaller => ioc.resolve<MarshallerContract>();

  @override
  Future<void> listen(ShardMessage message, DispatchEvent dispatch) async {
    final payload = message.payload;

    final server =
        await _marshaller.dataStore.server.getServer(payload['guild_id']);

    final threadCacheKey = _marshaller.cacheKey.thread(payload['id']);
    final threadRaw = await _marshaller.cache.getOrFail(threadCacheKey);
    final thread = await _marshaller.serializers.thread.serialize(threadRaw);

    await _marshaller.cache.remove(threadCacheKey);

    dispatch(event: Event.serverThreadDelete, params: [thread, server]);
  }
}
