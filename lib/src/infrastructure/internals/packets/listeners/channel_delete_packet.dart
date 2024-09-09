import 'package:mineral/src/api/server/channels/server_channel.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/marshaller.dart';
import 'package:mineral/src/infrastructure/internals/packets/listenable_packet.dart';
import 'package:mineral/src/infrastructure/internals/packets/packet_type.dart';
import 'package:mineral/src/infrastructure/internals/wss/shard_message.dart';
import 'package:mineral/src/infrastructure/services/logger/logger.dart';

final class ChannelDeletePacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.channelDelete;

  final LoggerContract logger;
  final MarshallerContract marshaller;

  const ChannelDeletePacket(this.logger, this.marshaller);

  @override
  Future<void> listen(ShardMessage message, DispatchEvent dispatch) async {
    final rawChannel =
        await marshaller.serializers.channels.normalize(message.payload);
    final channel = await marshaller.serializers.channels.serialize(rawChannel);

    switch (channel) {
      case ServerChannel():
        await registerServerChannel(channel, dispatch);
    }
  }

  Future<void> registerServerChannel(
      ServerChannel channel, DispatchEvent dispatch) async {
    final server =
        await marshaller.dataStore.server.getServer(channel.serverId);
    final serverCacheKey = marshaller.cacheKey.server(server.id);
    final channelCacheKey = marshaller.cacheKey.channel(channel.id);

    channel.server = server;
    server.channels.list.remove(channel.id);

    final rawServer = await marshaller.serializers.server.deserialize(server);

    await marshaller.cache.put(serverCacheKey, rawServer);
    await marshaller.cache.remove(channelCacheKey);

    dispatch(event: Event.serverChannelDelete, params: [channel]);
  }
}
