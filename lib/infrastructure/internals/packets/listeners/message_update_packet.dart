import 'package:mineral/api/common/message_type.dart';
import 'package:mineral/api/private/channels/private_channel.dart';
import 'package:mineral/api/private/private_message.dart';
import 'package:mineral/api/server/channels/server_announcement_channel.dart';
import 'package:mineral/api/server/channels/server_channel.dart';
import 'package:mineral/api/server/channels/server_text_channel.dart';
import 'package:mineral/api/server/channels/server_voice_channel.dart';
import 'package:mineral/api/server/server_message.dart';
import 'package:mineral/domains/events/event.dart';
import 'package:mineral/infrastructure/internals/marshaller/marshaller.dart';
import 'package:mineral/infrastructure/internals/packets/listenable_packet.dart';
import 'package:mineral/infrastructure/internals/packets/packet_type.dart';
import 'package:mineral/infrastructure/internals/wss/shard_message.dart';
import 'package:mineral/infrastructure/services/logger/logger.dart';

final class MessageUpdatePacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.messageUpdate;

  final LoggerContract logger;
  final MarshallerContract marshaller;

  const MessageUpdatePacket(this.logger, this.marshaller);

  @override
  Future<void> listen(ShardMessage message, DispatchEvent dispatch) async {
    if (![MessageType.initial.value, MessageType.reply.value].contains(message.payload['type'])) {
      return;
    }

    return switch (message.payload['guild_id']) {
      String() => updateServerMessage(dispatch, message.payload),
      _ => updatePrivateMessage(dispatch, message.payload),
    };
  }

  Future<void> updateServerMessage(DispatchEvent dispatch, Map<String, dynamic> json) async {
    final server = await marshaller.dataStore.server.getServer(json['guild_id']);
    final channel = server.channels.list[json['channel_id']];

    final message = await marshaller.serializers.message.serialize(json);

    if (channel is ServerChannel) {
      message.channel = channel;
    }

    ServerMessage? oldMessage;

    switch (channel) {
      case ServerTextChannel():
        channel.messages.list.update(message.id, (m) => m = message as ServerMessage, ifAbsent: () => message as ServerMessage);
        oldMessage = channel.messages.list[message.id];
      case ServerVoiceChannel():
        channel.messages.list.update(message.id, (m) => m = message as ServerMessage, ifAbsent: () => message as ServerMessage);
        oldMessage = channel.messages.list[message.id];
      case ServerAnnouncementChannel():
        channel.messages.list.update(message.id, (m) => m = message as ServerMessage, ifAbsent: () => message as ServerMessage);
        oldMessage = channel.messages.list[message.id];
    }

    final rawServer = await marshaller.serializers.server.deserialize(server);
    await marshaller.cache.put(server.id, rawServer);
    final rawMessage = await marshaller.serializers.message.deserialize(message);
    await marshaller.cache.put(message.id, rawMessage);


    dispatch(event: Event.serverMessageUpdate, params: [oldMessage, message]);
  }

  Future<void> updatePrivateMessage(DispatchEvent dispatch, Map<String, dynamic> json) async {
    final channel = await marshaller.dataStore.channel.getChannel(json['channel_id']);
    final message = await marshaller.serializers.message.serialize(json);
    PrivateMessage? oldMessage;

    if (channel is PrivateChannel) {
      message.channel = channel;
      channel.messages.list.update(message.id, (m) => m = message as PrivateMessage, ifAbsent: () => message as PrivateMessage);
      oldMessage = channel.messages.list[message.id];
    }

    final rawChannel = await marshaller.serializers.channels.deserialize(channel);
    await marshaller.cache.put(message.id, rawChannel);

    dispatch(event: Event.privateMessageUpdate, params: [oldMessage, message]);
  }
}
