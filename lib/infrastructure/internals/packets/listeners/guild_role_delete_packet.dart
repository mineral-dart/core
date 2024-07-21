import 'package:mineral/infrastructure/services/logger/logger.dart';
import 'package:mineral/infrastructure/internals/packets/listenable_packet.dart';
import 'package:mineral/infrastructure/internals/packets/packet_type.dart';
import 'package:mineral/infrastructure/internals/marshaller/marshaller.dart';
import 'package:mineral/domains/events/event.dart';
import 'package:mineral/infrastructure/internals/wss/shard_message.dart';

final class GuildRoleDeletePacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.guildRoleDelete;

  final LoggerContract logger;
  final MarshallerContract marshaller;

  const GuildRoleDeletePacket(this.logger, this.marshaller);

  @override
  Future<void> listen(ShardMessage message, DispatchEvent dispatch) async {
    final server = await marshaller.dataStore.server.getServer(message.payload['guild_id']);
    final role = await marshaller.dataStore.role.getRole(
      guildId: server.id,
      roleId: message.payload['role_id'],
    );

    server.roles.list.remove(role.id);

    final serverCacheKey = marshaller.cacheKey.server(server.id);
    final roleCacheKey = marshaller.cacheKey.serverRole(serverId: server.id, roleId: role.id);

    final rawServer = await marshaller.serializers.server.deserialize(server);
    await Future.wait([
      marshaller.cache.put(serverCacheKey, rawServer),
      marshaller.cache.remove(roleCacheKey),
    ]);

    dispatch(event: Event.serverRoleDelete, params: [role, server]);
  }
}
