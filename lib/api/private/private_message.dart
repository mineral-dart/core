import 'package:mineral/api/common/embed/message_embed.dart';
import 'package:mineral/api/common/message.dart';
import 'package:mineral/api/common/message_properties.dart';
import 'package:mineral/api/common/reaction_emoji.dart';
import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/private/channels/private_channel.dart';
import 'package:mineral/api/private/user.dart';

final class PrivateMessage implements Message<PrivateChannel> {
  final MessageProperties<PrivateChannel> _properties;

  @override
  Snowflake get id => _properties.id;

  @override
  String get content => _properties.content;

  List<MessageEmbed> get embeds => _properties.embeds;

  @override
  Snowflake get channelId => _properties.channelId;

  @override
  late final PrivateChannel channel;

  DateTime get createdAt => _properties.createdAt;

  DateTime? get updatedAt => _properties.updatedAt;

  @override
  List<ReactionEmoji<PrivateChannel>> get reactions => _properties.reactions;

  final String userId;

  final User user;

  PrivateMessage(this._properties, {
    required this.userId,
    required this.user,
  });
}
