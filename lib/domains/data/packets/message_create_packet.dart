import 'package:mineral/api/common/message_type.dart';
import 'package:mineral/api/private/channels/private_channel.dart';
import 'package:mineral/api/private/private_message.dart';
import 'package:mineral/api/server/channels/server_announcement_channel.dart';
import 'package:mineral/api/server/channels/server_channel.dart';
import 'package:mineral/api/server/channels/server_text_channel.dart';
import 'package:mineral/api/server/channels/server_voice_channel.dart';
import 'package:mineral/api/server/server_message.dart';
import 'package:mineral/infrastructure/services/logger/logger.dart';
import 'package:mineral/domains/data/types/listenable_packet.dart';
import 'package:mineral/domains/data/types/packet_type.dart';
import 'package:mineral/infrastructure/internals/marshaller/marshaller.dart';
import 'package:mineral/domains/shared/mineral_event.dart';
import 'package:mineral/infrastructure/internals/wss/shard_message.dart';

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

    if (channel is ServerChannel) {
      message.channel = channel;
    }

    switch (channel) {
      case ServerTextChannel(): channel.messages.list.putIfAbsent(message.id, () => message as ServerMessage);
      case ServerVoiceChannel(): channel.messages.list.putIfAbsent(message.id, () => message as ServerMessage);
      case ServerAnnouncementChannel(): channel.messages.list.putIfAbsent(message.id, () => message as ServerMessage);
    }

    final rawServer = await marshaller.serializers.server.deserialize(server);
    await marshaller.cache.put(server.id, rawServer);

    dispatch(event: MineralEvent.serverMessageCreate, params: [message]);
  }

  Future<void> sendPrivateMessage(DispatchEvent dispatch, Map<String, dynamic> json) async {
    final channel = await marshaller.dataStore.channel.getChannel(json['channel_id']);
    final message = await marshaller.serializers.message.serialize(json);

    if (channel is PrivateChannel) {
      message.channel = channel;
      channel.messages.list.putIfAbsent(message.id, () => message as PrivateMessage);
    }

    final rawChannel = await marshaller.serializers.channels.deserialize(channel);
    await marshaller.cache.put(message.id, rawChannel);

    dispatch(event: MineralEvent.privateMessageCreate, params: [message]);
  }
}
