import 'package:mineral/domains/events/event.dart';
import 'package:mineral/infrastructure/internals/marshaller/marshaller.dart';
import 'package:mineral/infrastructure/internals/packets/listenable_packet.dart';
import 'package:mineral/infrastructure/internals/packets/packet_type.dart';
import 'package:mineral/infrastructure/internals/wss/shard_message.dart';
import 'package:mineral/infrastructure/services/logger/logger.dart';

final class GuildBanRemovePacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.guildBanRemove;

  final LoggerContract logger;
  final MarshallerContract marshaller;

  const GuildBanRemovePacket(this.logger, this.marshaller);

  @override
  Future<void> listen(ShardMessage message, DispatchEvent dispatch) async {
    final server = await marshaller.dataStore.server.getServer(message.payload['guild_id']);
    final user = await marshaller.serializers.user.serializeRemote(message.payload['user']);

    dispatch(event: Event.serverBanRemove, params: [user, server]);
  }
}
