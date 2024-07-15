import 'package:mineral/api/private/channels/private_channel.dart';
import 'package:mineral/api/server/channels/server_channel.dart';
import 'package:mineral/infrastructure/services/logger/logger.dart';
import 'package:mineral/infrastructure/internals/packets/listenable_packet.dart';
import 'package:mineral/infrastructure/internals/packets/packet_type.dart';
import 'package:mineral/infrastructure/internals/marshaller/marshaller.dart';
import 'package:mineral/domains/events/event.dart';
import 'package:mineral/infrastructure/internals/wss/shard_message.dart';

final class ChannelPinsUpdatePacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.channelPinsUpdate;

  final LoggerContract logger;
  final MarshallerContract marshaller;

  const ChannelPinsUpdatePacket(this.logger, this.marshaller);

  @override
  Future<void> listen(ShardMessage message, DispatchEvent dispatch) async {
    final channel = await marshaller.serializers.channels.serializeRemote(message.payload);

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
    await marshaller.cache.put(server.id.value, rawServer);

    dispatch(event: Event.serverChannelPinsUpdate, params: [server, channel]);
  }

  Future<void> registerPrivateChannelPins(PrivateChannel channel, DispatchEvent dispatch) async {
    final rawChannel = await marshaller.serializers.channels.deserialize(channel);
    await marshaller.cache.put(channel.id.value, rawChannel);

    dispatch(event: Event.privateChannelPinsUpdate, params: [channel]);
  }
}
