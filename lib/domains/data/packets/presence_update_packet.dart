import 'package:mineral/api/common/presence.dart';
import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/application/logger/logger.dart';
import 'package:mineral/domains/data/types/listenable_packet.dart';
import 'package:mineral/domains/data/types/packet_type.dart';
import 'package:mineral/domains/marshaller/marshaller.dart';
import 'package:mineral/domains/shared/mineral_event.dart';
import 'package:mineral/domains/wss/shard_message.dart';

final class PresenceUpdatePacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.presenceUpdate;

  final LoggerContract logger;
  final MarshallerContract marshaller;

  const PresenceUpdatePacket(this.logger, this.marshaller);

  @override
  Future<void> listen(ShardMessage message, DispatchEvent dispatch) async {
    final server = await marshaller.dataStore.server.getServer(message.payload['guild_id']);
    final member = await marshaller.dataStore.member.getMember(
        guildId: server.id, memberId: Snowflake(message.payload['user']['id']));

    final presence = Presence.fromJson(message.payload);
    member.presence = presence;

    final rawMember = await marshaller.serializers.member.deserialize(member);
    final rawServer = await marshaller.serializers.server.deserialize(server);

    await marshaller.cache.put(member.id, rawMember);
    await marshaller.cache.put(server.id, rawServer);

    dispatch(event: MineralEvent.serverPresenceUpdate, params: [member, server, presence]);
  }
}