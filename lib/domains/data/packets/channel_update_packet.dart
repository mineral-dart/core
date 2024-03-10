import 'package:mineral/api/private/channels/private_channel.dart';
import 'package:mineral/api/server/channels/server_channel.dart';
import 'package:mineral/application/logger/logger.dart';
import 'package:mineral/domains/data/types/listenable_packet.dart';
import 'package:mineral/domains/data/types/packet_type.dart';
import 'package:mineral/domains/marshaller/marshaller.dart';
import 'package:mineral/domains/shared/mineral_event.dart';
import 'package:mineral/domains/wss/shard_message.dart';

final class ChannelUpdatePacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.channelUpdate;

  final LoggerContract logger;
  final MarshallerContract marshaller;

  const ChannelUpdatePacket(this.logger, this.marshaller);

  @override
  Future<void> listen(ShardMessage message, DispatchEvent dispatch) async {
    final channel = await marshaller.serializers.channels.serialize(message.payload);

    switch (channel) {
      case ServerChannel():
        registerServerChannel(message, channel, dispatch);
      case PrivateChannel():
        await marshaller.cache.put(channel.id, message.payload);
        dispatch(event: MineralEvent.privateChannelUpdate, params: [channel]);
      default:
        logger.warn("Unknown channel type: $channel contact Mineral's core team.");
    }
  }

  Future<void> registerServerChannel(ShardMessage message, ServerChannel after, DispatchEvent dispatch) async {
    final rawServer = await marshaller.cache.get(message.payload['guild_id']);
    final before = await marshaller.cache.get(after.id);

    if (rawServer != null) {
      final server = await marshaller.serializers.server.serialize(rawServer);

      after.server = server;
      server.channels.list[after.id] = after;
    }

    dispatch(event: MineralEvent.serverChannelUpdate, params: [before, after]);

    marshaller.cache.put(after.id, message.payload);
  }
}
