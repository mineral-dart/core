import 'package:mineral/domains/events/event.dart';
import 'package:mineral/infrastructure/internals/marshaller/marshaller.dart';
import 'package:mineral/infrastructure/internals/packets/listenable_packet.dart';
import 'package:mineral/infrastructure/internals/packets/packet_type.dart';
import 'package:mineral/infrastructure/internals/wss/shard_message.dart';
import 'package:mineral/infrastructure/services/logger/logger.dart';

final class GuildRoleCreatePacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.guildRoleCreate;

  final LoggerContract logger;
  final MarshallerContract marshaller;

  const GuildRoleCreatePacket(this.logger, this.marshaller);

  @override
  Future<void> listen(ShardMessage message, DispatchEvent dispatch) async {
    final server = await marshaller.dataStore.server.getServer(message.payload['guild_id']);
    final role = await marshaller.serializers.role.serializeRemote(message.payload['role']);

    final serverCacheKey = marshaller.cacheKey.server(server.id);
    final roleCacheKey = marshaller.cacheKey.serverRole(serverId: server.id, roleId: role.id);

    server.roles.list.putIfAbsent(role.id, () => role);

    final rawServer = await marshaller.serializers.server.deserialize(server);
    final rawRole = await marshaller.serializers.role.deserialize(role);

    await Future.wait([
      marshaller.cache.put(serverCacheKey, rawServer),
      marshaller.cache.put(roleCacheKey, rawRole),
    ]);

    dispatch(event: Event.serverRoleCreate, params: [role, server]);
  }
}
