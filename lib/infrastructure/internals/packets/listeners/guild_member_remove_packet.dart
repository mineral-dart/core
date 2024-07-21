import 'package:mineral/domains/events/event.dart';
import 'package:mineral/infrastructure/internals/marshaller/marshaller.dart';
import 'package:mineral/infrastructure/internals/packets/listenable_packet.dart';
import 'package:mineral/infrastructure/internals/packets/packet_type.dart';
import 'package:mineral/infrastructure/internals/wss/shard_message.dart';
import 'package:mineral/infrastructure/services/logger/logger.dart';

final class GuildMemberRemovePacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.guildMemberRemove;

  final LoggerContract logger;
  final MarshallerContract marshaller;

  const GuildMemberRemovePacket(this.logger, this.marshaller);

  @override
  Future<void> listen(ShardMessage message, DispatchEvent dispatch) async {
    final server = await marshaller.dataStore.server.getServer(message.payload['guild_id']);
    final member = await marshaller.dataStore.member
        .getMember(guildId: message.payload['guild_id'], memberId: message.payload['user']['id']);

    final serverCacheKey = marshaller.cacheKey.server(server.id);
    final memberCacheKey =
        marshaller.cacheKey.serverMember(serverId: server.id, memberId: member.id);

    server.members.list.remove(member.id);

    final rawServer = await marshaller.serializers.server.deserialize(server);
    await Future.wait([
      marshaller.cache.put(serverCacheKey, rawServer),
      marshaller.cache.remove(memberCacheKey),
    ]);

    dispatch(event: Event.serverMemberRemove, params: [member, server]);
  }
}
