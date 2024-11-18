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

final class ChannelPinsUpdatePacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.channelPinsUpdate;

  LoggerContract get _logger => ioc.resolve<LoggerContract>();

  MarshallerContract get _marshaller => ioc.resolve<MarshallerContract>();

  DataStoreContract get _dataStore => ioc.resolve<DataStoreContract>();

  @override
  Future<void> listen(ShardMessage message, DispatchEvent dispatch) async {
    final rawChannel = await _marshaller.serializers.channels.normalize(message.payload);
    final channel = await _marshaller.serializers.channels.serialize(rawChannel);

    return switch (channel) {
      ServerChannel() => registerServerChannelPins(channel, dispatch),
      PrivateChannel() => registerPrivateChannelPins(channel, dispatch),
      _ => _logger.warn("Unknown channel type: $channel contact Mineral's core team.")
    };
  }

  Future<void> registerServerChannelPins(ServerChannel channel, DispatchEvent dispatch) async {
    final server = await _dataStore.server.getServer(channel.serverId);

    server.channels.list.update(channel.id, (_) => channel);

    final rawServer = await _marshaller.serializers.server.deserialize(server);
    final cacheKey = _marshaller.cacheKey.server(server.id);

    await _marshaller.cache.put(cacheKey, rawServer);

    dispatch(event: Event.serverChannelPinsUpdate, params: [server, channel]);
  }

  Future<void> registerPrivateChannelPins(PrivateChannel channel, DispatchEvent dispatch) async {
    dispatch(event: Event.privateChannelPinsUpdate, params: [channel]);
  }
}
