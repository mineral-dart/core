import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/marshaller.dart';
import 'package:mineral/src/infrastructure/internals/packets/listenable_packet.dart';
import 'package:mineral/src/infrastructure/internals/packets/packet_type.dart';
import 'package:mineral/src/infrastructure/internals/wss/shard_message.dart';
import 'package:mineral/src/infrastructure/services/logger/logger.dart';

final class GuildBanAddPacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.guildBanAdd;

  final LoggerContract logger;
  final MarshallerContract marshaller;

  const GuildBanAddPacket(this.logger, this.marshaller);

  @override
  Future<void> listen(ShardMessage message, DispatchEvent dispatch) async {
    final server = await marshaller.dataStore.server
        .getServer(message.payload['guild_id']);
    final user =
        await marshaller.serializers.user.serialize(message.payload['user']);
    final member = server.members.list[user.id];
    final memberId = message.payload['user']['id'];

    final memberCacheKey = marshaller.cacheKey.member(server.id, memberId);
    final rawServer = await marshaller.serializers.server.deserialize(server);
    final serverCacheKey = marshaller.cacheKey.server(server.id);

    server.members.list.remove(user.id);

    await marshaller.cache.remove(memberCacheKey);
    await marshaller.cache.put(serverCacheKey, rawServer);

    dispatch(event: Event.serverBanAdd, params: [member, user, server]);
  }
}
