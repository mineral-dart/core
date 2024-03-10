import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/application/logger/logger.dart';
import 'package:mineral/domains/data/types/listenable_packet.dart';
import 'package:mineral/domains/data/types/packet_type.dart';
import 'package:mineral/domains/marshaller/marshaller.dart';
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
    final rawServer = await marshaller.cache.get(serverId);

    if (rawServer == null) {
      return;
    }

    final server = await marshaller.serializers.server.serialize(rawServer);
    final member = await marshaller.serializers.member.serialize({
      ...message.payload,
      'guild_roles': server.roles.list
    });

    await marshaller.cache.put(member.id, message.payload);
    server.members.list.putIfAbsent(member.id, () => member);
    // TODO: Add deserialize server then put in cache

    dispatch(event: MineralEvent.serverMemberAdd, params: [member, server]);
  }
}
