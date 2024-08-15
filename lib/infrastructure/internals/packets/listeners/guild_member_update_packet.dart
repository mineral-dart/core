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
      guildId: server.id,
      memberId: message.payload['user']['id'],
    );

    final after = await marshaller.serializers.member
        .serializeRemote({...message.payload, 'guild_roles': server.roles.list.values.toList()});

    server.members.list.update(after.id, (_) => after);

    final serverCacheKey = marshaller.cacheKey.server(server.id);
    final memberCacheKey =
        marshaller.cacheKey.serverMember(serverId: server.id, memberId: after.id);

    final rawServer = await marshaller.serializers.server.deserialize(server);
    final rawMember = await marshaller.serializers.member.deserialize(after);

    await Future.wait([
      marshaller.cache.put(serverCacheKey, rawServer),
      marshaller.cache.put(memberCacheKey, rawMember),
    ]);

    dispatch(event: Event.serverMemberUpdate, params: [before, after]);
  }
}
