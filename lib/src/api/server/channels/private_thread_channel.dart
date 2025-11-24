import 'package:mineral/api.dart';
import 'package:mineral/src/api/common/managers/message_manager.dart';
import 'package:mineral/src/api/server/threads/thread_metadata.dart';

class PrivateThreadChannel extends ServerChannel implements ThreadChannel {
  late final ChannelMethods _methods;

  late final MessageManager<ServerMessage> messages;

  @override
  final ChannelType type = ChannelType.guildPrivateThread;

  @override
  final Snowflake id;

  @override
  final String name;

  @override
  final Snowflake serverId;

  @override
  DateTime get createdAt => id.createdAt;

  final String channelId;

  final ThreadMetadata metadata;

  final String? lastMessageId;

  final int rateLimitPerUser;

  final DateTime? lastPinTimestamp;

  final int messageCount;

  final int flags;

  final String ownerId;

  final int position = 0;

  final List<ChannelPermissionOverwrite> permissions;

  PrivateThreadChannel({
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
    _methods = ChannelMethods(null, id);
    messages = MessageManager(id);
  }

  /// Sets the name of the channel.
  ///
  /// ```dart
  /// await channel.setName('new-name');
  /// ```
  Future<void> setName(String name, {String? reason}) =>
      _methods.setName(name, reason);

  /// Sets the description of the channel.
  ///
  /// ```dart
  /// await channel.setDescription('new-description');
  /// ```
  Future<void> setDescription(String description, {String? reason}) =>
      _methods.setDescription(description, reason);

  /// Sets the category of the channel.
  ///
  /// ```dart
  /// await channel.setCategory('new-category-id');
  /// ```
  Future<void> setCategory(String categoryId, {String? reason}) =>
      _methods.setCategory(categoryId, reason);

  /// Sets the position of the channel.
  ///
  /// ```dart
  /// await channel.setPosition(1);
  /// ```
  Future<void> setPosition(int position, {String? reason}) =>
      _methods.setPosition(position, reason);

  /// Sets the NSFW status of the channel.
  ///
  /// ```dart
  /// await channel.setNsfw(true);
  /// ```
  Future<void> setNsfw(bool value, {String? reason}) =>
      _methods.setNsfw(value, reason);

  /// Sets the rate limit per user for the channel.
  ///
  /// ```dart
  /// await channel.setRateLimitPerUser(10);
  /// ```
  Future<void> setRateLimitPerUser(Duration value, {String? reason}) =>
      _methods.setRateLimitPerUser(value, reason);

  /// Sets the default auto-archive duration for the channel.
  ///
  /// ```dart
  /// await channel.setDefaultAutoArchiveDuration(60);
  /// ```
  Future<void> setDefaultAutoArchiveDuration(Duration value,
          {String? reason}) =>
      _methods.setDefaultAutoArchiveDuration(value, reason);

  /// Sets the default thread rate limit per user for the channel.
  ///
  /// ```dart
  /// await channel.setDefaultThreadRateLimitPerUser(10);
  /// ```
  Future<void> setDefaultThreadRateLimitPerUser(Duration value,
          {String? reason}) =>
      _methods.setDefaultThreadRateLimitPerUser(value, reason);

  /// Sends a message to the channel.
  ///
  /// ```dart
  /// await channel.send(content: 'Hello, world!');
  /// ```
  Future<void> send(MessageBuilder builder) =>
      _methods.send(serverId: serverId, builder: builder);

  /// Deletes the channel.
  ///
  /// ```dart
  /// await channel.delete();
  /// ```
  Future<void> delete({String? reason}) => _methods.delete(reason);
}
