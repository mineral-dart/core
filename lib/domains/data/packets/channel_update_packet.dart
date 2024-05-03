import 'package:mineral/api/private/channels/private_channel.dart';
import 'package:mineral/api/server/channels/server_channel.dart';
import 'package:mineral/infrastructure/logger/logger.dart';
import 'package:mineral/domains/data/types/listenable_packet.dart';
import 'package:mineral/domains/data/types/packet_type.dart';
import 'package:mineral/infrastructure/marshaller/marshaller.dart';
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

    return switch (channel) {
      ServerChannel() => registerServerChannel(channel, dispatch),
      PrivateChannel() => registerPrivateChannel(channel, dispatch),
      _ => logger.warn("Unknown channel type: $channel contact Mineral's core team.")
    };
  }

  Future<void> registerServerChannel(ServerChannel channel, DispatchEvent dispatch) async {
    final server = await marshaller.dataStore.server.getServer(channel.guildId);
    final before = server.channels.list[channel.id];

    channel.server = server;
    server.channels.list.update(channel.id, (_) => channel);

    final rawServer = await marshaller.serializers.server.deserialize(server);
    await marshaller.cache.put(server.id, rawServer);

    dispatch(event: MineralEvent.serverChannelUpdate, params: [before, channel]);
  }

  Future<void> registerPrivateChannel(PrivateChannel channel, DispatchEvent dispatch) async {
    final before = marshaller.dataStore.channel.getChannel(channel.id);

    final rawChannel = await marshaller.serializers.channels.deserialize(channel);
    await marshaller.cache.put(channel.id, rawChannel);

    dispatch(event: MineralEvent.serverChannelUpdate, params: [before, channel]);
  }
}
