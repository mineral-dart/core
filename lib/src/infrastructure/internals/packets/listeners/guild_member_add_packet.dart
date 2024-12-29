import 'package:mineral/contracts.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/services/container/ioc_container.dart';
import 'package:mineral/src/infrastructure/internals/packets/listenable_packet.dart';
import 'package:mineral/src/infrastructure/internals/packets/packet_type.dart';
import 'package:mineral/src/infrastructure/internals/wss/shard_message.dart';

final class GuildMemberAddPacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.guildMemberAdd;

  MarshallerContract get _marshaller => ioc.resolve<MarshallerContract>();

  DataStoreContract get _dataStore => ioc.resolve<DataStoreContract>();

  @override
  Future<void> listen(ShardMessage message, DispatchEvent dispatch) async {
    throw UnimplementedError();
    // final server =
    //     await _dataStore.server.get(message.payload['guild_id'], false);
    //
    // final rawMember = await _marshaller.serializers.member.normalize({
    //   'server_id': server.id,
    //   ...message.payload,
    // });
    //
    // final member = await _marshaller.serializers.member.serialize(rawMember);
    //
    // server.members.list.putIfAbsent(member.id, () => member);
    //
    // final rawServer = await _marshaller.serializers.server.deserialize(server);
    //
    // final serverCacheKey = _marshaller.cacheKey.server(server.id.value);
    // await _marshaller.cache.put(serverCacheKey, rawServer);
    //
    // dispatch(event: Event.serverMemberAdd, params: [member, server]);
  }
}
