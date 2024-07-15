import 'package:mineral/api/private/channels/private_channel.dart';
import 'package:mineral/api/server/channels/server_text_channel.dart';
import 'package:mineral/api/server/server_message.dart';
import 'package:mineral/domains/events/event.dart';
import 'package:mineral/infrastructure/internals/marshaller/marshaller.dart';
import 'package:mineral/infrastructure/internals/packets/listenable_packet.dart';
import 'package:mineral/infrastructure/internals/packets/packet_type.dart';
import 'package:mineral/infrastructure/internals/wss/shard_message.dart';
import 'package:mineral/infrastructure/services/logger/logger.dart';

final class MessagePinUpdatePacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.messageUpdate;

  final LoggerContract logger;
  final MarshallerContract marshaller;

  const MessagePinUpdatePacket(this.logger, this.marshaller);

  @override
  Future<void> listen(ShardMessage message, DispatchEvent dispatch) async {
    final server = await marshaller.dataStore.server.getServer(message.payload['guild_id']);
    final channel = server.channels.list[message.payload['channel_id']];

    return switch (message.payload['guild_id']) {
      String() => registerServerMessagePin(message.payload, dispatch),
      PrivateChannel() => registerPrivateMessagePin(message.payload, dispatch),
      _ => logger.warn("Unknown channel type: $channel contact Mineral's core team.")
    };
  }

  Future<void> registerServerMessagePin(Map<String, dynamic> payload, DispatchEvent dispatch) async {
    final server = await marshaller.dataStore.server.getServer(payload['guild_id']);
    final channel = server.channels.list[payload['channel_id']];

    if (channel case ServerTextChannel(:final messages)) {
      final message = messages.list[payload['id']];

      if (message is ServerMessage) {
        final newMessage = await ServerMessage.copyWith(message, isPinned: payload['pinned']);
        channel.messages.list.update(newMessage.id, (_) => newMessage);

        final rawServer = await marshaller.serializers.server.deserialize(server);
        await marshaller.cache.put(server.id, rawServer);

        dispatch(event: Event.serverMessagePinUpdate, params: [server, channel]);
      }
    }
  }

  Future<void> registerPrivateMessagePin(Map<String, dynamic> payload, DispatchEvent dispatch) async {
    final message = await marshaller.serializers.message.serialize(payload['id']);
    await marshaller.cache.put(message.id, message);

    dispatch(event: Event.privateMessagePinUpdate, params: [message]);
  }
}
