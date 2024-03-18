import 'package:mineral/api/common/channel.dart';
import 'package:mineral/api/common/channel_properties.dart';
import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/common/types/channel_type.dart';
import 'package:mineral/api/private/user.dart';

final class PrivateChannel extends Channel {
  final ChannelProperties _properties;

  @override
  Snowflake get id => _properties.id;

  @override
  ChannelType get type => _properties.type;

  @override
  String get name => _properties.name;

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
