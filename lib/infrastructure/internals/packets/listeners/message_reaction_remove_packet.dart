import 'package:collection/collection.dart';
import 'package:mineral/api/common/message_type.dart';
import 'package:mineral/api/common/reaction_emoji.dart';
import 'package:mineral/api/private/channels/private_channel.dart';
import 'package:mineral/api/private/private_message.dart';
import 'package:mineral/api/private/user.dart';
import 'package:mineral/api/server/channels/server_channel.dart';
import 'package:mineral/api/server/server_message.dart';
import 'package:mineral/application/logger/logger.dart';
import 'package:mineral/domains/data/types/listenable_packet.dart';
import 'package:mineral/domains/data/types/packet_type.dart';
import 'package:mineral/domains/marshaller/marshaller.dart';
import 'package:mineral/domains/shared/mineral_event.dart';
import 'package:mineral/domains/wss/shard_message.dart';

final class MessageReactionRemovePacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.messageReactionRemove;

  final LoggerContract logger;
  final MarshallerContract marshaller;

  const MessageReactionRemovePacket(this.logger, this.marshaller);

  @override
  Future<void> listen(ShardMessage message, DispatchEvent dispatch) async {
    if (![MessageType.initial.value, MessageType.reply.value].contains(message.payload['type'])) {
      return;
    }

    return switch (message.payload['guild_id']) {
      String() => sendServerReactionMessage(dispatch, message.payload),
      _ => sendPrivateReactionMessage(dispatch, message.payload),
    };
  }

  Future<void> sendPrivateReactionMessage(DispatchEvent dispatch, Map<String, dynamic> json) async {
    final message = await marshaller.dataStore.message.getMessage(json['message_id'], json['channel_id']) as PrivateMessage;
    final user = await marshaller.dataStore.user.getUser(json['user_id']);

    ReactionEmoji<PrivateChannel>? reaction = message.reactions.firstWhereOrNull((element) => element.emoji.id == json['emoji']['id'] && element.emoji.name == json['emoji']['name']);

    if (reaction == null) {
      final emoji = await marshaller.serializers.emojis.serialize({
        ...json['emoji'],
        'guildRoles': Iterable.empty(),
        'roles': Iterable.empty(),
      });
      reaction = ReactionEmoji<PrivateChannel>(emoji: emoji, users: <User>[], channel: message.channel);
    }

    if (reaction.users.contains(user)) {
      reaction.users.remove(user);
    }
    if (reaction.users.isEmpty) {
      message.reactions.remove(reaction);
    }

    final messageRaw = await marshaller.serializers.message.deserialize(message);
    await marshaller.dataStore.marshaller.cache.put(message.id, messageRaw);

    dispatch(event: MineralEvent.privateMessageReactionRemove, params: [message, reaction, message.channel, user]);
  }

  Future<void> sendServerReactionMessage(DispatchEvent dispatch, Map<String, dynamic> json) async {
    final message = await marshaller.dataStore.message.getMessage(json['message_id'], json['channel_id'], serverId: json['guild_id']) as ServerMessage;
    final member = await marshaller.dataStore.member.getMemberOrNull(guildId: json['guild_id'], memberId: json['user_id']);
    final server = await marshaller.dataStore.server.getServer(json['guild_id']);
    final user = await marshaller.dataStore.user.getUser(json['user_id']);
    ReactionEmoji<ServerChannel>? reaction = message.reactions.firstWhereOrNull((element) => element.emoji.id == json['emoji']['id'] && element.emoji.name == json['emoji']['name']);

    if (reaction == null) {
      final emoji = await marshaller.serializers.emojis.serialize({
        ...json['emoji'],
        'guildRoles': Iterable.empty(),
        'roles': Iterable.empty(),
      });
      reaction = ReactionEmoji<ServerChannel>(emoji: emoji, users: <User>[], channel: message.channel);
    }
    if (reaction.users.contains(user)) {
      reaction.users.remove(user);
    }
    if (reaction.users.isEmpty) {
      message.reactions.remove(reaction);
    }

    final messageRaw = await marshaller.serializers.message.deserialize(message);
    await marshaller.dataStore.marshaller.cache.put(message.id, messageRaw);

    dispatch(event: MineralEvent.serverMessageReactionRemove, params: [message, reaction, server, member]);
  }
}
