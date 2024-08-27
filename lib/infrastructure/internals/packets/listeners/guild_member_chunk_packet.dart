import 'package:mineral/api/common/presence.dart';
import 'package:mineral/infrastructure/internals/marshaller/marshaller.dart';
import 'package:mineral/infrastructure/internals/packets/listenable_packet.dart';
import 'package:mineral/infrastructure/internals/packets/packet_type.dart';
import 'package:mineral/infrastructure/internals/wss/shard_message.dart';
import 'package:mineral/infrastructure/services/logger/logger.dart';

final class GuildMemberChunkPacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.guildMemberChunk;

  final LoggerContract logger;
  final MarshallerContract marshaller;

  const GuildMemberChunkPacket(this.logger, this.marshaller);

  @override
  Future<void> listen(ShardMessage message, DispatchEvent dispatch) async {
    final server = await marshaller.dataStore.server
        .getServer(message.payload['guild_id']);

    final rawMembers =
        await List.from(message.payload['members']).map((element) async {
      return marshaller.serializers.member.normalize(element);
    }).wait;

    await rawMembers.nonNulls.map((element) async {
      final member = await marshaller.serializers.member.serialize(element);
      server.members.list
          .update(member.id, (value) => member, ifAbsent: () => member);
    }).wait;

    final presences = message.payload['presences'];

    for (final rawPresence in presences) {
      final presence = Presence.fromJson(rawPresence);
      server.members.list[rawPresence['user']['id']]!.presence = presence;
    }

    final rawServer = await marshaller.serializers.server.deserialize(server);
    final serverCacheKey = marshaller.cacheKey.server(server.id);

    await marshaller.cache.put(serverCacheKey, rawServer);
  }
}
