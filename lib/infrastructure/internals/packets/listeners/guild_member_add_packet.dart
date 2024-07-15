import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/infrastructure/services/logger/logger.dart';
import 'package:mineral/infrastructure/internals/packets/listenable_packet.dart';
import 'package:mineral/infrastructure/internals/packets/packet_type.dart';
import 'package:mineral/infrastructure/internals/marshaller/marshaller.dart';
import 'package:mineral/domains/events/event.dart';
import 'package:mineral/infrastructure/internals/wss/shard_message.dart';

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

    final member = await marshaller.serializers.member.serializeRemote({
      ...message.payload,
      'guild_roles': server.roles.list
    });

    server.members.list.putIfAbsent(member.id, () => member);

    final rawServer = await marshaller.serializers.server.deserialize(server);
    await marshaller.cache.put(server.id.value, rawServer);

    dispatch(event: Event.serverMemberAdd, params: [member, server]);
  }
}
