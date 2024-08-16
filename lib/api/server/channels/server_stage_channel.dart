import 'package:mineral/api/common/channel_methods.dart';
import 'package:mineral/api/common/channel_permission_overwrite.dart';
import 'package:mineral/api/common/channel_properties.dart';
import 'package:mineral/api/common/embed/message_embed.dart';
import 'package:mineral/api/common/managers/message_manager.dart';
import 'package:mineral/api/common/polls/poll.dart';
import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/common/types/channel_type.dart';
import 'package:mineral/api/server/channels/server_category_channel.dart';
import 'package:mineral/api/server/channels/server_channel.dart';
import 'package:mineral/api/server/server_message.dart';

final class ServerStageChannel extends ServerChannel {
  final ChannelProperties _properties;
  final ChannelMethods _methods;

  final MessageManager<ServerMessage> messages = MessageManager();

  @override
  Snowflake get id => _properties.id;

  @override
  ChannelType get type => _properties.type;

  @override
  String get name => _properties.name!;

  @override
  int get position => _properties.position!;

  @override
  List<ChannelPermissionOverwrite> get permissions => _properties.permissions!;

  String? get description => _properties.description;

  @override
  Snowflake get guildId => _properties.guildId!;

  Snowflake? get categoryId => _properties.categoryId;

  late final ServerCategoryChannel? category;

  ServerStageChannel(this._properties) : _methods = ChannelMethods(_properties.id);

  /// Sets the channel's name.
  ///
  /// - `name` The new name for the channel.
  /// - `reason` (optional) The reason for the change.
  /// 
  /// Example:
  /// ```dart
  /// channel.setName("forum");
  /// ```
  Future<void> setName(String name, {String? reason}) => _methods.setName(name, reason);

  /// Sets the channel's description.
  ///
  /// - `description` The new description for the channel.
  /// - `reason` (optional) The reason for the change.
  /// 
  /// Example:
  /// ```dart
  /// channel.setDescription("The server's forum.");
  /// ```
  Future<void> setDescription(String description, {String? reason}) =>
      _methods.setDescription(description, reason);

  /// Moves the channel into a new catory.
  ///
  /// - `categoryId` The new channel's category id.
  /// - `reason` (optional) The reason for the change.
  /// 
  /// Example:
  /// ```dart
  /// channel.setCategory("1269941999021199380");
  /// ```
  Future<void> setCategory(String categoryId, {String? reason}) =>
      _methods.setCategory(categoryId, reason);

  /// Sets the channel's position in the category or in the channels list.
  ///
  /// - `position` The new channel's position.
  /// - `reason` (optional) The reason for the change.
  /// 
  /// Example:
  /// ```dart
  /// channel.setPosition(5);
  /// ```
  Future<void> setPosition(int position, {String? reason}) =>
      _methods.setPosition(position, reason);

  /// Enables or disables NSFW (Not Safe For Work) mode for the channel.
  ///
  /// - `nsfw` A boolean that indicates if NSFW mode is enabled or not.
  /// - `reason` (optional) The reason for the change.
  /// 
  /// Example:
  /// ```dart
  /// channel.setNsfw(true);
  /// ```
  Future<void> setNsfw(bool nsfw, {String? reason}) => _methods.setNsfw(nsfw, reason);

  /// Sets the rate limit per user for the channel.
  ///
  ///- `rateLimitPerUser` The new rate limit per user (in minutes) that can be from 0 to 21600.
  /// - `reason` (optional) The reason for the change.
  /// 
  /// Example:
  /// ```dart
  /// channel.setRateLimitPerUser(3600);
  /// ```
  Future<void> setRateLimitPerUser(int rateLimitPerUser, {String? reason}) =>
      _methods.setRateLimitPerUser(rateLimitPerUser, reason);

  /// Sets auto archive duration.
  ///
  ///- `defaultAutoArchiveDuration` The new auto ar duration (in minutes) that can be `60`, `1440`, `4320` or `10080`.
  /// - `reason` (optional) The reason for the change.
  /// 
  /// Example:
  /// ```dart
  /// channel.setDefaultAutoArchiveDuration(60);
  /// ```
  Future<void> setDefaultAutoArchiveDuration(int defaultAutoArchiveDuration, {String? reason}) =>
      _methods.setDefaultAutoArchiveDuration(defaultAutoArchiveDuration, reason);

  /// Sets the thread rate limit per user for the channel.
  ///
  ///- `value` The new thread rate limit per user.
  /// - `reason` (optional) The reason for the change.
  /// 
  /// Example:
  /// ```dart
  /// channel.setDefaultThreadRateLimitPerUser(5);
  /// ```
  Future<void> setDefaultThreadRateLimitPerUser(int value, {String? reason}) =>
      _methods.setDefaultThreadRateLimitPerUser(value, reason);

  /// Sends a message in the channel.
  ///
  ///- `content` (optional) The message's content.
  /// - `embeds` (optional) A list of embeds to include in the message.
  /// - `poll` (optional) A poll to include in the message.
  /// 
  /// Note: A least one of `content`, `embeds`, or `poll` is required.
  /// 
  /// Examples:
  /// ```dart
  /// channel.send(content: "Hello world!");
  /// ```
  /// 
  /// ```dart
  /// channel.send(embeds: [embed]);
  /// ```
  /// 
  /// ```dart
  /// channel.send(poll: poll);
  /// ```
  Future<void> send({String? content, List<MessageEmbed>? embeds, Poll? poll}) =>
      _methods.send(guildId: _properties.guildId, content: content, embeds: embeds, poll: poll);

  /// Deletes the channel.
  ///
  /// - `reason` (optional) The reason for the change.
  /// 
  /// Example:
  /// ```dart
  /// channel.delete();
  /// ```
  Future<void> delete({String? reason}) => _methods.delete(reason);
}
