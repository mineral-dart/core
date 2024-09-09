import 'package:mineral/src/api/common/channel.dart';
import 'package:mineral/src/api/common/channel_properties.dart';
import 'package:mineral/src/api/common/managers/message_manager.dart';
import 'package:mineral/src/api/common/snowflake.dart';
import 'package:mineral/src/api/common/types/channel_type.dart';
import 'package:mineral/src/api/private/private_message.dart';
import 'package:mineral/src/api/private/user.dart';

final class PrivateGroupChannel extends Channel {
  final ChannelProperties _properties;

  final MessageManager<PrivateMessage> messages = MessageManager();

  @override
  Snowflake get id => _properties.id;

  @override
  ChannelType get type => _properties.type;

  List<User> get users => _properties.recipients;

  PrivateGroupChannel(this._properties);
}
