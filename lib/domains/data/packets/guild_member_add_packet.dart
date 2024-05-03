import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/infrastructure/services/logger/logger.dart';
import 'package:mineral/domains/data/types/listenable_packet.dart';
import 'package:mineral/domains/data/types/packet_type.dart';
import 'package:mineral/infrastructure/marshaller/marshaller.dart';
import 'package:mineral/domains/shared/mineral_event.dart';
import 'package:mineral/domains/wss/shard_message.dart';

final class GuildMemberAddPacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.guildMemberAdd;

  final LoggerContract logger;
  final MarshallerContract marshaller;

  const GuildMemberAddPacket(this.logger, this.marshaller);

  @override
  Future<void> listen(ShardMessage message, DispatchEvent dispatch) async {
    final Snowflake serverId = Snowflake(message.payload['guild_id']);
    final server = await marshaller.dataStore.server.getServer(serverId);

    final member = await marshaller.serializers.member.serialize({
      ...message.payload,
      'guild_roles': server.roles.list
    });

    server.members.list.putIfAbsent(member.id, () => member);

    final rawServer = await marshaller.serializers.server.deserialize(server);
    await marshaller.cache.put(server.id, rawServer);

    dispatch(event: MineralEvent.serverMemberAdd, params: [member, server]);
  }
}
