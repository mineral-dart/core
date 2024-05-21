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

final class MessageDeleteBulkPacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.messageDeleteBulk;

  final LoggerContract logger;
  final MarshallerContract marshaller;

  const MessageDeleteBulkPacket(this.logger, this.marshaller);

  @override
  Future<void> listen(ShardMessage message, DispatchEvent dispatch) async {
    return switch (message.payload['guild_id']) {
      String() => deleteServerMessage(dispatch, message.payload),
      _ => deletePrivateMessage(dispatch, message.payload),
    };
  }

  Future<void> deleteServerMessage(DispatchEvent dispatch, Map<String, dynamic> json) async {
    final server = await marshaller.dataStore.server.getServer(json['guild_id']);
    final channel = server.channels.list[json['channel_id']];

    final List<ServerMessage> messages = [];

    for (final key in json['ids']) {
      ServerMessage? message;

      switch (channel) {
        case ServerTextChannel():
          channel.messages.list.removeWhere((id, m) => id == key);
          message = channel.messages.list[key];
        case ServerVoiceChannel():
          channel.messages.list.removeWhere((id, m) => id == key);
          message = channel.messages.list[key];
        case ServerAnnouncementChannel():
          channel.messages.list.removeWhere((id, m) => id == key);
          message = channel.messages.list[key];
      }

      if (message != null) {
        messages.add(message);
      }
    }


    final rawServer = await marshaller.serializers.server.deserialize(server);
    await marshaller.cache.put(server.id, rawServer);

    dispatch(event: Event.serverMessageDeleteBulk, params: [messages, server]);
  }

  Future<void> deletePrivateMessage(DispatchEvent dispatch, Map<String, dynamic> json) async {
    final channel = await marshaller.dataStore.channel.getChannel(json['channel_id']);
    final List<PrivateMessage> messages = [];

    for (final key in json['ids']) {
      PrivateMessage? message;

      if (channel is PrivateChannel) {
          channel.messages.list.removeWhere((id, m) => id == key);
          message = channel.messages.list[key];
          await marshaller.cache.remove(key);
      }

      if (message != null) {
        messages.add(message);
      }
    }

    dispatch(event: Event.serverMessageDeleteBulk, params: [messages, channel]);
  }
}
