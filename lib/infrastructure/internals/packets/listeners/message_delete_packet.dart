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


final class MessageDeletePacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.messageDelete;

  final LoggerContract logger;
  final MarshallerContract marshaller;

  const MessageDeletePacket(this.logger, this.marshaller);

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

    ServerMessage? message;

    switch (channel) {
      case ServerTextChannel():
        channel.messages.list.removeWhere((id, m) => id == json['id']);
        message = channel.messages.list[json['id']];
      case ServerVoiceChannel():
        channel.messages.list.removeWhere((id, m) => id == json['id']);
        message = channel.messages.list[json['id']];
      case ServerAnnouncementChannel():
        channel.messages.list.removeWhere((id, m) => id == json['id']);
        message = channel.messages.list[json['id']];
    }

    final rawServer = await marshaller.serializers.server.deserialize(server);
    await marshaller.cache.put(server.id, rawServer);

    dispatch(event: Event.serverMessageDelete, params: [message]);
  }

  Future<void> deletePrivateMessage(DispatchEvent dispatch, Map<String, dynamic> json) async {
    final channel = await marshaller.dataStore.channel.getChannel(json['channel_id']);
    PrivateMessage? message;

    if (channel is PrivateChannel) {
      message = channel.messages.list[json['id']];
      channel.messages.list.removeWhere((id, m) => id == json['id']);
    }

    await marshaller.cache.remove(json['id']);

    dispatch(event: Event.serverMessageDelete, params: [message]);
  }
}
