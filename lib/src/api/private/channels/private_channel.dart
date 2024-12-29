import 'package:mineral/api.dart';
import 'package:mineral/src/api/common/managers/message_manager.dart';

final class PrivateChannel extends Channel {
  final ChannelProperties _properties;

  final MessageManager<PrivateMessage> messages = MessageManager();

  @override
  Snowflake get id => _properties.id;

  @override
  ChannelType get type => _properties.type;

  String get name => _properties.name ?? recipients.map((e) => e.username).join(', ');

  String get description => _properties.description!;

  int get messageCount => _properties.messageCount!;

  int get userCount => recipients.length;

  List<User> get recipients => _properties.recipients;

  PrivateChannel(this._properties);
}
