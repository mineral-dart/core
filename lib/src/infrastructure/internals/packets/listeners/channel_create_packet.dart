import 'package:mineral/contracts.dart';
import 'package:mineral/src/api/private/channels/private_channel.dart';
import 'package:mineral/src/api/server/channels/server_channel.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/services/container/ioc_container.dart';
import 'package:mineral/src/infrastructure/internals/packets/listenable_packet.dart';
import 'package:mineral/src/infrastructure/internals/packets/packet_type.dart';
import 'package:mineral/src/infrastructure/internals/wss/shard_message.dart';

final class ChannelCreatePacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.channelCreate;

  LoggerContract get _logger => ioc.resolve<LoggerContract>();

  MarshallerContract get _marshaller => ioc.resolve<MarshallerContract>();

  DataStoreContract get _dataStore => ioc.resolve<DataStoreContract>();

  @override
  Future<void> listen(ShardMessage message, DispatchEvent dispatch) async {
    final rawChannel =
        await _marshaller.serializers.channels.normalize(message.payload);
    final channel =
        await _marshaller.serializers.channels.serialize(rawChannel);

    return switch (channel) {
      ServerChannel() => registerServerChannel(channel, dispatch),
      PrivateChannel() => registerPrivateChannel(channel, dispatch),
      _ => _logger
          .warn("Unknown channel type: $channel contact Mineral's core team.")
    };
  }

  Future<void> registerServerChannel(
      ServerChannel channel, DispatchEvent dispatch) async {
    final server = await _dataStore.server.get(channel.serverId.value, false);
    final serverCacheKey = _marshaller.cacheKey.server(server.id.value);

    final rawServer = await _marshaller.serializers.server.deserialize(server);
    await _marshaller.cache.put(serverCacheKey, rawServer);

    dispatch(event: Event.serverChannelCreate, params: [channel]);
  }

  Future<void> registerPrivateChannel(
      PrivateChannel channel, DispatchEvent dispatch) async {
    dispatch(event: Event.privateChannelCreate, params: [channel]);
  }
}
