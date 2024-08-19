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
    final server = await marshaller.dataStore.server.getServer(message.payload['guild_id']);

    final before = server.roles.list[message.payload['role']['id']];
    final after = await marshaller.serializers.role.serializeRemote(message.payload['role']);

    server.roles.list.update(after.id, (_) => after);

    final rawServer = await marshaller.serializers.server.deserialize(server);
    final rawRole = await marshaller.serializers.role.deserialize(after);

    dispatch(event: Event.serverRoleUpdate, params: [before, after, server]);

    await marshaller.cache.putMany({
      marshaller.cacheKey.server(server.id): rawServer,
      marshaller.cacheKey.serverRole(serverId: server.id, roleId: after.id): rawRole,
    });
  }
}
