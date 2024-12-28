import 'package:mineral/contracts.dart';
import 'package:mineral/src/domains/services/container/ioc_container.dart';
import 'package:mineral/src/infrastructure/internals/packets/listenable_packet.dart';
import 'package:mineral/src/infrastructure/internals/packets/packet_type.dart';
import 'package:mineral/src/infrastructure/internals/wss/shard_message.dart';

final class ThreadMemberUpdatePacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.threadMemberUpdate;

  MarshallerContract get _marshaller => ioc.resolve<MarshallerContract>();

  DataStoreContract get _dataStore => ioc.resolve<DataStoreContract>();

  @override
  Future<void> listen(ShardMessage message, DispatchEvent dispatch) async {
    throw UnimplementedError();

    // final payload = message.payload;
    //
    // final server = await _dataStore.server.get(payload['guild_id'], false);
    // final thread = await _dataStore.channel.getThread(Snowflake(payload['id']))
    //     as ThreadChannel;
    // final member = await _dataStore.member.get(
    //     payload['user_id'], server.id.value, false);
    //
    // // thread.members[member.id] = member;
    //
    // final serverRaw = await _marshaller.serializers.server.deserialize(server);
    // final serverKey = _marshaller.cacheKey.server(server.id.value);
    //
    // _marshaller.cache.put(serverKey, serverRaw);
    //
    // dispatch(
    //     event: Event.serverThreadMemberUpdate,
    //     params: [thread, server, member]);
  }
}
