import 'package:mineral/application/logger/logger.dart';
import 'package:mineral/domains/data/types/listenable_packet.dart';
import 'package:mineral/domains/data/types/packet_type.dart';
import 'package:mineral/domains/marshaller/marshaller.dart';
import 'package:mineral/domains/shared/mineral_event.dart';
import 'package:mineral/domains/wss/shard_message.dart';

final class GuildRoleUpdatePacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.guildRoleUpdate;

  final LoggerContract logger;
  final MarshallerContract marshaller;

  const GuildRoleUpdatePacket(this.logger, this.marshaller);

  @override
  Future<void> listen(ShardMessage message, DispatchEvent dispatch) async {
    final server = await marshaller.dataStore.server.getServer(message.payload['guild_id']);

    final before = await marshaller.cache.get(message.payload['role_id']);
    final after = await marshaller.serializers.role.serialize(message.payload['role']);

    server.roles.list.update(after.id, (value) => after, ifAbsent: () => after);

    await marshaller.cache.put(after.id, message.payload);
    await marshaller.cache.put(server.id, await marshaller.serializers.server.deserialize(server));

    dispatch(event: MineralEvent.serverRoleUpdate, params: [before, after, server]);
  }
}
