import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/marshaller.dart';
import 'package:mineral/src/infrastructure/internals/packets/listenable_packet.dart';
import 'package:mineral/src/infrastructure/internals/packets/packet_type.dart';
import 'package:mineral/src/infrastructure/internals/wss/shard_message.dart';
import 'package:mineral/src/infrastructure/services/logger/logger.dart';

final class GuildRoleDeletePacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.guildRoleDelete;

  final LoggerContract logger;
  final MarshallerContract marshaller;

  const GuildRoleDeletePacket(this.logger, this.marshaller);

  @override
  Future<void> listen(ShardMessage message, DispatchEvent dispatch) async {
    final server = await marshaller.dataStore.server
        .getServer(message.payload['guild_id']);

    final roleId = message.payload['role']['id'];

    final roleCacheKey = marshaller.cacheKey.serverRole(server.id, roleId);
    final rawRole = await marshaller.cache.get(roleCacheKey);
    final role = rawRole != null
        ? await marshaller.serializers.role.serialize(rawRole)
        : null;

    server.roles.list.remove(roleId);

    final serverCacheKey = marshaller.cacheKey.server(server.id);

    final rawServer = await marshaller.serializers.server.deserialize(server);
    await marshaller.cache.put(serverCacheKey, rawServer);
    await marshaller.cache.remove(roleCacheKey);

    dispatch(event: Event.serverRoleDelete, params: [role, server]);
  }
}
