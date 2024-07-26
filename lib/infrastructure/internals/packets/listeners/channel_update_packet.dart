import 'package:mineral/api/private/channels/private_channel.dart';
import 'package:mineral/api/server/channels/server_channel.dart';
import 'package:mineral/infrastructure/services/logger/logger.dart';
import 'package:mineral/infrastructure/internals/packets/listenable_packet.dart';
import 'package:mineral/infrastructure/internals/packets/packet_type.dart';
import 'package:mineral/infrastructure/internals/marshaller/marshaller.dart';
import 'package:mineral/domains/events/event.dart';
import 'package:mineral/infrastructure/internals/wss/shard_message.dart';

final class ChannelUpdatePacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.channelUpdate;

  final LoggerContract logger;
  final MarshallerContract marshaller;

  const ChannelUpdatePacket(this.logger, this.marshaller);

  @override
  Future<void> listen(ShardMessage message, DispatchEvent dispatch) async {
    final channel = await marshaller.serializers.channels.serializeRemote(message.payload);

    return switch (channel) {
      ServerChannel() => registerServerChannel(channel, dispatch),
      PrivateChannel() => registerPrivateChannel(channel, dispatch),
      _ => logger.warn("Unknown channel type: $channel contact Mineral's core team.")
    };
  }

  Future<void> registerServerChannel(ServerChannel channel, DispatchEvent dispatch) async {
    final server = await marshaller.dataStore.server.getServer(channel.guildId);
    final serverCacheKey = marshaller.cacheKey.server(server.id);
    final channelCacheKey =
        marshaller.cacheKey.serverChannel(serverId: server.id, channelId: channel.id);

    final before = server.channels.list[channel.id];

    channel.server = server;
    server.channels.list.update(channel.id, (_) => channel);

    final rawServer = await marshaller.serializers.server.deserialize(server);
    final rawChannel = await marshaller.serializers.channels.deserialize(channel);
    await Future.wait([
      marshaller.cache.put(serverCacheKey, rawServer),
      marshaller.cache.put(channelCacheKey, rawChannel)
    ]);

    dispatch(event: Event.serverChannelUpdate, params: [before, channel]);
  }

  Future<void> registerPrivateChannel(PrivateChannel channel, DispatchEvent dispatch) async {
    final cacheKey = marshaller.cacheKey.privateChannel(channel.id);
    final before = marshaller.dataStore.channel.getChannel(channel.id);

    final rawChannel = await marshaller.serializers.channels.deserialize(channel);
    await marshaller.cache.put(cacheKey, rawChannel);

    dispatch(event: Event.serverChannelUpdate, params: [before, channel]);
  }
}
