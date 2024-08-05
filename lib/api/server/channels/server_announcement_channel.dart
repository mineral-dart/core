import 'package:mineral/api/common/channel_methods.dart';
import 'package:mineral/api/common/channel_permission_overwrite.dart';
import 'package:mineral/api/common/channel_properties.dart';
import 'package:mineral/api/common/managers/message_manager.dart';
import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/common/types/channel_type.dart';
import 'package:mineral/api/server/channels/server_category_channel.dart';
import 'package:mineral/api/server/channels/server_channel.dart';
import 'package:mineral/api/server/server_message.dart';

final class ServerAnnouncementChannel extends ServerChannel {
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

  bool get isNsfw => _properties.nsfw;

  @override
  Snowflake get guildId => _properties.guildId!;

  Snowflake? get categoryId => _properties.categoryId;

  late final ServerCategoryChannel? category;

  ServerAnnouncementChannel(this._properties)
      : _methods = ChannelMethods(_properties.id);

  /// Sets the channel's name.
  ///
  /// - `name` The new name for the channel.
  /// - `reason` (optional) The reason for the change.
  /// 
  /// Example:
  /// ```dart
  /// channel.setName("announcements");
  /// ```
  Future<void> setName(String name, {String? reason}) =>
      _methods.setName(name, reason);

  /// Sets the channel's description.
  ///
  /// - `description` The new description for the channel.
  /// - `reason` (optional) The reason for the change.
  /// 
  /// Example:
  /// ```dart
  /// channel.setDescription("A channel for the news.");
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
  Future<void> setNsfw(bool nsfw, {String? reason}) =>
      _methods.setNsfw(nsfw, reason);

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
