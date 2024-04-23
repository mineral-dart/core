import 'package:mineral/api/common/message_type.dart';
import 'package:mineral/api/private/channels/private_channel.dart';
import 'package:mineral/api/private/private_message.dart';
import 'package:mineral/api/server/channels/server_announcement_channel.dart';
import 'package:mineral/api/server/channels/server_text_channel.dart';
import 'package:mineral/api/server/channels/server_voice_channel.dart';
import 'package:mineral/api/server/server_message.dart';
import 'package:mineral/domains/events/event.dart';
import 'package:mineral/infrastructure/internals/marshaller/marshaller.dart';
import 'package:mineral/infrastructure/internals/packets/listenable_packet.dart';
import 'package:mineral/infrastructure/internals/packets/packet_type.dart';
import 'package:mineral/infrastructure/internals/wss/shard_message.dart';
import 'package:mineral/infrastructure/services/logger/logger.dart';

final class MessageCreatePacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.messageCreate;

  final LoggerContract logger;
  final MarshallerContract marshaller;

  const MessageCreatePacket(this.logger, this.marshaller);

  @override
  Future<void> listen(ShardMessage message, DispatchEvent dispatch) async {
    if (![MessageType.initial.value, MessageType.reply.value].contains(message.payload['type'])) {
      return;
    }

    return switch (message.payload['guild_id']) {
      String() => sendServerMessage(dispatch, message.payload),
      _ => sendPrivateMessage(dispatch, message.payload),
    };
  }

  Future<void> sendServerMessage(DispatchEvent dispatch, Map<String, dynamic> json) async {
    final server = await marshaller.dataStore.server.getServer(json['guild_id']);
    final channel = server.channels.list[json['channel_id']];
    final message = await marshaller.serializers.message.serialize(json);
    final rawMessage = await marshaller.serializers.message.deserialize(message);

    switch (channel) {
      case ServerTextChannel(): channel.messages.list.putIfAbsent(message.id, () => message as ServerMessage);
      case ServerVoiceChannel(): channel.messages.list.putIfAbsent(message.id, () => message as ServerMessage);
      case ServerAnnouncementChannel(): channel.messages.list.putIfAbsent(message.id, () => message as ServerMessage);
    }

    final rawServer = await marshaller.serializers.server.deserialize(server);
    await marshaller.cache.put(server.id, rawServer);
    await marshaller.cache.put(message.id, rawMessage);

    dispatch(event: Event.serverMessageCreate, params: [message]);
  }

  Future<void> sendPrivateMessage(DispatchEvent dispatch, Map<String, dynamic> json) async {
    final channel = await marshaller.dataStore.channel.getChannel(json['channel_id']);
    final message = await marshaller.serializers.message.serialize(json);

    if (channel is PrivateChannel) {
      channel.messages.list.putIfAbsent(message.id, () => message as PrivateMessage);
    }

    final rawMessage = await marshaller.serializers.message.deserialize(message);
    final rawChannel = await marshaller.serializers.channels.deserialize(channel);
    await marshaller.cache.put(channel?.id, rawChannel);
    await marshaller.cache.put(message.id, rawMessage);

    dispatch(event: Event.privateMessageCreate, params: [message]);
  }
}
