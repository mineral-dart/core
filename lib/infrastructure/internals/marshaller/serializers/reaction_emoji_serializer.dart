import 'dart:async';

import 'package:mineral/api/common/channel.dart';
import 'package:mineral/api/common/reaction_emoji.dart';
import 'package:mineral/api/common/types/channel_type.dart';
import 'package:mineral/api/private/channels/private_channel.dart';
import 'package:mineral/api/private/user.dart';
import 'package:mineral/api/server/channels/server_channel.dart';
import 'package:mineral/api/server/server.dart';
import 'package:mineral/domains/marshaller/marshaller.dart';
import 'package:mineral/domains/marshaller/types/serializer.dart';

final class ReactionEmojiSerializer implements SerializerContract<ReactionEmoji<Channel>> {
  final MarshallerContract _marshaller;

  ReactionEmojiSerializer(this._marshaller);

  @override
  Future<ReactionEmoji<Channel>> serialize(Map<String, dynamic> json) async {
    json['emoji']['guildRoles'] = Iterable.empty();
    json['emoji']['roles'] = Iterable.empty();
    final emoji = await _marshaller.serializers.emojis.serialize(json['emoji']);
    final channel = await _marshaller.dataStore.channel.getChannel(json['channel_id']);
    Server? server;
    final List<User> users = [];

    if (json['server_id'] != null) {
      server = await _marshaller.dataStore.server.getServer(json['server_id']);
    }

    if (json['users'] != null) {
      for (final userRaw in json['users']) {
        users.add(await _marshaller.serializers.user.serialize(userRaw));
      }
    }

    return switch (channel?.type) {
      ChannelType.dm => ReactionEmoji<PrivateChannel>(emoji: emoji, channel: channel as PrivateChannel, users: users),
      ChannelType.guildText => ReactionEmoji<ServerChannel>(emoji: emoji, server: server, channel: channel as ServerChannel, users: users),
      _ => ReactionEmoji(emoji: emoji, users: users),
    };
  }

  @override
  Map<String, dynamic> deserialize(ReactionEmoji emoji) {
    return {};
  }
}
