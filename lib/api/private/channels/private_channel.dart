import 'package:mineral/api/common/channel.dart';
import 'package:mineral/api/common/channel_properties.dart';
import 'package:mineral/api/common/managers/message_manager.dart';
import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/common/types/channel_type.dart';
import 'package:mineral/api/private/private_message.dart';
import 'package:mineral/api/private/user.dart';

final class PrivateChannel extends Channel {
  final ChannelProperties _properties;

  final MessageManager<PrivateMessage> messages = MessageManager();

  @override
  Snowflake get id => _properties.id;

  @override
  ChannelType get type => _properties.type;

  String get name => _properties.name!;

  String get description => _properties.description!;

  int get messageCount => _properties.messageCount!;

  int get userCount => recipients.length;

  List<User> get recipients => _properties.recipients;

  PrivateChannel(this._properties);

  // factory PrivateChannel.fromJson(Map<String, dynamic> json) {
  //   final List<User> recipients = [];
  //
  //   for (final recipient in json['recipients']) {
  //     recipients.add(User.fromJson(recipient));
  //   }
  //
  //   return PrivateChannel(
  //     id: Snowflake(json['id']),
  //     name: recipients.map((e) => e.username).join(', '),
  //     recipients: recipients,
  //   );
  // }
}
