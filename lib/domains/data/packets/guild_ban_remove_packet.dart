import 'package:mineral/infrastructure/logger/logger.dart';
import 'package:mineral/domains/data/types/listenable_packet.dart';
import 'package:mineral/domains/data/types/packet_type.dart';
import 'package:mineral/infrastructure/marshaller/marshaller.dart';
import 'package:mineral/domains/shared/mineral_event.dart';
import 'package:mineral/domains/wss/shard_message.dart';

final class GuildBanRemovePacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.guildBanRemove;

  final LoggerContract logger;
  final MarshallerContract marshaller;

  const GuildBanRemovePacket(this.logger, this.marshaller);

  @override
  Future<void> listen(ShardMessage message, DispatchEvent dispatch) async {
    final server = await marshaller.dataStore.server.getServer(message.payload['guild_id']);
    final user = await marshaller.serializers.user.serialize(message.payload['user']);

    dispatch(event: MineralEvent.serverBanRemove, params: [user, server]);
  }
}
