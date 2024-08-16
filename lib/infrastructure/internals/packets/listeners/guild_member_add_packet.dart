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
    final member = await marshaller.serializers.member.serialize({...message.payload, 'guild_roles': server.roles.list.values.toList()});

    server.members.list.putIfAbsent(member.id, () => member);

    final rawServer = await marshaller.serializers.server.deserialize(server);
    final rawMember = await marshaller.serializers.member.deserialize(member);

    await marshaller.cache.putMany({
      marshaller.cacheKey.server(server.id): rawServer,
      marshaller.cacheKey.member(server.id, member.id): rawMember
    });

    dispatch(event: Event.serverMemberAdd, params: [member, server]);
  }
}
