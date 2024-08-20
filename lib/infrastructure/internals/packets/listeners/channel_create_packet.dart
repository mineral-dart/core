import 'package:mineral/api/private/channels/private_channel.dart';
import 'package:mineral/api/server/channels/server_channel.dart';
import 'package:mineral/domains/events/event.dart';
import 'package:mineral/infrastructure/internals/marshaller/marshaller.dart';
import 'package:mineral/infrastructure/internals/packets/listenable_packet.dart';
import 'package:mineral/infrastructure/internals/packets/packet_type.dart';
import 'package:mineral/infrastructure/internals/wss/shard_message.dart';
import 'package:mineral/infrastructure/services/logger/logger.dart';

final class ChannelCreatePacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.channelCreate;

  final LoggerContract logger;
  final MarshallerContract marshaller;

  const ChannelCreatePacket(this.logger, this.marshaller);

  @override
  Future<void> listen(ShardMessage message, DispatchEvent dispatch) async {
    final rawChannel = await marshaller.serializers.channels.normalize(message.payload);
    final channel = await marshaller.serializers.channels.serialize(rawChannel);

    return switch (channel) {
      ServerChannel() => registerServerChannel(channel, dispatch),
      PrivateChannel() => registerPrivateChannel(channel, dispatch),
      _ => logger.warn("Unknown channel type: $channel contact Mineral's core team.")
    };
  }

  Future<void> registerServerChannel(ServerChannel channel, DispatchEvent dispatch) async {
    final server = await marshaller.dataStore.server.getServer(channel.serverId);
    final serverCacheKey = marshaller.cacheKey.server(server.id);

    channel.server = server;
    server.channels.list.putIfAbsent(channel.id, () => channel);

    final rawServer = await marshaller.serializers.server.deserialize(server);
    await marshaller.cache.put(serverCacheKey, rawServer);

    dispatch(event: Event.serverChannelCreate, params: [channel]);
  }

  Future<void> registerPrivateChannel(PrivateChannel channel, DispatchEvent dispatch) async {
    dispatch(event: Event.privateChannelCreate, params: [channel]);
  }
}
