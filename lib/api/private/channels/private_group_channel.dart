import 'package:mineral/api/common/channel.dart';
import 'package:mineral/api/common/channel_properties.dart';
import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/common/types/channel_type.dart';
import 'package:mineral/api/private/user.dart';

final class PrivateGroupChannel extends Channel {
  final ChannelProperties _properties;

  @override
  Snowflake get id => _properties.id;

  @override
  ChannelType get type => _properties.type;

  List<User> get users => _properties.recipients;

  PrivateGroupChannel(this._properties);
}
