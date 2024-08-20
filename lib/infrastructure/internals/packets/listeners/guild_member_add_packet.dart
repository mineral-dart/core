import 'package:mineral/domains/events/event.dart';
import 'package:mineral/infrastructure/internals/marshaller/marshaller.dart';
import 'package:mineral/infrastructure/internals/packets/listenable_packet.dart';
import 'package:mineral/infrastructure/internals/packets/packet_type.dart';
import 'package:mineral/infrastructure/internals/wss/shard_message.dart';
import 'package:mineral/infrastructure/services/logger/logger.dart';

final class GuildMemberAddPacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.guildMemberAdd;

  final LoggerContract logger;
  final MarshallerContract marshaller;

  const GuildMemberAddPacket(this.logger, this.marshaller);

  @override
  Future<void> listen(ShardMessage message, DispatchEvent dispatch) async {
    final server = await marshaller.dataStore.server.getServer(message.payload['guild_id']);

    final rawMember = await marshaller.serializers.member.normalize(message.payload);
    final member = await marshaller.serializers.member.serialize(rawMember);

    server.members.list.putIfAbsent(member.id, () => member);

    final rawServer = await marshaller.serializers.server.deserialize(server);

    final serverCacheKey = marshaller.cacheKey.server(server.id);
    await marshaller.cache.put(serverCacheKey, rawServer);

    dispatch(event: Event.serverMemberAdd, params: [member, server]);
  }
}
