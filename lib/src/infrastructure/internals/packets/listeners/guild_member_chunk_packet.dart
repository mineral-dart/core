import 'package:mineral/contracts.dart';
import 'package:mineral/src/api/common/presence.dart';
import 'package:mineral/src/domains/services/container/ioc_container.dart';
import 'package:mineral/src/infrastructure/internals/packets/listenable_packet.dart';
import 'package:mineral/src/infrastructure/internals/packets/packet_type.dart';
import 'package:mineral/src/infrastructure/internals/wss/shard_message.dart';

final class GuildMemberChunkPacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.guildMemberChunk;

  MarshallerContract get _marshaller => ioc.resolve<MarshallerContract>();

  DataStoreContract get _dataStore => ioc.resolve<DataStoreContract>();

  @override
  Future<void> listen(ShardMessage message, DispatchEvent dispatch) async {
    throw UnimplementedError();
    // final server =
    //     await _dataStore.server.get(message.payload['guild_id'], false);
    //
    // final rawMembers =
    //     await List.from(message.payload['members']).map((element) async {
    //   return _marshaller.serializers.member.normalize(element);
    // }).wait;
    //
    // await rawMembers.nonNulls.map((element) async {
    //   final member = await _marshaller.serializers.member.serialize(element);
    //   server.members.list
    //       .update(member.id, (value) => member, ifAbsent: () => member);
    // }).wait;
    //
    // final presences = message.payload['presences'];
    //
    // for (final rawPresence in presences) {
    //   final presence = Presence.fromJson(rawPresence);
    //   server.members.list[rawPresence['user']['id']]!.presence = presence;
    // }
    //
    // final rawServer = await _marshaller.serializers.server.deserialize(server);
    // final serverCacheKey = _marshaller.cacheKey.server(server.id.value);
    //
    // await _marshaller.cache?.put(serverCacheKey, rawServer);
  }
}
