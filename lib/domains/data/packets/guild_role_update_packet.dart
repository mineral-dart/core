import 'package:mineral/infrastructure/services/logger/logger.dart';
import 'package:mineral/domains/data/types/listenable_packet.dart';
import 'package:mineral/domains/data/types/packet_type.dart';
import 'package:mineral/infrastructure/marshaller/marshaller.dart';
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

    final before = server.roles.list[message.payload['role']['id']];
    final after = await marshaller.serializers.role.serialize(message.payload['role']);

    server.roles.list.update(after.id, (_) => after);

    final rawServer = await marshaller.serializers.server.deserialize(server);
    await marshaller.cache.put(server.id, rawServer);

    dispatch(event: MineralEvent.serverRoleUpdate, params: [before, after, server]);
  }
}
