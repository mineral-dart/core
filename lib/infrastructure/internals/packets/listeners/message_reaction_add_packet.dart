import 'package:collection/collection.dart';
import 'package:mineral/api/common/reaction_properties.dart';
import 'package:mineral/api/private/channels/private_channel.dart';
import 'package:mineral/api/private/private_message.dart';
import 'package:mineral/api/server/channels/server_channel.dart';
import 'package:mineral/api/server/server_message.dart';
import 'package:mineral/api/server/server_reaction.dart';
import 'package:mineral/infrastructure/internals/marshaller/marshaller.dart';
import 'package:mineral/infrastructure/internals/packets/listenable_packet.dart';
import 'package:mineral/infrastructure/internals/packets/packet_type.dart';
import 'package:mineral/infrastructure/internals/wss/shard_message.dart';
import 'package:mineral/infrastructure/services/logger/logger.dart';

final class MessageReactionAddPacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.messageReactionAdd;

  final LoggerContract logger;
  final MarshallerContract marshaller;

  const MessageReactionAddPacket(this.logger, this.marshaller);

  @override
  Future<void> listen(ShardMessage message, DispatchEvent dispatch) async {
    final guildId = message.payload['guild_id'];

    if (guildId != null) {
      return listenServer(message.payload, dispatch);
    }

    return listenPrivate(message.payload, dispatch);
  }

  Future<void> listenPrivate(Map<String, dynamic> payload, DispatchEvent dispatch) async {
    final user = await marshaller.dataStore.user.getUser(payload['user_id']);
    final channel = await marshaller.dataStore.channel.getChannel(payload['channel_id']) as PrivateChannel;
    final message = await marshaller.dataStore.channel.getMessage<PrivateMessage>(payload['channel_id'], payload['message_id']) as PrivateMessage;

    print('User ${user.username} reacted to a message in channel ${channel.name}, message: ${message.content}');
    print('Reactions: ${message.reactions.length}');
  }

  Future<void> listenServer(Map<String, dynamic> payload, DispatchEvent dispatch) async {
    final server = await marshaller.dataStore.server.getServer(payload['guild_id']);
    final member = await marshaller.dataStore.member.getMember(guildId: payload['guild_id'], memberId: payload['user_id'])
    ..server = server;
    final channel = await marshaller.dataStore.channel.getChannel(payload['channel_id']) as ServerChannel
    ..server = server;
    final message = await marshaller.dataStore.channel.getMessage<ServerMessage>(payload['channel_id'], payload['message_id'], guildId: payload['guild_id'])
        as ServerMessage;

    print('Member ${member.username} reacted to a message in channel ${channel.name}, message: ${message.content}, reaction: ${payload['emoji']}');
    print('Reactions: ${message.reactions.length}');
    ServerReaction? reaction = message.reactions.firstWhereOrNull((element) => element.emoji.name == payload['emoji']['name']);


    if (reaction != null) {
      reaction.incrementCount();
    } else {
      final member = payload['member'] != null ? await Marshaller.singleton().serializers.member.serialize({
        'guild_roles': server.roles.list.values.toList(),
        ...payload['member'],
      }) : null;
      final reactionProperties = ReactionProperties.fromJson(payload, member);
      reaction = ServerReaction(reactionProperties);

      message.reactions.add(reaction);
    }

    print('Reactions: ${message.reactions.length} two');
  }
}
