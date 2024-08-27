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
    final server = await marshaller.dataStore.server
        .getServer(message.payload['guild_id']);
    final rawRole = await marshaller.serializers.role.normalize({
      ...message.payload['role'],
      'server_id': server.id,
    });

    final role = await marshaller.serializers.role.serialize(rawRole);

    server.roles.list.putIfAbsent(role.id, () => role);

    final serverCacheKey = marshaller.cacheKey.server(server.id);
    final rawServer = await marshaller.serializers.server.deserialize(server);

    await marshaller.cache.put(serverCacheKey, rawServer);

    dispatch(event: Event.serverRoleCreate, params: [role, server]);
  }
}
