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

  @override
  Future<void> listen(ShardMessage message, DispatchEvent dispatch) async {
    final rawChannel =
        await _marshaller.serializers.channels.normalize(message.payload);
    final channel =
        await _marshaller.serializers.channels.serialize(rawChannel);

    return switch (channel) {
      ServerChannel() => dispatch(event: Event.serverChannelCreate, params: [channel]),
      PrivateChannel() => dispatch(event: Event.serverChannelCreate, params: [channel]),
      _ => _logger.warn("Unknown channel type: $channel contact Mineral's core team.")
    };
  }
}
