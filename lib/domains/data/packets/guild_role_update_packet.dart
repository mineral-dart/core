import 'package:mineral/api/common/snowflake.dart';
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
    final guildId = Snowflake(message.payload['guild_id']);
    final roleId = Snowflake(message.payload['role']['id']);

    final server = await marshaller.dataStore.server.getServer(message.payload['guild_id']);

    final before = await marshaller.dataStore.server.getRole(guildId, roleId);
    final after = await marshaller.serializers.role.serialize(message.payload['role']);

    server.roles.list.update(after.id, (value) => after);

    final rawServer = await marshaller.serializers.server.deserialize(server);
    final rawRole = await marshaller.serializers.role.deserialize(after);

    await Future.wait([
      marshaller.cache.put(after.id, rawRole),
      marshaller.cache.put(server.id, rawServer)
    ]);

    dispatch(event: MineralEvent.serverRoleUpdate, params: [before, after, server]);
  }
}
