import 'package:mineral/contracts.dart';
import 'package:mineral/src/api/common/channel.dart';
import 'package:mineral/src/api/common/message_type.dart';
import 'package:mineral/src/api/common/types/channel_type.dart';
import 'package:mineral/src/api/private/channels/private_channel.dart';
import 'package:mineral/src/api/server/channels/server_announcement_channel.dart';
import 'package:mineral/src/api/server/channels/server_channel.dart';
import 'package:mineral/src/api/server/channels/server_text_channel.dart';
import 'package:mineral/src/api/server/channels/server_voice_channel.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/services/container/ioc_container.dart';
import 'package:mineral/src/infrastructure/internals/packets/listenable_packet.dart';
import 'package:mineral/src/infrastructure/internals/packets/packet_type.dart';
import 'package:mineral/src/infrastructure/internals/wss/shard_message.dart';

final class MessageCreatePacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.messageCreate;

  MarshallerContract get _marshaller => ioc.resolve<MarshallerContract>();

  DataStoreContract get _dataStore => ioc.resolve<DataStoreContract>();

  @override
  Future<void> listen(ShardMessage message, DispatchEvent dispatch) async {
    if (![MessageType.initial.value, MessageType.reply.value].contains(message.payload['type'])) {
      return;
    }

    final channel = await _dataStore.channel.get(message.payload['channel_id'], false);

    final serverThreadTypes = [
      ChannelType.guildPrivateThread.value,
      ChannelType.guildPublicThread.value
    ];

    if (serverThreadTypes.contains(channel?.type.value)) {
      await sendThread(dispatch, message.payload);
      return;
    }

    return switch (channel) {
      ServerChannel() => sendServerMessage(dispatch, channel, message.payload),
      Channel() => sendPrivateMessage(dispatch, channel, message.payload),
     _ => throw Exception('Unknown channel}'),
    };
  }

  Future<void> sendThread(DispatchEvent dispatch, Map<String, dynamic> json) async {
    throw UnimplementedError();
    // dispatch(event: Event.serverMessageCreate, params: [message]);
  }

  Future<void> sendServerMessage(
      DispatchEvent dispatch, ServerChannel channel, Map<String, dynamic> json) async {
    final server = await _dataStore.server.get(channel.serverId.value, false);

    final payload = await _marshaller.serializers.serverMessage
        .normalize({...json, 'server_id': server.id.value});
    final message = await _marshaller.serializers.serverMessage.serialize(payload);

    message.channel = channel;

    switch (channel) {
      case ServerTextChannel():
        channel.messages.list.putIfAbsent(message.id, () => message);
      case ServerVoiceChannel():
        channel.messages.list.putIfAbsent(message.id, () => message);
      case ServerAnnouncementChannel():
        channel.messages.list.putIfAbsent(message.id, () => message);
    }

    dispatch(event: Event.serverMessageCreate, params: [message]);
  }

  Future<void> sendPrivateMessage(
      DispatchEvent dispatch, Channel channel, Map<String, dynamic> json) async {
    final payload = await _marshaller.serializers.privateMessage.normalize(json);
    final message = await _marshaller.serializers.privateMessage.serialize(payload);

    if (channel is PrivateChannel) {
      message.channel = channel;
      channel.messages.list.putIfAbsent(message.id, () => message);

      dispatch(event: Event.privateMessageCreate, params: [message]);
    }
  }
}
