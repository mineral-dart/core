import 'package:mineral/domains/events/event.dart';
import 'package:mineral/infrastructure/internals/marshaller/marshaller.dart';
import 'package:mineral/infrastructure/internals/packets/listenable_packet.dart';
import 'package:mineral/infrastructure/internals/packets/packet_type.dart';
import 'package:mineral/infrastructure/internals/wss/shard_message.dart';
import 'package:mineral/infrastructure/services/logger/logger.dart';

final class GuildRoleUpdatePacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.guildRoleUpdate;

  final LoggerContract logger;
  final MarshallerContract marshaller;

  const GuildRoleUpdatePacket(this.logger, this.marshaller);

  @override
  Future<void> listen(ShardMessage message, DispatchEvent dispatch) async {
    final serverCacheKey =
        marshaller.cacheKey.server(message.payload['guild_id']);
    final server = await marshaller.dataStore.server
        .getServer(message.payload['guild_id']);

    final roleCacheKey = marshaller.cacheKey
        .serverRole(server.id, message.payload['role']['id']);
    final rawBefore = await marshaller.cache.get(roleCacheKey);
    final before = rawBefore != null
        ? marshaller.serializers.role.serialize(rawBefore)
        : null;

    final rawRole =
        await marshaller.serializers.role.normalize(message.payload['role']);
    final role = await marshaller.serializers.role.serialize(rawRole);

    server.roles.list.update(role.id, (_) => role);
    role.server = server;

    final rawServer = await marshaller.serializers.server.deserialize(server);
    await marshaller.cache.put(serverCacheKey, rawServer);

    dispatch(event: Event.serverRoleUpdate, params: [before, role, server]);
  }
}
