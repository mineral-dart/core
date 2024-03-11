import 'package:mineral/api/server/channels/server_channel.dart';
import 'package:mineral/application/logger/logger.dart';
import 'package:mineral/domains/data/types/listenable_packet.dart';
import 'package:mineral/domains/data/types/packet_type.dart';
import 'package:mineral/domains/marshaller/marshaller.dart';
import 'package:mineral/domains/shared/helper.dart';
import 'package:mineral/domains/shared/mineral_event.dart';
import 'package:mineral/domains/wss/shard_message.dart';

final class ChannelPinsUpdatePacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.channelPinsUpdate;

  final LoggerContract logger;
  final MarshallerContract marshaller;

  const ChannelPinsUpdatePacket(this.logger, this.marshaller);

  @override
  void listen(ShardMessage message, DispatchEvent dispatch) {
    switch (message.payload['guild_id']) {
      case String():
        registerServerChannelPins(message, dispatch);
    }
  }

  Future<void> registerServerChannelPins(ShardMessage message, DispatchEvent dispatch) async {
    final rawServer = await marshaller.cache.get(message.payload['guild_id']);
    final server = await marshaller.serializers.server.serialize(rawServer);

    final channel = await marshaller.serializers.channels.serialize(message.payload);
    final timestamps = Helper.createOrNull(
        field: message.payload['last_pin_timestamp'],
        fn: () => DateTime.tryParse(message.payload['last_pin_timestamp']));

    if (![server, channel].contains(null)) {
      marshaller.cache.put(channel!.id, channel);
      server.channels.list[channel.id] = channel as ServerChannel;
    }

    // TODO: Add deserialize server then put in cache
    dispatch(event: MineralEvent.serverChannelPinsUpdate, params: [server, channel, timestamps]);
  }
}
