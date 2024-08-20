import 'package:mineral/domains/events/event.dart';
import 'package:mineral/infrastructure/internals/marshaller/marshaller.dart';
import 'package:mineral/infrastructure/internals/packets/listenable_packet.dart';
import 'package:mineral/infrastructure/internals/packets/packet_type.dart';
import 'package:mineral/infrastructure/internals/wss/shard_message.dart';
import 'package:mineral/infrastructure/services/logger/logger.dart';

final class GuildMemberUpdatePacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.guildMemberUpdate;

  final LoggerContract logger;
  final MarshallerContract marshaller;

  const GuildMemberUpdatePacket(this.logger, this.marshaller);

  @override
  Future<void> listen(ShardMessage message, DispatchEvent dispatch) async {
    final server = await marshaller.dataStore.server.getServer(message.payload['guild_id']);

    final before = marshaller.dataStore.member.getMember(
      serverId: server.id,
      memberId: message.payload['user']['id'],
    );

    final rawMember = await marshaller.serializers.member.normalize(message.payload);
    final member = await marshaller.serializers.member.serialize(rawMember);

    member.server = server;
    server.members.list.update(member.id, (_) => member);

    final serverCacheKey = marshaller.cacheKey.server(server.id);
    final rawServer = await marshaller.serializers.server.deserialize(server);

    await marshaller.cache.put(serverCacheKey, rawServer);

    dispatch(event: Event.serverMemberUpdate, params: [before, member]);
  }
}
