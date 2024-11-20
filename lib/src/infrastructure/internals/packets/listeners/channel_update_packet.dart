import 'package:mineral/src/api/private/channels/private_channel.dart';
import 'package:mineral/src/api/server/channels/server_channel.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/marshaller.dart';
import 'package:mineral/src/infrastructure/internals/packets/listenable_packet.dart';
import 'package:mineral/src/infrastructure/internals/packets/packet_type.dart';
import 'package:mineral/src/infrastructure/internals/wss/shard_message.dart';
import 'package:mineral/src/infrastructure/services/logger/logger.dart';

final class ChannelUpdatePacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.channelUpdate;

  final LoggerContract logger;
  final MarshallerContract marshaller;

  const ChannelUpdatePacket(this.logger, this.marshaller);

  @override
  Future<void> listen(ShardMessage message, DispatchEvent dispatch) async {
    final rawBeforeChannel = await marshaller.cache.get(message.payload['id']);
    final beforeChannel = rawBeforeChannel != null
        ? await marshaller.serializers.channels.serialize(rawBeforeChannel)
        : null;

    final rawChannel =
        await marshaller.serializers.channels.normalize({
          'server_id': message.payload['guild_id'],
          ...message.payload
        });
    final channel = await marshaller.serializers.channels.serialize(rawChannel);

    return switch (channel) {
      ServerChannel() => registerServerChannel(
          channel, beforeChannel as ServerChannel?, dispatch),
      PrivateChannel() => registerPrivateChannel(
          channel, beforeChannel as PrivateChannel?, dispatch),
      _ => logger
          .warn("Unknown channel type: $channel contact Mineral's core team.")
    };
  }

  Future<void> registerServerChannel(ServerChannel channel,
      ServerChannel? before, DispatchEvent dispatch) async {
    final server =
        await marshaller.dataStore.server.getServer(channel.serverId);

    channel.server = server;
    server.channels.list.update(channel.id, (_) => channel);

    final serverCacheKey = marshaller.cacheKey.server(server.id);
    final rawServer = await marshaller.serializers.server.deserialize(server);

    await marshaller.cache.put(serverCacheKey, rawServer);

    dispatch(event: Event.serverChannelUpdate, params: [before, channel]);
  }

  Future<void> registerPrivateChannel(PrivateChannel channel,
      PrivateChannel? before, DispatchEvent dispatch) async {
    dispatch(event: Event.serverChannelUpdate, params: [before, channel]);
  }
}
