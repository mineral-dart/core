import 'package:mineral/api/common/message.dart';
import 'package:mineral/api/common/message_properties.dart';
import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/private/channels/private_channel.dart';
import 'package:mineral/api/private/user.dart';

final class PrivateMessage implements Message {
  final MessageProperties<PrivateChannel> _properties;

  @override
  Snowflake get id => _properties.id;

  @override
  String get content => _properties.content;

  final String userId;

  final User user;

  PrivateMessage(this._properties, {
    required this.userId,
    required this.user,
  });
}
