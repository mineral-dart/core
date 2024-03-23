import 'package:mineral/application/logger/logger.dart';
import 'package:mineral/domains/data/types/listenable_packet.dart';
import 'package:mineral/domains/data/types/packet_type.dart';
import 'package:mineral/domains/marshaller/marshaller.dart';
import 'package:mineral/domains/shared/mineral_event.dart';
import 'package:mineral/domains/wss/shard_message.dart';

final class GuildCreatePacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.guildCreate;

  final LoggerContract logger;
  final MarshallerContract marshaller;

  const GuildCreatePacket(this.logger, this.marshaller);

  @override
  Future<void> listen(ShardMessage message, DispatchEvent dispatch) async {
    final server = await marshaller.serializers.server.serialize(message.payload);

    for (final role in server.roles.list.values) {
      await marshaller.cache.put(role.id, await marshaller.serializers.role.deserialize(role));
    }

    for (final channel in server.channels.list.values) {
      await marshaller.cache.put(channel.id, await marshaller.serializers.channels.deserialize(channel));
    }

    for (final member in server.members.list.values) {
      await marshaller.cache.put(member.id, await marshaller.serializers.member.deserialize(member));
    }

    await marshaller.cache.put(server.id, await marshaller.serializers.server.deserialize(server));
    dispatch(event: MineralEvent.serverCreate, params: [server]);
  }
}
