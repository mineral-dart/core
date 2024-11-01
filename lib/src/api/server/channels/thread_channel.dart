import 'package:mineral/src/api/common/channel_methods.dart';
import 'package:mineral/src/api/common/channel_permission_overwrite.dart';
import 'package:mineral/src/api/common/components/message_component.dart';
import 'package:mineral/src/api/common/embed/message_embed.dart';
import 'package:mineral/src/api/common/managers/message_manager.dart';
import 'package:mineral/src/api/common/polls/poll.dart';
import 'package:mineral/src/api/common/snowflake.dart';
import 'package:mineral/src/api/common/types/channel_type.dart';
import 'package:mineral/src/api/server/channels/server_channel.dart';
import 'package:mineral/src/api/server/channels/server_text_channel.dart';
import 'package:mineral/src/api/server/managers/threads_manager.dart';
import 'package:mineral/src/api/server/member.dart';
import 'package:mineral/src/api/server/server.dart';
import 'package:mineral/src/api/server/server_message.dart';
import 'package:mineral/src/api/server/threads/thread_metadata.dart';

class ThreadChannel extends ServerChannel {
  late final ChannelMethods _methods;

  final MessageManager<ServerMessage> messages = MessageManager();

  @override
  final ChannelType type = ChannelType.guildPrivateThread;

  @override
  final Snowflake id;

  @override
  final String name;

  @override
  final Snowflake serverId;

  final String channelId;

  final ThreadMetadata metadata;

  int get memberCount => members.length;

  final String? lastMessageId;

  final int rateLimitPerUser;

  final DateTime? lastPinTimestamp;

  final int messageCount;

  final int flags;

  final String ownerId;

  @override
  final int position = 0;

  @override
  final List<ChannelPermissionOverwrite> permissions;

  @override
  ThreadsManager threads = ThreadsManager({});

  @override
  late final Server server;

  late final ServerTextChannel parentChannel;

  late final Map<Snowflake, Member> members;

  late final Member owner;

  ThreadChannel({
    required this.id,
    required this.name,
    required this.serverId,
    required this.channelId,
    required this.metadata,
    required this.lastMessageId,
    required this.rateLimitPerUser,
    required this.lastPinTimestamp,
    required this.messageCount,
    required this.flags,
    required this.ownerId,
    required this.permissions,
  }) {
    _methods = ChannelMethods(id);
  }

  /// Sets the name of the channel.
  ///
  /// ```dart
  /// await channel.setName('new-name');
  /// ```
  Future<void> setName(String name, {String? reason}) => _methods.setName(name, reason);

  /// Sets the description of the channel.
  ///
  /// ```dart
  /// await channel.setDescription('new-description');
  /// ```
  Future<void> setDescription(String description, {String? reason}) => _methods.setDescription(description, reason);

  /// Sets the category of the channel.
  ///
  /// ```dart
  /// await channel.setCategory('new-category-id');
  /// ```
  Future<void> setCategory(String categoryId, {String? reason}) => _methods.setCategory(categoryId, reason);

  /// Sets the position of the channel.
  ///
  /// ```dart
  /// await channel.setPosition(1);
  /// ```
  Future<void> setPosition(int position, {String? reason}) => _methods.setPosition(position, reason);

  /// Sets the NSFW status of the channel.
  ///
  /// ```dart
  /// await channel.setNsfw(true);
  /// ```
  Future<void> setNsfw(bool nsfw, {String? reason}) => _methods.setNsfw(nsfw, reason);

  /// Sets the rate limit per user for the channel.
  ///
  /// ```dart
  /// await channel.setRateLimitPerUser(10);
  /// ```
  Future<void> setRateLimitPerUser(int rateLimitPerUser, {String? reason}) => _methods.setRateLimitPerUser(rateLimitPerUser, reason);

  /// Sets the default auto-archive duration for the channel.
  ///
  /// ```dart
  /// await channel.setDefaultAutoArchiveDuration(60);
  /// ```
  Future<void> setDefaultAutoArchiveDuration(int defaultAutoArchiveDuration, {String? reason}) =>
      _methods.setDefaultAutoArchiveDuration(defaultAutoArchiveDuration, reason);

  /// Sets the default thread rate limit per user for the channel.
  ///
  /// ```dart
  /// await channel.setDefaultThreadRateLimitPerUser(10);
  /// ```
  Future<void> setDefaultThreadRateLimitPerUser(int value, {String? reason}) => _methods.setDefaultThreadRateLimitPerUser(value, reason);

  /// Sends a message to the channel.
  ///
  /// ```dart
  /// await channel.send(content: 'Hello, world!');
  /// ```
  Future<void> send({String? content, List<MessageEmbed>? embeds, Poll? poll, List<MessageComponent>? components}) =>
      _methods.send(guildId: serverId, content: content, embeds: embeds, poll: poll, components: components);

  /// Deletes the channel.
  ///
  /// ```dart
  /// await channel.delete();
  /// ```
  Future<void> delete({String? reason}) => _methods.delete(reason);
}
