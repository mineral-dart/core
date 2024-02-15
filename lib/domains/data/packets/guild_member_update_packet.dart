import 'package:mineral/application/logger/logger.dart';
import 'package:mineral/domains/data/types/listenable_packet.dart';
import 'package:mineral/domains/data/types/packet_type.dart';
import 'package:mineral/domains/marshaller/marshaller.dart';
import 'package:mineral/domains/shared/mineral_event.dart';
import 'package:mineral/domains/wss/shard_message.dart';

final class GuildMemberUpdatePacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.guildMemberUpdate;

  final LoggerContract logger;
  final MarshallerContract marshaller;

  const GuildMemberUpdatePacket(this.logger, this.marshaller);

  @override
  void listen(ShardMessage message, DispatchEvent dispatch) {

    final String serverId = message.payload['guild_id'];
    final server = marshaller.storage.servers[serverId];

    if (server == null) {
      return;
    }

    final member = marshaller.serializers.member.serialize({
      ...message.payload,
      'guild_roles': server.roles.list
    });

    server.members.add(member);

    dispatch(event: MineralEvent.serverMemberAdd, params: [member, server]);
  }
}
