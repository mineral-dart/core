import 'package:mineral/application/logger/logger.dart';
import 'package:mineral/domains/data/types/listenable_packet.dart';
import 'package:mineral/domains/data/types/packet_type.dart';
import 'package:mineral/domains/marshaller/marshaller.dart';
import 'package:mineral/domains/shared/mineral_event.dart';
import 'package:mineral/domains/wss/shard_message.dart';

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

    await marshaller.cache.put(server.id, await marshaller.serializers.server.deserialize(server));
    await marshaller.cache.put(role.id, await marshaller.serializers.role.deserialize(role));

    dispatch(event: MineralEvent.serverRoleCreate, params: [role, server]);
  }
}
