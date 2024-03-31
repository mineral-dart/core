import 'package:mineral/api/common/presence.dart';
import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/application/logger/logger.dart';
import 'package:mineral/domains/data/types/listenable_packet.dart';
import 'package:mineral/domains/data/types/packet_type.dart';
import 'package:mineral/domains/marshaller/marshaller.dart';
import 'package:mineral/domains/wss/shard_message.dart';

final class GuildMemberChunkPacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.guildMemberChunk;

  final LoggerContract logger;
  final MarshallerContract marshaller;

  const GuildMemberChunkPacket(this.logger, this.marshaller);

  @override
  Future<void> listen(ShardMessage message, DispatchEvent dispatch) async {
    final Snowflake serverId = message.payload['guild_id'];
    final server = await marshaller.dataStore.server.getServer(serverId);
    final members = message.payload['members'];
    final presences = message.payload['presences'];

    for (final rawMember in members) {
      final member = await marshaller.serializers.member.serialize(rawMember);
      server.members.list.putIfAbsent(member.id, () => member);
      await marshaller.cache.put('${server.id}:${member.id}', rawMember);
    }

    for (final rawPresence in presences) {
      final presence = Presence.fromJson(rawPresence);
      server.members.list[rawPresence['user']['id']]!.presence = presence;
    }

    final rawServer = await marshaller.serializers.server.deserialize(server);
    await marshaller.cache.put(server.id, rawServer);
  }
}
