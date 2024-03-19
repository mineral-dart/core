import 'package:mineral/api/private/channels/private_channel.dart';
import 'package:mineral/api/server/channels/server_channel.dart';
import 'package:mineral/application/logger/logger.dart';
import 'package:mineral/domains/data/types/listenable_packet.dart';
import 'package:mineral/domains/data/types/packet_type.dart';
import 'package:mineral/domains/marshaller/marshaller.dart';
import 'package:mineral/domains/shared/mineral_event.dart';
import 'package:mineral/domains/wss/shard_message.dart';

final class ChannelCreatePacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.channelCreate;

  final LoggerContract logger;
  final MarshallerContract marshaller;

  const ChannelCreatePacket(this.logger, this.marshaller);

  @override
  Future<void> listen(ShardMessage message, DispatchEvent dispatch) async {
    final channel = await marshaller.serializers.channels.serialize(message.payload);

    switch (channel) {
      case ServerChannel():
        registerServerChannel(message, channel, dispatch);
      case PrivateChannel():
        await marshaller.cache.put(channel.id, channel);
        dispatch(event: MineralEvent.privateChannelCreate, params: [channel]);
      default:
        logger.warn("Unknown channel type: $channel contact Mineral's core team.");
    }
  }

  Future<void> registerServerChannel(ShardMessage message, ServerChannel channel, DispatchEvent dispatch) async {
    final rawServer = await marshaller.cache.get(message.payload['guild_id']);

    if (rawServer != null) {
      final server = await marshaller.serializers.server.serialize(rawServer);

      channel.server = server;
      server.channels.list.putIfAbsent(channel.id, () => channel);
    }

    print(message.payload);
    await marshaller.cache.put(channel.id, message.payload);

    dispatch(event: MineralEvent.serverChannelCreate, params: [channel]);
  }
}
