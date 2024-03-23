import 'package:mineral/api/common/embed/message_embed.dart';
import 'package:mineral/api/common/message.dart';
import 'package:mineral/api/common/message_properties.dart';
import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/server/channels/server_channel.dart';
import 'package:mineral/api/server/member.dart';

final class ServerMessage extends Message {
  final MessageProperties<ServerChannel> _properties;

  @override
  Snowflake get id => _properties.id;

  @override
  String get content => _properties.content;

  List<MessageEmbed> get embeds => _properties.embeds;

  ServerChannel get channel => _properties.channel;

  DateTime get createdAt => _properties.createdAt;

  DateTime? get updatedAt => _properties.updatedAt;

  final String userId;

  final Member author;

  ServerMessage(this._properties, {
    required this.userId,
    required this.author,
  });
}
