import 'package:mineral/infrastructure/services/logger/logger.dart';
import 'package:mineral/infrastructure/internals/packets/listenable_packet.dart';
import 'package:mineral/infrastructure/internals/packets/packet_type.dart';
import 'package:mineral/infrastructure/internals/marshaller/marshaller.dart';
import 'package:mineral/infrastructure/commons/mineral_event.dart';
import 'package:mineral/infrastructure/internals/wss/shard_message.dart';

final class GuildRoleCreatePacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.guildRoleCreate;

  final LoggerContract logger;
  final MarshallerContract marshaller;

  const GuildRoleCreatePacket(this.logger, this.marshaller);

  @override
  Future<void> listen(ShardMessage message, DispatchEvent dispatch) async {
    final server = await marshaller.dataStore.server.getServer(message.payload['guild_id']);

    final role = await marshaller.serializers.role.serialize(message.payload['role']);
    server.roles.list.putIfAbsent(role.id, () => role);

    final rawServer = await marshaller.serializers.server.deserialize(server);
    await marshaller.cache.put(server.id, rawServer);

    dispatch(event: MineralEvent.serverRoleCreate, params: [role, server]);
  }
}
