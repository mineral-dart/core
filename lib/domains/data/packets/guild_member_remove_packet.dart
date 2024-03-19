import 'package:mineral/api/private/user.dart';
import 'package:mineral/application/logger/logger.dart';
import 'package:mineral/domains/data/types/listenable_packet.dart';
import 'package:mineral/domains/data/types/packet_type.dart';
import 'package:mineral/domains/marshaller/marshaller.dart';
import 'package:mineral/domains/shared/mineral_event.dart';
import 'package:mineral/domains/wss/shard_message.dart';

final class GuildMemberRemovePacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.guildMemberRemove;

  final LoggerContract logger;
  final MarshallerContract marshaller;

  const GuildMemberRemovePacket(this.logger, this.marshaller);

  @override
  Future<void> listen(ShardMessage message, DispatchEvent dispatch) async {
    final String serverId = message.payload['guild_id'];
    final rawServer = await marshaller.cache.get(serverId);

    if (rawServer == null) {
      return;
    }

    final server = await marshaller.serializers.server.serialize(rawServer);
    final member = server.members.get(message.payload['user']['id']);

    server.members.list.remove(member?.id);
    marshaller.cache.remove(member?.id);

    await marshaller.cache.put(server.id, await marshaller.serializers.server.deserialize(server));

    dispatch(event: MineralEvent.serverMemberRemove, params: [member, server]);
  }
}
