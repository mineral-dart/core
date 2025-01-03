import 'package:mineral/contracts.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/services/container/ioc_container.dart';
import 'package:mineral/src/infrastructure/internals/packets/listenable_packet.dart';
import 'package:mineral/src/infrastructure/internals/packets/packet_type.dart';
import 'package:mineral/src/infrastructure/internals/wss/shard_message.dart';

final class ThreadDeletePacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.threadDelete;

  MarshallerContract get _marshaller => ioc.resolve<MarshallerContract>();

  DataStoreContract get _dataStore => ioc.resolve<DataStoreContract>();

  @override
  Future<void> listen(ShardMessage message, DispatchEvent dispatch) async {
    throw UnimplementedError();
    // final payload = message.payload;
    //
    // final server = await _dataStore.server.get(payload['guild_id'], false);
    //
    // final threadCacheKey = _marshaller.cacheKey.thread(payload['id']);
    // final threadRaw = await _marshaller.cache?.getOrFail(threadCacheKey);
    // final thread = await _marshaller.serializers.thread.serialize(threadRaw);
    //
    // await _marshaller.cache?.remove(threadCacheKey);
    //
    // dispatch(event: Event.serverThreadDelete, params: [thread, server]);
  }
}
