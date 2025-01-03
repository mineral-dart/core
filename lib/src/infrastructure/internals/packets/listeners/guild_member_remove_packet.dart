import 'package:mineral/contracts.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/services/container/ioc_container.dart';
import 'package:mineral/src/infrastructure/internals/packets/listenable_packet.dart';
import 'package:mineral/src/infrastructure/internals/packets/packet_type.dart';
import 'package:mineral/src/infrastructure/internals/wss/shard_message.dart';

final class GuildMemberRemovePacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.guildMemberRemove;

  MarshallerContract get _marshaller => ioc.resolve<MarshallerContract>();

  DataStoreContract get _dataStore => ioc.resolve<DataStoreContract>();

  @override
  Future<void> listen(ShardMessage message, DispatchEvent dispatch) async {
    throw UnimplementedError();
    // final server =
    //     await _dataStore.server.get(message.payload['guild_id'], false);
    // final memberId = message.payload['user']['id'];
    //
    // final serverCacheKey = _marshaller.cacheKey.server(server.id.value);
    // final memberCacheKey = _marshaller.cacheKey.member(server.id.value, memberId);
    //
    // final user = await _dataStore.user.getUser(memberId);
    //
    // server.members.list.remove(memberId);
    //
    // final rawServer = await _marshaller.serializers.server.deserialize(server);
    //
    // await _marshaller.cache?.put(serverCacheKey, rawServer);
    // await _marshaller.cache?.remove(memberCacheKey);
    //
    // dispatch(event: Event.serverMemberRemove, params: [user, server]);
  }
}
