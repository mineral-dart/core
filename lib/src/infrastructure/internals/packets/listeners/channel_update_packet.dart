import 'package:mineral/container.dart';
import 'package:mineral/src/api/private/channels/private_channel.dart';
import 'package:mineral/src/api/server/channels/server_channel.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/infrastructure/internals/datastore/data_store.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/marshaller.dart';
import 'package:mineral/src/infrastructure/internals/packets/listenable_packet.dart';
import 'package:mineral/src/infrastructure/internals/packets/packet_type.dart';
import 'package:mineral/src/infrastructure/internals/wss/shard_message.dart';
import 'package:mineral/src/infrastructure/services/logger/logger.dart';

final class ChannelUpdatePacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.channelUpdate;

  LoggerContract get _logger => ioc.resolve<LoggerContract>();

  MarshallerContract get _marshaller => ioc.resolve<MarshallerContract>();

  DataStoreContract get _dataStore => ioc.resolve<DataStoreContract>();

  @override
  Future<void> listen(ShardMessage message, DispatchEvent dispatch) async {
    final rawBeforeChannel = await _marshaller.cache.get(message.payload['id']);
    final beforeChannel = rawBeforeChannel != null
        ? await _marshaller.serializers.channels.serialize(rawBeforeChannel)
        : null;

    final rawChannel =
        await _marshaller.serializers.channels.normalize(message.payload);
    final channel =
        await _marshaller.serializers.channels.serialize(rawChannel);

    return switch (channel) {
      ServerChannel() => registerServerChannel(
          channel, beforeChannel as ServerChannel?, dispatch),
      PrivateChannel() => registerPrivateChannel(
          channel, beforeChannel as PrivateChannel?, dispatch),
      _ => _logger
          .warn("Unknown channel type: $channel contact Mineral's core team.")
    };
  }

  Future<void> registerServerChannel(ServerChannel channel,
      ServerChannel? before, DispatchEvent dispatch) async {
    final server = await _dataStore.server.getServer(channel.serverId);

    channel.server = server;
    server.channels.list.update(channel.id, (_) => channel);

    final serverCacheKey = _marshaller.cacheKey.server(server.id);
    final rawServer = await _marshaller.serializers.server.deserialize(server);

    await _marshaller.cache.put(serverCacheKey, rawServer);

    dispatch(event: Event.serverChannelUpdate, params: [before, channel]);
  }

  Future<void> registerPrivateChannel(PrivateChannel channel,
      PrivateChannel? before, DispatchEvent dispatch) async {
    dispatch(event: Event.serverChannelUpdate, params: [before, channel]);
  }
}
