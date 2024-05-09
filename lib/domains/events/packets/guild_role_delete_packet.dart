import 'package:mineral/infrastructure/services/logger/logger.dart';
import 'package:mineral/domains/events/types/listenable_packet.dart';
import 'package:mineral/domains/events/types/packet_type.dart';
import 'package:mineral/infrastructure/internals/marshaller/marshaller.dart';
import 'package:mineral/infrastructure/commons/mineral_event.dart';
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
    final role = server.roles.list[message.payload['role_id']];

    server.roles.list.remove(role?.id);

    final rawServer = await marshaller.serializers.server.deserialize(server);
    await marshaller.cache.put(server.id, rawServer);

    dispatch(event: MineralEvent.serverRoleDelete, params: [role, server]);
  }
}
