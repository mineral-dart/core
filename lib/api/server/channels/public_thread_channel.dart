import 'package:mineral/api/common/channel_methods.dart';
import 'package:mineral/api/common/managers/message_manager.dart';
import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/common/thread_properties.dart';
import 'package:mineral/api/common/types/channel_type.dart';
import 'package:mineral/api/server/channels/thread_channel.dart';
import 'package:mineral/api/server/server_message.dart';

final class PublicThreadChannel extends ThreadChannel {
  final ThreadProperties _properties;
  final ChannelMethods _methods;

  final MessageManager<ServerMessage> messages = MessageManager();

  @override
  Snowflake get id => _properties.id;

  @override
  ChannelType get type => ChannelType.guildPublicThread;

  PublicThreadChannel(this._properties) : _methods = ChannelMethods(_properties.id), super(_properties, ChannelType.guildPublicThread);
}
