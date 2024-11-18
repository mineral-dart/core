import 'package:mineral/container.dart';
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

  LoggerContract get _logger => ioc.resolve<LoggerContract>();
  MarshallerContract get _marshaller => ioc.resolve<MarshallerContract>();

  @override
  Future<void> listen(ShardMessage message, DispatchEvent dispatch) async {
    final rawChannel =
        await _marshaller.serializers.channels.normalize(message.payload);
    final channel = await _marshaller.serializers.channels.serialize(rawChannel);

    switch (channel) {
      case ServerChannel():
        await registerServerChannel(channel, dispatch);
    }
  }

  Future<void> registerServerChannel(
      ServerChannel channel, DispatchEvent dispatch) async {
    final server =
        await _marshaller.dataStore.server.getServer(channel.serverId);
    final serverCacheKey = _marshaller.cacheKey.server(server.id);
    final channelCacheKey = _marshaller.cacheKey.channel(channel.id);

    channel.server = server;
    server.channels.list.remove(channel.id);

    final rawServer = await _marshaller.serializers.server.deserialize(server);

    await _marshaller.cache.put(serverCacheKey, rawServer);
    await _marshaller.cache.remove(channelCacheKey);

    dispatch(event: Event.serverChannelDelete, params: [channel]);
  }
}
