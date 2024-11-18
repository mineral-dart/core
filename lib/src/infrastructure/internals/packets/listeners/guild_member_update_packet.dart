import 'package:mineral/container.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/marshaller.dart';
import 'package:mineral/src/infrastructure/internals/packets/listenable_packet.dart';
import 'package:mineral/src/infrastructure/internals/packets/packet_type.dart';
import 'package:mineral/src/infrastructure/internals/wss/shard_message.dart';
import 'package:mineral/src/infrastructure/services/logger/logger.dart';

final class GuildMemberUpdatePacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.guildMemberUpdate;

  MarshallerContract get _marshaller => ioc.resolve<MarshallerContract>();

  @override
  Future<void> listen(ShardMessage message, DispatchEvent dispatch) async {
    final server = await _marshaller.dataStore.server
        .getServer(message.payload['guild_id']);

    final before = _marshaller.dataStore.member.getMember(
      serverId: server.id,
      memberId: message.payload['user']['id'],
    );

    final rawMember =
        await _marshaller.serializers.member.normalize(message.payload);
    final member = await _marshaller.serializers.member.serialize(rawMember);

    member.server = server;
    server.members.list.update(member.id, (_) => member);

    final serverCacheKey = _marshaller.cacheKey.server(server.id);
    final rawServer = await _marshaller.serializers.server.deserialize(server);

    await _marshaller.cache.put(serverCacheKey, rawServer);

    dispatch(event: Event.serverMemberUpdate, params: [before, member]);
  }
}
