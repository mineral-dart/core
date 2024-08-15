import 'package:mineral/api/common/channel_methods.dart';
import 'package:mineral/api/common/channel_permission_overwrite.dart';
import 'package:mineral/api/common/components/message_component.dart';
import 'package:mineral/api/common/embed/message_embed.dart';
import 'package:mineral/api/common/managers/message_manager.dart';
import 'package:mineral/api/common/polls/poll.dart';
import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/common/thread_properties.dart';
import 'package:mineral/api/common/types/channel_type.dart';
import 'package:mineral/api/server/channels/server_category_channel.dart';
import 'package:mineral/api/server/channels/server_channel.dart';
import 'package:mineral/api/server/channels/server_text_channel.dart';
import 'package:mineral/api/server/server_message.dart';
import 'package:mineral/api/server/threads/thread_member.dart';
import 'package:mineral/api/server/threads/thread_metadata.dart';

class ThreadChannel extends ServerChannel {
  final ThreadProperties _properties;
  final ChannelMethods _methods;

  final MessageManager<ServerMessage> messages = MessageManager();

  @override
  Snowflake get id => _properties.id;

  @override
  ChannelType type;

  @override
  String get name => _properties.name!;

  @override
  List<ChannelPermissionOverwrite> get permissions => _properties.permissions ?? [];

  String? get description => _properties.description;

  Snowflake get channelId => _properties.channelId!;

  int? get rateLimitPerUser => _properties.rateLimitPerUser;

  int get memberCount => _properties.memberCount ?? 0;

  List<ThreadMember> members = [];

  ThreadMember get owner => _properties.owner!;

  ServerTextChannel get channel => _properties.channel!;

  ThreadMetadata get metadata => _properties.metadata;

  @override
  Snowflake get serverId => _properties.guildId!;

  late final ServerCategoryChannel? category;

  ThreadChannel(this._properties, this.type) : _methods = ChannelMethods(_properties.id);

  Future<void> setName(String name, {String? reason}) => _methods.setName(name, reason);

  Future<void> setDescription(String description, {String? reason}) => _methods.setDescription(description, reason);

  Future<void> setRateLimitPerUser(int rateLimitPerUser, {String? reason}) => _methods.setRateLimitPerUser(rateLimitPerUser, reason);

  Future<void> setDefaultAutoArchiveDuration(int defaultAutoArchiveDuration, {String? reason}) =>
      _methods.setDefaultAutoArchiveDuration(defaultAutoArchiveDuration, reason);

  Future<void> setDefaultThreadRateLimitPerUser(int value, {String? reason}) => _methods.setDefaultThreadRateLimitPerUser(value, reason);

  Future<void> send({String? content, List<MessageEmbed>? embeds, Poll? poll, List<MessageComponent>? components}) =>
      _methods.send(guildId: _properties.guildId, content: content, embeds: embeds, poll: poll, components: components);

  Future<void> delete({String? reason}) => _methods.delete(reason);

  @override
  int get position => 0;
}
