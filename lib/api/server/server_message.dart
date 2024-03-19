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

  final String userId;

  final Member author;

  ServerMessage(this._properties, {
    required this.userId,
    required this.author,
  });
}
