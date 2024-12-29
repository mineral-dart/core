import 'package:mineral/api.dart';
import 'package:mineral/src/api/common/managers/message_manager.dart';

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
