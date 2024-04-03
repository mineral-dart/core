import 'package:mineral/api/private/channels/private_channel.dart';
import 'package:mineral/api/server/channels/server_channel.dart';
import 'package:mineral/application/logger/logger.dart';
import 'package:mineral/domains/data/types/listenable_packet.dart';
import 'package:mineral/domains/data/types/packet_type.dart';
import 'package:mineral/domains/marshaller/marshaller.dart';
import 'package:mineral/domains/shared/mineral_event.dart';
import 'package:mineral/domains/wss/shard_message.dart';

final class ChannelPinsUpdatePacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.channelPinsUpdate;

  final LoggerContract logger;
  final MarshallerContract marshaller;

  const ChannelPinsUpdatePacket(this.logger, this.marshaller);

  @override
  Future<void> listen(ShardMessage message, DispatchEvent dispatch) async {
    final channel = await marshaller.serializers.channels.serialize(message.payload);

    return switch (channel) {
      ServerChannel() => registerServerChannelPins(channel, dispatch),
      PrivateChannel() => registerPrivateChannelPins(channel, dispatch),
      _ => logger.warn("Unknown channel type: $channel contact Mineral's core team.")
    };
  }

  Future<void> registerServerChannelPins(ServerChannel channel, DispatchEvent dispatch) async {
    final server = await marshaller.dataStore.server.getServer(channel.guildId);
    server.channels.list.update(channel.id, (_) => channel);

    final rawServer = await marshaller.serializers.server.deserialize(server);
    await marshaller.cache.put(server.id, rawServer);

    dispatch(event: MineralEvent.serverChannelPinsUpdate, params: [server, channel]);
  }

  Future<void> registerPrivateChannelPins(PrivateChannel channel, DispatchEvent dispatch) async {
    final rawChannel = await marshaller.serializers.channels.deserialize(channel);
    await marshaller.cache.put(channel.id, rawChannel);

    dispatch(event: MineralEvent.privateChannelPinsUpdate, params: [channel]);
  }
}
