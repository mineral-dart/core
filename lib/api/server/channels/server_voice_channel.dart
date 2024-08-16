import 'package:mineral/api/common/channel_methods.dart';
import 'package:mineral/api/common/channel_permission_overwrite.dart';
import 'package:mineral/api/common/channel_properties.dart';
import 'package:mineral/api/common/managers/message_manager.dart';
import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/common/types/channel_type.dart';
import 'package:mineral/api/common/video_quality.dart';
import 'package:mineral/api/server/channels/server_category_channel.dart';
import 'package:mineral/api/server/channels/server_channel.dart';
import 'package:mineral/api/server/server_message.dart';

final class ServerVoiceChannel extends ServerChannel {
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

  @override
  Snowflake get guildId => _properties.guildId!;

  Snowflake? get categoryId => _properties.categoryId;

  late final ServerCategoryChannel? category;

  ServerVoiceChannel(this._properties) : _methods = ChannelMethods(_properties.id);

  /// Sets the channel's name.
  ///
  /// - `name` The new name for the channel.
  /// - `reason` (optional) The reason for the change.
  ///
  /// Example:
  /// ```dart
  /// channel.setName("welcome");
  /// ```
  Future<void> setName(String name, {String? reason}) => _methods.setName(name, reason);

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

  /// Sets the bitrate for the channel.
  ///
  /// - `bitrate` The new bitrate for the channel (in bits) that can be from 8000
  /// - `reason` (optional) The reason for the change.
  /// 
  /// Example:
  /// ```dart
  /// channel.setBitrate(8000);
  /// ```
  Future<void> setBitrate(int bitrate, {String? reason}) => _methods.setBitrate(bitrate, reason);

  /// Sets the user limit for the channel.
  ///
  /// - `userLimit` The new user limit for the channel.
  /// - `reason` (optional) The reason for the change.
  /// 
  /// Example:
  /// ```dart
  /// channel.setUserLimit(2);
  /// ```
  Future<void> setUserLimit(int userLimit, {String? reason}) => _methods.setUserLimit(userLimit, reason);

  Future<void> setRtcRegion(String rtcRegion, {String? reason}) => _methods.setRtcRegion(rtcRegion, reason);


    /// Sets the video quality for the channel.
    ///
    /// - `reason` (optional) The reason for the change.
    /// 
    /// Example:
    /// ```dart
    /// channel.setVideoQuality(VideoQuality.auto)
    /// ```
  Future<void> setVideoQuality(VideoQuality quality, {String? reason}) =>
      _methods.setVideoQuality(quality, reason);

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
