import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/application/logger/logger.dart';
import 'package:mineral/domains/data/types/listenable_packet.dart';
import 'package:mineral/domains/data/types/packet_type.dart';
import 'package:mineral/domains/marshaller/marshaller.dart';
import 'package:mineral/domains/shared/mineral_event.dart';
import 'package:mineral/domains/wss/shard_message.dart';

final class GuildRoleDeletePacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.guildRoleDelete;

  final LoggerContract logger;
  final MarshallerContract marshaller;

  const GuildRoleDeletePacket(this.logger, this.marshaller);

  @override
  Future<void> listen(ShardMessage message, DispatchEvent dispatch) async {
    final guildId = Snowflake(message.payload['guild_id']);
    final roleId = Snowflake(message.payload['role_id']);

    final server = await marshaller.dataStore.server.getServer(guildId);
    final role = await marshaller.dataStore.server.getRole(guildId, roleId);

    server.roles.list.remove(roleId);

    final rawServer = await marshaller.serializers.server.deserialize(server);

    await Future.wait([
      marshaller.cache.remove(roleId),
      marshaller.cache.put(server.id, rawServer)
    ]);

    dispatch(event: MineralEvent.serverRoleDelete, params: [role, server]);
  }
}
